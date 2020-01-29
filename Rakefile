require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "spec"
  t.libs << "lib"
  t.test_files = FileList["spec/**/*_spec.rb"]
end

task :default => :test

migrate = lambda do |version|
  require_relative "db"
  require "logger"
  Sequel.extension :migration
  DB.loggers << Logger.new($stdout) if DB.loggers.empty?
  Sequel::Migrator.apply(DB, 'migrate', version)
end

namespace :db do
  desc "migrate up"
  task :migrate do
    migrate.call(nil)
  end

  desc "migrate all the way to 0"
  task :down, [:version] do |_, args|
    version = (args[:version] || 0).to_i
    migrate.call(version)
  end

  desc "rollback version"
  task :rollback do |_, args|
    require_relative "db"
    current_version = DB.fetch("SELECT * FROM schema_info").first[:version]
    migrate.call(current_version - 1)
  end

  desc "dump schema into file"
  task :dump do
    require_relative "env"
    sh "sequel -d #{ENV["DATABASE_URL"]} > migrate/0001_base_schema.rb"
  end
end

desc "release to heroku"
task :release do
  sh 'npm run build'
  sh 'git add .'
  sh 'git commit -m "release"'
  sh 'git push heroku master'
end
