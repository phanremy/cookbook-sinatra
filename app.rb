require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative "lib/cookbook"
require_relative "lib/recipe"
set :bind, '0.0.0.0'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get '/' do
  # cookbook = Cookbook.new("lib/recipes.csv")
  erb :index
end

# get '/team/:username' do
#   puts params[:username]
#   "The username is #{params[:username]}"
# end
get '/' do
  erb :about
end
