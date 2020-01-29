ENV["RACK_ENV"] ||= "development"

if %w[development test].include?(ENV["RACK_ENV"])
  require "dotenv"
require "pry"
  Dotenv.load(".env", ".env.#{ENV["RACK_ENV"]}")
end

