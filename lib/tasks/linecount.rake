namespace :linecount do

  desc "Task to perform linecount on all files"
  task run: :environment do
    root = "/Users/karthik/mdms/monaco"
    empty_fis = FileInfo.where(loc: nil)
    empty_fis.each do |fi|
      path = "#{root}#{fi.folder}/#{fi.name}"
      puts "running: #{path}"
      line_count = `wc -l "#{path}"`.strip.split(' ')[0].to_i
      puts "updating linecount: #{line_count}"
      fi.update(loc: line_count)
    end
    puts "Updated: #{empty_fis.size} records. Remaining: #{FileInfo.where(loc: nil).count} records."
  end

end
