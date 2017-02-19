class Quote
  include Mongoid::Document
  Mongoid::Timestamps

  field :agent_code, type: String
  field :effective_date, type: Date
  field :line, type: String, default: "Personal Auto"
  field :state, type: String

  validates_presence_of :line, :state #:effective_date
end
