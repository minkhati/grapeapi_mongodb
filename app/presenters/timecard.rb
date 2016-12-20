# app/presenters/timecard.rb
module Presenters
  class Timecard < ::Yumi::Base

    meta META_DATA
    attributes :username, :occurrence, :card_id
    has_many :timeentries
    links :self

  end

end