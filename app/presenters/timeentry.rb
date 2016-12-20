# app/presenters/timeentry.rb
module Presenters
  class Timeentry < ::Yumi::Base

    meta META_DATA
    attributes :time, :timecard_id, :entry_id
    links :self

  end

end