# app/api/v1/admin/timecards.rb
module API
  module V1
    module Admin
      class Timecards < Grape::API
        version 'v1', using: :path, vendor: 'Grape-API-MongoDB'

        namespace :admin do

          resources :timecards do

            desc 'Returns all Time Cards'
            get do
              Timecard.all.ordered
            end

            desc "Return a specific Time Card"
            params do
              requires :id, type: String
            end
            get ':id' do
              Timecard.find(params[:id])
            end

            desc "Create a new Time Card"
            params do
              #requires :timecard_id, type: Integer
              requires :username, type: String
              requires :occurrence, type: Date
            end
            post do
              Timecard.create!(
                               username: params[:username],
                               occurrence: params[:occurrence])
            end

            desc "Update a Time Card"
            params do
              requires :id, type: String
              requires :username, type: String
              requires :occurrence, type: Date
            end
            put ':id' do
              timecard = Timecard.find(params[:id])
              timecard.update(username: params[:username],
                              occurrence: params[:occurrence])
            end

            desc "Delete a Time Card"
            params do
              requires :id, type: Integer
            end
            delete ':id' do
              Timecard.find(params[:id]).destroy
            end

          end
        end
      end
    end
  end
end