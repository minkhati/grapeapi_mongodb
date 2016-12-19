# app/models/timeentry.rb
require 'pry'
class Timeentry
  include Mongoid::Document
  include Mongoid::Timestamps

  # For auto increment field in the collection
  include Mongoid::Autoinc

  field :entry_id, type: Integer
  field :time, type: DateTime
  field :timecard_id, type: Integer

  increments :entry_id

  # This model should be saved in the Timecard document
  embedded_in :timecard

  # Sort the time_entries
  scope :ordered, -> { order('created_at DESC') }

  #validates :id, presence: true, uniqueness: true
  validates :time, presence: true
  validates :timecard_id, presence: true

  def self.getAllEntries
    allEntries = Array.new
    @cards = Timecard.all.ordered
    @cards.each do |card|
      card.timeentries.each do |entry|
        allEntries.push(entry)
      end
    end
    allEntries
  end

  def self.getTimeCardId(entry_id)
    timecardid = nil
    @cards = Timecard.all.ordered
    @cards.each do |card|
      card.timeentries.each do |timeentry|
        timecardid = card.card_id if timeentry.entry_id == entry_id
      end
    end
    timecardid
  end
end