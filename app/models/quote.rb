class Quote
  include Mongoid::Document
  include Mongoid::Timestamps

  PERSONAL_AUTO = "Personal Auto"

  belongs_to  :user
  embeds_one  :applicant
  embeds_one  :driver
  embeds_one  :insur_vehicle

  NON_VIOLENCE_DURATION_OPTIONS = [["Less than 1 year", "<1yr"], ["1 to 3 years", "1-3yrs"], ["Greater than 3 years", ">3yrs"]].freeze

  field :effective_date, type: Date
  field :line, type: String, default: PERSONAL_AUTO
  field :state, type: String
  field :agent_code, type: String

  field :non_violence_duration, type: String
  field :prior_incident_forgiveness, type: Boolean

  validates_presence_of :line, :state, :effective_date
end
