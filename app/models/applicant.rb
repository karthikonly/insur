class Applicant
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in   :quote, inverse_of: :applicant

  NAME_PREFIXES = ["Mr.", "Mrs.", "Ms.", "Sir.", "Dr."].freeze
  RESIDENCE_TYPES = ["Own Home", "Rented-Family", "Rented-Shared", "None of the Above"].freeze
  YEARS_AT_RESIDENCE = ["0-2 Years", "2-4 Years", "4-10 Years", "10 Years+"].freeze
  BOOLEAN_SELECT_CHOICES = [[false, "No"],[true, "Yes"]].freeze
  GROUP_DISCOUNT_OPTIONS = ["None", "Corporate", "Bulk Discount > 15 Persons"].freeze

  field :appl_prefix, type: String
  field :appl_first, type: String
  field :appl_middle, type: String
  field :appl_last, type: String
  field :appl_suffix, type: String
  field :appl_ssn, type: String
  field :coappl_prefix, type: String
  field :coappl_first, type: String
  field :coappl_middle, type: String
  field :coappl_last, type: String
  field :coappl_suffix, type: String
  field :coappl_ssn, type: String
  field :agency_cust_id, type: String
  field :phone, type: String
  field :risk_addr_1, type: String
  field :risk_addr_2, type: String
  field :risk_city, type: String
  field :risk_state, type: String
  field :risk_zip, type: String
  field :risk_zip2, type: String
  field :residence_type, type: String
  field :years_at_residence, type: String
  field :companion_credit, type: Mongoid::Boolean
  field :companion_policy, type: String
  field :life_policy_credit, type: Mongoid::Boolean
  field :life_policy, type: String
  field :young_family_discount, type: Mongoid::Boolean
  field :group_discount_option, type: String
  field :personal_account_bill, type: Mongoid::Boolean
  field :star_pak, type: Mongoid::Boolean
  field :star_pak_account, type: String
  field :parent_policy_number1, type: String
  field :parent_policy_number2, type: String

  validates_presence_of :appl_last, :appl_first, :risk_zip

  def applicant_info
    "#{self.appl_prefix} #{self.appl_first} #{self.appl_middle} #{self.appl_last} #{self.appl_suffix}"
  end

  def coapplicant_info
    "#{self.coappl_prefix} #{self.coappl_first} #{self.coappl_middle} #{self.coappl_last} #{self.coappl_suffix}"
  end

  def risk_address_info
    address = self.risk_addr_1
    address += ", #{self.risk_addr_2}" if self.risk_addr_2
    address += ", #{self.risk_city}, #{self.risk_state}, #{self.risk_zip}"
    address += " - #{self.risk_zip2}" if self.risk_zip2
  end
end
