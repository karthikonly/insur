class Drag
  include Mongoid::Document
  include Mongoid::Timestamps

  DATATYPE_OPTIONS = [["Integer", "integer"], ["String", "string"], ["Date", "date"], ["Boolean", "boolean"]].freeze
  CONTROL_OPTIONS = [["Number Field", "number_field"], ["Text Field", "text_field"], ["Date Selector", "date_selector"], 
    ["Checkbox", "checkbox"], ["Select", "select"]].freeze
     
  field :saved, type: Mongoid::Boolean, default: false
  field :content, type: Hash
end
