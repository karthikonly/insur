class HomeController < ApplicationController
  def index
    # build aggregation based on filetype
    @type_group_hash = build_aggregation(:type)

    # build aggregation based on reviewed
    @review_done_group_hash = build_aggregation(:review_done)

    # build aggregation based on component
    @component_group_hash = build_aggregation(:component_id)

    # build detailed result hash for main view construction
    @result_hash = generate_consolidated_data
  end

  def pretty_view
    folder_data = add_folder_to_treeview([], '/', generate_consolidated_data['/'])
    @treeview_data = {data: folder_data, onhoverColor: '#A0A0A0', showTags: true}
  end

  def form_view
    @result_hash = generate_consolidated_data
  end

  def treeview_data_json
    folder_data = add_folder_to_treeview([], '/', generate_consolidated_data['/'])
    render json: {data: folder_data, onhoverColor: '#A0A0A0', showTags: true}
  end

  def test_bootstrap
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

    def generate_treeview_node(name, is_folder, data_source)
      @counter ||= 0
      @counter += 1
      entry = { text: name, tags: [] }
      if is_folder
        entry[:href] = '#folder'+@counter.to_s
        entry[:icon] = "glyphicon glyphicon-folder-close"
        entry[:color] = "Blue"
        entry[:nodes] = []
        entry[:tags] << "#{data_source[:total_files]} files"
        entry[:tags] << "#{data_source[:total_lines]} lines"
      else
        entry[:href] = data_source.id.to_s
        entry[:icon] = "glyphicon glyphicon-file"
        entry[:color] = "Green"
        if data_source.component
          entry[:tags] << "#{data_source.component.try(:name)}"
        else
          entry[:tags] << "Unassigned"
        end
        entry[:tags] << "#{data_source.type}"
        entry[:tags] << "#{data_source.loc} lines"
      end
      entry
    end

    def add_folder_to_treeview(treeview_data, folder_name, details_hash)
      treeview_entry = generate_treeview_node(folder_name, true, details_hash)
      details_hash[:folders].each do |key, value|
        add_folder_to_treeview(treeview_entry[:nodes], key, value)
      end
      details_hash[:files].each do |fi|
        treeview_entry[:nodes] << generate_treeview_node(fi.name, false, fi)
      end
      treeview_data << treeview_entry
    end

    def generate_consolidated_data
      all_file_infos = FileInfo.includes(:component).all
      result_hash = { '/' => { files: [], folders: {} } }
      build_file_info_hash(all_file_infos, result_hash)
      folder_aggregate(result_hash['/'])
      result_hash
    end

    def folder_aggregate(hash)
      total_lines = 0
      total_files = 0
      hash[:folders].each do |name, child_hash|
        folder_aggregate(child_hash)
        total_lines += child_hash[:total_lines]
        total_files += child_hash[:total_files]
      end
      hash[:files].each do |fi|
        total_lines += fi.loc
      end
      total_files += hash[:files].size
      hash[:total_lines] = total_lines
      hash[:total_files] = total_files
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
