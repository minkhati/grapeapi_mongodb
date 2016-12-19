# app/api/v1/timeentries.rb
require 'pry'

module API
  module V1
    class Timeentries < Grape::API
      version 'v1', using: :path, vendor: 'Grape-API-MongoDB'

      # Nested resource so we need to add the timecards namespace
      #namespace 'timecards/:timecard_id' do
        resources :timeentries do

          desc 'Returns all Time Entries'
          get do
            Timeentry.getAllEntries
          end

          desc "Return a specific Time Entry"
          params do
            requires :entry_id, type: Integer
          end
          get ':entry_id' do
            Timeentry.getAllEntries.select { |entry| entry["entry_id"] == params[:entry_id] }
          end

          desc 'Create a Time Entry.'
          params do
            requires :timecard_id, type: Integer
            requires :time, type: DateTime
          end
          post do
            timecard = Timecard.find_by(card_id: "#{params[:timecard_id]}")
            timecard.timeentries.create!({
                                      time: params[:time],
                                      timecard_id: params[:timecard_id]
                                   })
          end

          desc 'Update a Time Entry.'
          params do
            requires :entry_id, type: Integer
            requires :time, type: DateTime

          end
          put ':entry_id' do
            #timecard_id = Timeentry.getTimeCardId(params[:entry_id])
            timecard = Timecard.find_by(card_id: "#{params[:timecard_id]}")
            timecard.timeentries.find_by(entry_id: "#{params[:entry_id]}").update!({
                                                      time: params[:time],
                                                      timecard_id: params[:timecard_id]
                                                    }) if timecard
          end

          desc 'Delete a Time Entry.'
          params do
            requires :entry_id, type: Integer, desc: 'Time Entry ID.'
          end
          delete ':entry_id' do
            timecard_id = Timeentry.getTimeCardId(params[:entry_id])
            timecard = Timecard.find_by(card_id: timecard_id) if timecard_id
            timecard.timeentries.find_by(entry_id: "#{params[:entry_id]}").destroy if timecard
          end

        end
      #end

    end
  end
end
