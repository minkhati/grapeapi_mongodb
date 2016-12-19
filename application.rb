# application.rb
require 'grape'

require 'mongoid'
require 'autoinc'

Mongoid.load! "config/mongoid.config"

# Load files from the models and api folders
Dir["#{File.dirname(__FILE__)}/app/models/**/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/app/api/**/*.rb"].each { |f| require f }

# Grape API class. We will inherit from it in our future controllers.
module API
  class Root < Grape::API
    format :json
    prefix :api

    # Simple endpoint to get the current status of our API.
    get :status do
      { status: 'ok' }
    end

    #mount V1::Admin::Timecards
    mount V1::Timeentries
    mount V1::Timecards

  end
end

# Mounting the Grape application
TimeCard = Rack::Builder.new {

  map "/" do
    run API::Root
  end

}