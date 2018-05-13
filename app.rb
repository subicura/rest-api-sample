require 'sinatra'
require 'socket'
require 'json'

get '/' do
  erb :index
end

get '/healthz' do
  'ok'
end

get '/hostname' do
  Socket.gethostname
end

get '/admin/users' do
  content_type :json

  {
    "items": [
      {
        "id": 1,
        "name": "subicura"
      },
      {
        "id": 2,
        "name": "sophie"
      },
    ],
    "page": {
      "current_page": 1,
      "total_count": 2,
      "per_page": 20
    }
  }.to_json
end

post '/v1/login' do
  content_type :json
  
  {
    "id": 1,
    "name": "subicura"
  }.to_json
end

post '/v1/signup' do
  content_type :json
  status 201
  
  {
    "id": 1,
    "name": "subicura"
  }.to_json
end
