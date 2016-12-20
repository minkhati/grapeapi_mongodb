# app/models/timeentry.rb
require 'pry'
class Timeentry
  include Mongoid::Document
  include Mongoid::Timestamps

  # For auto increment field in the collection
  include Mongoid::Autoinc

  field :entry_id, type: Integer
  field :time, type: Time
  field :timecard_id, type: Integer

  increments :entry_id

  # This model should be saved in the Timecard document
  embedded_in :timecard

  # Sort the time_entries
  scope :ordered, -> { order('created_at DESC') }

  #validates :entry_id, presence: true, uniqueness: true
  validates :time, presence: true
  validates :timecard_id, presence: true

  # For getting all Timeentries
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

  # For getting Timeentries for a given timecard_id
  def self.getAllTimeEntries(timecard_id)

    allTimeEntries = Array.new
    @card = Timecard.find_by(card_id: timecard_id)

    @card.timeentries.each do |entry|
      allTimeEntries.push(entry)
    end

    allTimeEntries

  end

  # for getting Timecard related to Timeentry Id
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