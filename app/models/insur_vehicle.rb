class InsurVehicle
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to    :vehicle
  embedded_in   :quote, inverse_of: :insur_vehicle

  USAGE_OPTIONS = [["Pleasure Usage", "Pleasure"], ["Office Commute", "Office"], ["Business Commute", "Business"],
      ["All or Most of above", "All"]].freeze
  TYPE_OPTIONS = [["Standard Passenger Car", "Standard"], ["Family Car", "Family"], ["Business Purpose", "Business"]].freeze
  ANTI_THEFT_OPTIONS = ["None", "Category1", "Category2"].freeze

  field :vin, type: String
  field :type, type: String
  field :usage, type: String
  field :annual_mileage, type: Integer
  field :anti_theft, type: String

  validates_presence_of   :vin, :type, :usage, :anti_theft
end
