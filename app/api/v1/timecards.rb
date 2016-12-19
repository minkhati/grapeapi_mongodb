# app/api/v1/timecards.rb
module API
  module V1
    class Timecards < Grape::API
      version 'v1', using: :path, vendor: 'Grape-API-MongoDB'

      resources :timecards do

        desc 'Returns all Time Cards'
        get do
          Timecard.all.ordered
        end

        desc "Return a specific Time Card"
        params do
          requires :card_id, type: Integer
        end
        get ':card_id' do
          Timecard.find_by(card_id:  "#{params[:card_id]}")
        end

        desc "Create a new Time Card"
        params do
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
          requires :card_id, type: Integer
          requires :username, type: String
          requires :occurrence, type: Date
        end
        put ':card_id' do
          timecard = Timecard.find_by(card_id:  "#{params[:card_id]}")
          timecard.update(username: params[:username],
                          occurrence: params[:occurrence])
        end

        desc "Delete a Time Card"
        params do
          requires :card_id, type: Integer
        end
        delete ':card_id' do
          Timecard.find_by(card_id:  "#{params[:card_id]}").destroy
        end

      end
    end
  end
end