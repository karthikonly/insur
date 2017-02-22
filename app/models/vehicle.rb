class Vehicle
  include Mongoid::Document
  include Mongoid::Timestamps

  field :year, type: Integer
  field :make, type: String
  field :model, type: String
  field :country, type: String, default: Province::COUNTRY_USA

  validates_presence_of   :year, :make, :model, :country
end
