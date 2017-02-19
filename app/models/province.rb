class Province
  include Mongoid::Document
  Mongoid::Timestamps

  field :name, type: String
  field :symbol, type: String
  field :country, type: String

  validates_presence_of :name, :symbol, :country
end
