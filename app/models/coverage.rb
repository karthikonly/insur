class Coverage
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in   :quote, inverse_of: :coverage

  COVERAGE_TYPE_OPTIONS = ["Full Coverage", "Partial Coverage"].freeze
  BODILY_INJURY_OPTIONS = ["100,000/300,000", "50,000/100,000", "10,000/25,000"].freeze
  PROPERTY_DAMAGE_OPTIONS = ["25,000","50,000","100,000","200,000"].freeze
  MEDICAL_PAYMENTS = ["1000", "500", "250", "2000"].freeze
  UNINSURED_BODILY_INJURY_OPTIONS = ["100,000/300,000", "50,000/100,000", "10,000/25,000"].freeze
  PHYSICAL_COMPREHENSIVE_OPTIONS = ["100","250","500","1000"].freeze
  PHYSICAL_COLLISION_OPTIONS = ["100","250","500","1000"].freeze
  UNINSURED_PROPERTY_DAMAGE_OPTIONS = ["100,000/300,000", "50,000/100,000", "10,000/25,000"].freeze
  TOWING_LABOR_OPTIONS = ["25","50","75","100"].freeze
  TRANSPORTATION_OPTIONS = ["20/600", "75/750", "100/1000"].freeze

  field :coverage_type, type: String
  field :bodily_injury, type: String
  field :property_damage, type: String
  field :medical_payments, type: String
  field :uninsured_bodily_injury, type: String
  field :physical_comprehensive, type: String
  field :physical_collision, type: String
  field :uninsured_property_damage, type: String
  field :towing_labor, type: String
  field :transportation, type: String

  validates_presence_of   :coverage_type, :bodily_injury, :property_damage, :medical_payments, :uninsured_bodily_injury,
      :physical_comprehensive, :physical_collision, :uninsured_property_damage, :towing_labor, :transportation

end
