class LogfileParser
  attr_reader :entries

  def initialize(logfile_path)
    file_exists?(logfile_path)

    @logfile_path = logfile_path
    @entries = Hash.new { |h, k| h[k] = [] }
  end

  def parse
    return @entries if @entries.any?

    File.open(@logfile_path).each do |line|
      page, ip = *line.split(/\s+/)
      @entries[page] << ip
    end

    @entries
  end

  def most_views
    @most_views ||=
      generate_view_count(unique: false).sort_by{ |_k, v| v.size }.to_h

    pretty_print(@most_views, 'visits')
    @most_views
  end

  def unique_views
    @unique_views ||=
      generate_view_count(unique: true).sort_by{ |_k, v| v.size }.to_h

    pretty_print(@unique_views, 'unique views')
    @unique_views
  end

  private

  def file_exists?(path)
    raise "No such file or directory @ #{path}" unless File.exists? path
  end

  def generate_view_count(unique:)
    @entries.each_with_object({}) do |(key, value), list|
      list[key] = unique ? value.uniq.size : value.size
    end
  end

  def pretty_print(list, string)
    puts '----------------------------------------------'
    puts '| # | ' + 'PAGE'&.ljust(19) + '| COUNT'
    puts '----------------------------------------------'
    list.each_with_index do |(page, count), index|
      puts "| #{index} | #{page&.ljust(18)} | #{count} #{string}"
    end
    puts '----------------------------------------------'
  end
end
