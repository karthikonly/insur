class Province
  include Mongoid::Document
  field :name, type: String
  field :symbol, type: String
  field :country, type: String
end
