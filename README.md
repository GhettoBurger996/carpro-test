# Prepare your app

Copy `.env.development.sample` to `.env.development`

Install javascript. Parcel bundler builds the file

```
npm i parcel-bundler -g
npm install
```

Create the Postgres database and migrate

```
$ createdb carpro_dev
$ rake db:migrate
```

Run the app using Foreman with the Procfile.dev file to run development

```
foreman s -f Procfile.dev
```


# Release

Add this if heroku is not in your git remote

```
heroku git:remote -a carpro-web
```

Run this to deploy to heroku

```
rake release
```


# Using the console

Console gives you a REPL to experiment with the database

```
$ bin/console

#> Car.first

=> <Car @values={:cam_id=>240027164, :country=>"my", :plate=>"WC3918Y", :time_start=>2020-01-16 16:54:52 +0800, :time_end=>2020-01-16 16:54:52 +0800}>
```

## Using console in heroku

Heroku allows running commands

```
$ heroku run bin/console
```

# Dashboard design

Grab inspiration from here if needed.

https://cdn.dribbble.com/users/18730/screenshots/3866210/filters-vide7.gif

