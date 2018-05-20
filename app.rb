require 'sinatra'
require 'socket'
require 'json'
require 'httparty'

INCOMING_HEADERS = [
  'x-request-id',
  'x-b3-traceid',
  'x-b3-spanid',
  'x-b3-parentspanid',
  'x-b3-sampled',
  'x-b3-flags',
  'x-ot-span-context'
]

get '/' do
  erb :index
end

get '/health' do
  'ok'
end

get '/hostname' do
  Socket.gethostname
end

get '/version' do
  'v2'
end

get '/internal/v1/users' do
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

post '/external/v1/login' do
  content_type :json
  
  {
    "id": 1,
    "name": "subicura"
  }.to_json
end

post '/external/v1/signup' do
  content_type :json
  status 201
  
  {
    "id": 1,
    "name": "subicura"
  }.to_json
end

get '/external/v1/details' do
  # add hint - https://istio.io/docs/tasks/telemetry/distributed-tracing.html
  HTTParty.get('http://details:9080/details/0', headers: zipkin_headers)

  content_type :json
  status 200
  
  {
    "message": "Details"
  }.to_json
end


get '/external/v1/200' do
  content_type :json
  status 200
  
  {
    "message": "200 Ok"
  }.to_json
end


get '/external/v1/400' do
  content_type :json
  status 400
  
  {
    "message": "400 Bad Request"
  }.to_json
end

get '/external/v1/500' do
  content_type :json
  status 500
  
  {
    "message": "500 Internal Server Error"
  }.to_json
end


def zipkin_headers
  ret = {}

  INCOMING_HEADERS.each do |h|
    ret[h] = env["HTTP_#{h.upcase.gsub('-', '_')}"] 
  end

  ret
end