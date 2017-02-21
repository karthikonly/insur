class Driver
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in   :quote, inverse_of: :driver

  GENDERS = [["Male", "M"], ["Female", "F"], ["Other", "O"]].freeze
  MARITAL_STATUSES = ["Single", "Married", "Divorced", "Widow(er)", "Other"].freeze
  APPLICANT_RELATION = ["Self", "Spouse", "Dependant"].freeze

  field :prefix, type: String
  field :first, type: String
  field :middle, type: String
  field :last, type: String
  field :suffix, type: String
  field :applicant_relation, type: String
  field :dob, type: Date
  field :gender, type: String
  field :marital_status, type: String
  field :license_state, type: String
  field :license_number, type: String
  field :license_date, type: Date
  field :license_valid_till, type: Date

  validates_presence_of   :first, :last, :license_state, :license_number, :applicant_relation, :gender # :license_date, :dob

  def full_name
    [self.prefix, self.first, self.middle, self.last, self.suffix].compact.join(' ')
  end
end
