class HomeController < ApplicationController
  def index
    # build aggregation based on filetype
    @type_group_hash = build_aggregation(:type)

    # build aggregation based on reviewed
    @review_done_group_hash = build_aggregation(:review_done)

    # build aggregation based on component
    @component_group_hash = build_aggregation(:component_id)

    # build detailed result hash for main view construction
    all_file_infos = FileInfo.includes(:component).all
    @result_hash = { '/' => { files: [], folders: {} } }
    build_file_info_hash(all_file_infos, @result_hash)
  end

  private
    def build_aggregation(property)
      property = property.to_s
      return_hash = {}
      aggregation_object = FileInfo.collection.aggregate([{ "$group": { 
        "_id": { property => '$'+property }, 
        "count": { "$sum": 1 }, 
        "lines": { "$sum": "$loc"}
        } }])
      aggregation_object.each do |result|
        return_hash[result["_id"][property]] = {count: result["count"], lines: result["lines"]} 
      end
      return_hash
    end


    def build_file_info_hash(all_file_infos, hash)
      all_file_infos.each do |fi|
        add_path_to_hash(hash['/'], fi)
      end
    end

    def add_path_to_hash(ptr, fi)
      path_elements = fi.folder.split('/').reject(&:blank?)
      path_elements.each do |element|
        ptr = ptr[:folders]
        ptr[element] ||= { files: [], folders: {}}
        ptr = ptr[element]
      end
      ptr[:files] << fi
    end
end
