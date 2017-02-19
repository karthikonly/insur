class Province
  include Mongoid::Document
  include Mongoid::Timestamps

  COUNTRY_USA = "USA"

  field :name, type: String
  field :symbol, type: String
  field :country, type: String, default: COUNTRY_USA

  validates_presence_of :name, :symbol, :country
end
