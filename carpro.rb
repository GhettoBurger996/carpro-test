require "roda"
require "oj"
require "pagy"
require "pry" if ENV["RACK_ENV"] == "development"

require_relative "./models"

class Carpro < Roda
  plugin :sessions,
    max_seconds: 86400*365,
    key: "_Carpro.session",
    secret: "63570008b022df33ef9f2ca2fc642b1ef21fa328cb051909ccbca3227b497119"
  plugin :timestamp_public
  plugin :empty_root
  plugin :json
  plugin :flash
  plugin :render, engine: "slim"
  plugin :partials, views: "views"
  plugin :symbol_views
  plugin :indifferent_params
  include Pagy::Frontend
  include Pagy::Backend

  route do |r|
    r.timestamp_public

    @current_user = User[r.session["user_id"]] if r.session["user_id"]

    r.root do
      r.redirect "/login"
    end

    r.get "logout" do
      r.session["user_id"] = nil
      r.redirect "/login"
    end

    r.is "login" do
      r.get do
        r.redirect "/cars" if current_user

        view :login
      end

      r.post do
        user = User[username: r.params[:username]]

        if user&.authenticate?(r.params[:password])
          r.session["user_id"] = user.id
          r.redirect "/cars"
        else
          flash.now["err"] = "Username/Password don't match"
          view :login
        end
      end
    end

    r.post "alpr" do
      data = Oj.load(request.body.read)

      if data["data_type"] == "alpr_group"
        Car.create_from_feed(data)
      end

      { status: "OK" }
    end

    r.on "cars" do
      authenticate!

      r.is do
        r.get do
          query = Car.select{ [:plate, max(:time_start).as(:max_time_start)] }
                     .order(:max_time_start)
                     .group(:plate)

          @pagy, @cars = pagy(query)
          view "cars/index"
        end
      end

      r.on String do |plate|
        r.is do
          @car = Car.first(plate: plate)
          @entries = Car.where(plate: plate).exclude(id: @car.id)

          view "cars/show"
        end

        r.get Integer do |id|
          @car = Car[id]
          @entries = Car.where(plate: plate).exclude(id: id)

          view "cars/show"
        end
      end
    end

    r.on "users" do
      authenticate!

      r.is do
        r.get do
          @pagy, @users = pagy(User.order(:id))

          view "users/index"
        end

        r.post do
          @user = User.new(r.params[:user])

          if @user.save
            flash["success"] = "Successfully created User"
            r.redirect "/users"
          else
            view "users/new"
          end
        end
      end

      r.get "new" do
        @user = User.new

        view "users/new"
      end

      r.on Integer do |id|
        unless current_user.admin?
          flash["err"] = "You do not have access"
          request.redirect "/users"
        end

        @user = User[id]

        r.is do
          r.get do
            view "users/show"
          end

          r.post do
            if @user.update_fields(r.params[:user], [:password, :level])
              flash["success"] = "Updated user"
              r.redirect "/users"
            else
              view "users/show"
            end
          end
        end

        r.get "delete" do
          @user.delete

          flash["success"] = "Deleted user"
          r.redirect "/users"
        end
      end
    end
  end

  def human_time(time)
    return unless time
    time.strftime("%d-%m-%Y, %r")
  end

  def current_user
    @current_user
  end

  def authenticate!
    request.redirect "/" unless current_user
  end

  def pagy_get_vars(collection, vars)
    {
      count: collection.count,
      page: request.params["page"],
      items: vars[:items] || 20
    }
  end
end
