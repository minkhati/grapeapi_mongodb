# app/api/v1/timeentries.rb
#require 'pry'

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
            requires :time, type: Time
          end
          post do
            timecard = Timecard.find_by(card_id: "#{params[:timecard_id]}")
            if timecard
              timeentries = Timeentry.getAllTimeEntries(timecard.card_id)
              #binding.pry
              if timeentries.count < 2
                timecard.timeentries.create!({
                                          time: params[:time],
                                          timecard_id: params[:timecard_id]
                                       })
              else
                timecard.timeentries.last.update!({
                                                      time: params[:time],
                                                      timecard_id: params[:timecard_id]
                                                  })
              end

              # Update the Timecard total_hours
              Timecard.updateTotalHours(timecard, 'update')
            end

          end

          desc 'Update a Time Entry.'
          params do
            requires :entry_id, type: Integer
            requires :time, type: Time

          end
          put ':entry_id' do
            timecard = Timecard.find_by(card_id: "#{params[:timecard_id]}")
            if timecard
              timecard.timeentries.find_by(entry_id: "#{params[:entry_id]}").update!({
                                                      time: params[:time],
                                                      timecard_id: params[:timecard_id]
                                                    })

              # Update the Timecard total_hours
              Timecard.updateTotalHours(timecard, 'update')
            end
          end

          desc 'Delete a Time Entry.'
          params do
            requires :entry_id, type: Integer, desc: 'Time Entry ID.'
          end
          delete ':entry_id' do
            timecard_id = Timeentry.getTimeCardId(params[:entry_id])
            if timecard_id
              timecard = Timecard.find_by(card_id: timecard_id)
              timecard.timeentries.find_by(entry_id: "#{params[:entry_id]}").destroy if timecard

              # Update the Timecard total_hours after deletion
              Timecard.updateTotalHours(timecard, 'delete')
            end
          end

        end
      #end

    end
  end
end
