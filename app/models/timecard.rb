# app/models/timecard.rb
class Timecard
  # Define this class as a Mongoid Document
  include Mongoid::Document

  # Generates created_at and updated_at
  include Mongoid::Timestamps

  # For auto increment field in the collection
  include Mongoid::Autoinc



  # Defining fields with their types

  field :username, type: String
  field :occurrence, type: Date
  field :total_hours, type: Float
  field :card_id, type: Integer

  increments :card_id

  # Time Entries will be stored inside the
  # Timecard document
  embeds_many :timeentries

  # Sort the time_cards
  scope :ordered, -> { order('created_at DESC') }

  # Validates that the fields
  #validates :card_id, presence: true, uniqueness: true
  validates :username, presence: true
  validates :occurrence, presence: true


  # The card_id has to be unique since it can be used to query timecard.
  # Also defining an index will make the query more efficient
  index({ card_id: 1 }, { unique: true, name: "card_id_index" })


  # For updating the Timecard total_hours field
  def self.updateTotalHours(timecard, operation)

    timeentries = Timeentry.getAllTimeEntries(timecard.card_id)

    if timeentries.count > 1 && operation == 'update'

      t1 = timeentries.first.time
      t2 = timeentries.last.time
      diff = t2.to_time - t1.to_time
      total_hours = diff / 60 / 60  # converts to hours from seconds
      timecard.update(total_hours: total_hours)

    elsif timeentries.count < 2 && operation == 'delete'

      timecard.update(total_hours: nil)

    end
  end

end