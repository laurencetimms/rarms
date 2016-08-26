require 'sinatra'
require 'json'
require 'sanitize'
require 'mongoid'

# model
require './models/user'  

# load database config
Mongoid.load! "mongoid.config"

# serializers
class UserSerializer

  def initialize(user)
    @user = user
  end

  def as_json(*)
    data = {
      username: @user.username,
      email: @user.email,
      password_hash: @user.password_hash
    }
    data[:errors] = @user.errors if @user.errors.any?
    data
  end

end

# endpoints
get '/' do
  'This is RARMS.'.to_json # let's return only json
end

before do
  # could format all responses as json here
end

# helpers
helpers do
  def base_url
    @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
  end

  def json_params
    begin
      JSON.parse(request.body.read)
    rescue
      halt 400, { message: 'Invalid JSON' }.to_json
    end
  end

  def user
    @user ||= User.where(id: params[:id]).first
  end

  def halt_if_not_found!
    halt(404, { message: 'User Not Found'}.to_json) unless user
  end

  def serialize(user)
    UserSerializer.new(user).to_json
  end
end

# return all the users
get '/users' do
  content_type 'application/json'
  users = User.all

  [:username, :email].each do |filter|
    users = users.send(filter, params[filter]) if params[filter]
  end

  users.map { |user| UserSerializer.new(user) }.to_json
end

# get user by username
get '/users/:username' do |username|
  content_type 'application/json'
  halt_if_not_found!
  serialize(user)
end

# create a new user
post '/users' do
  content_type 'application/json'
  user = User.new(json_params)
  halt 422, serialize(user) unless user.save # if we can't save successfully, return 422 unprocessable
  response.headers['Location'] = "#{base_url}/users/#{user.id}"
  status 201
end

# update user by username
patch '/users/:username' do |username|
  content_type 'application/json'
  halt_if_not_found!
  halt 422, serialize(user) unless user.update_attributes(json_params)
  serialize(user)
end

# delete user by username
delete '/users/:username' do |username|
  body = JSON.parse request.body.read
  if body['secretkey'].nil?
    halt 404
  end
  user.destroy if user
  status 204
end

