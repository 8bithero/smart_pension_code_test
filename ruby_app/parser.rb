require_relative 'lib/logfile_parser'

parser = LogfileParser.new(ARGV[0])
parser.parse

puts "\r"
puts "MOST VIEWS"
parser.most_views

puts "\r"
puts "UNIQUE VIEWS"
parser.unique_views
