class Applicant
  include Mongoid::Document
  include Mongoid::Timestamps

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
  field :risk, type: State
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

  validates_presence_of :appl_last, :appl_first, :coappl_last, :coappl_first
end
