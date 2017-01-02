class HomeController < ApplicationController
  def index
    # build aggregation based on filetype and reviewed
    @type_compound_hash = build_nested_aggregation(:type, :review_done)

    # build aggregation based on reviewed
    name_map_hash = { false => 'Not Reviewed', true => 'Reviewed'}
    @review_done_group_hash = build_aggregation(:review_done, name_map_hash)

    # build aggregation based on component
    name_map_hash = { nil => 'Unassigned'}
    Component.all.each { |x| name_map_hash[x.id] = x.name }
    @component_group_hash = build_aggregation(:component_id, name_map_hash)

    # treeview construction data
    @treeview_data = treeview_data
    @component_list = Component.all.collect{|x| [x.name, x.id.to_s]}.unshift(["", nil])
  end

  def pretty_view
    @treeview_data = treeview_data
    @component_list = Component.all.collect{|x| [x.name, x.id.to_s]}.unshift(["", nil])
  end

  def form_view
    @result_hash = generate_consolidated_data
    @components = Component.all
    @file_count = 0
  end

  def treeview_data_json
    render json: treeview_data
  end

  private
    def treeview_data
      folder_data = add_folder_to_treeview([], '/', generate_consolidated_data['/'])
      { onhoverColor: '#A0A0A0', showTags: true, data: folder_data }
    end

    def build_nested_aggregation(property1, property2)
      prop1 = property1.to_s
      prop2 = property2.to_s
      aggregation_object = FileInfo.collection.aggregate([{ "$group": {
        "_id": { prop1 => '$'+prop1, prop2 => '$'+prop2 },
        "count": { "$sum": 1 },
        "lines": { "$sum": "$loc"}
        } }])
      return_hash = {}
      aggregation_object.each do |result|
        return_hash[result['_id'][prop1]] ||= {}
        return_hash[result['_id'][prop1]][result['_id'][prop2]] = {count: result["count"], lines: result["lines"]}
      end
      return_hash
    end

    def build_aggregation(property, name_map_hash = nil)
      property = property.to_s
      return_hash = {}
      aggregation_object = FileInfo.collection.aggregate([{ "$group": { 
        "_id": { property => '$'+property }, 
        "count": { "$sum": 1 }, 
        "lines": { "$sum": "$loc"}
        } }])
      aggregation_object.each do |result|
        key = name_map_hash ? name_map_hash[result["_id"][property]] : result["_id"][property]
        return_hash[key] = {count: result["count"], lines: result["lines"]}
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
        entry[:is_folder] = true
        entry[:loc] = data_source[:total_lines]
        entry[:files] = data_source[:total_files]
        entry[:reviewed] = false
        entry[:component_id] = nil
      else
        entry[:href] = data_source.id.to_s
        entry[:icon] = "glyphicon glyphicon-file"
        entry[:color] = "Green"
        if data_source.component
          entry[:tags] << "#{data_source.component.try(:name)}"
        else
          entry[:tags] << "Unassigned"
        end
        entry[:tags] << (data_source.review_done ? "Reviewed" : "Not Reviewed")
        entry[:tags] << "#{data_source.type}"
        entry[:tags] << "#{data_source.loc} lines"
        entry[:is_folder] = false
        entry[:loc] = data_source.loc
        entry[:files] = 1
        entry[:reviewed] = data_source.review_done
        entry[:component_id] = data_source.component_id.to_s
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
