class FileInfo
  include Mongoid::Document
  field :folder, type: String
  field :loc, type: Integer
  field :name, type: String
end
