json.extract! file_info, :id, :folder, :loc, :name, :created_at, :updated_at
json.url file_info_url(file_info, format: :json)