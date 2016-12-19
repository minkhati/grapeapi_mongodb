# app/models/timecard.rb
class Timecard
  # We define this class as a Mongoid Document
  include Mongoid::Document

  # Generates created_at and updated_at
  include Mongoid::Timestamps

  # For auto increment field in the collection
  include Mongoid::Autoinc



  # Defining our fields with their types
  #field :timecard_id, type: Integer
  field :username, type: String
  field :occurrence, type: Date
  field :total_hours, type: Float
  field :card_id, type: Integer

  #increments :timecard_id
  increments :card_id

  # Time Entries will be stored inside the
  # Timecard document
  embeds_many :timeentries

  # Sort the time_cards
  scope :ordered, -> { order('created_at DESC') }

  # Validates that the timecard_id is present and unique
  #validates :timecard_id, presence: true, uniqueness: true
  validates :username, presence: true
  validates :occurrence, presence: true

  # The timecard_id has to be unique since it can be used to query post.
  # Also defining an index will make the query more efficient
  #index({ username: 1 }, { unique: true, name: "username_index" })
end