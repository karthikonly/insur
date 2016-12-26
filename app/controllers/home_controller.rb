class HomeController < ApplicationController
  def index
    all_file_infos = FileInfo.includes(:component).all
    @result_hash = { '/' => { files: [], folders: {} } }
    all_file_infos.each do |fi|
      add_path_to_hash(@result_hash['/'], fi)
    end
  end

  private
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
