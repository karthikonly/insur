class Quote
  include Mongoid::Document
  include Mongoid::Timestamps

  PERSONAL_AUTO = "Personal Auto"

  belongs_to  :user
  embeds_one  :applicant
  embeds_one  :driver
  embeds_one  :insur_vehicle

  field :effective_date, type: Date
  field :line, type: String, default: PERSONAL_AUTO
  field :state, type: String
  field :agent_code, type: String

  validates_presence_of :line, :state #:effective_date
end
