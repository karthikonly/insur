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
    folder_aggregate(@result_hash['/'])
  end

  def test_bootstrap
  end

  def data_bootstrap
    @json_data = [
      {
        text: 'Parent 1',
        href: '#parent1',
        tags: ['4'],
        nodes: [
          {
            text: 'Child 1',
            href: '#child1',
            tags: ['2'],
            nodes: [
              {
                text: 'Grandchild 1',
                href: '#grandchild1',
                tags: ['0']
              },
              {
                text: 'Grandchild 2',
                href: '#grandchild2',
                tags: ['0']
              }
            ]
          },
          {
            text: 'Child 2',
            href: '#child2',
            tags: ['0']
          }
        ]
      },
      {
        text: 'Parent 2',
        href: '#parent2',
        tags: ['0']
      },
      {
        text: 'Parent 3',
        href: '#parent3',
         tags: ['0']
      },
      {
        text: 'Parent 4',
        href: '#parent4',
        tags: ['0']
      },
      {
        text: 'Parent 5',
        href: '#parent5',
        tags: ['0']
      }
    ]
    render json: @json_data
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
