class Component
  include Mongoid::Document

  field :name, type: String

  has_many  :file_infos

  validates_presence_of   :name
end
