require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: convert_triggers.rb [options]'

  opts.on('-f', '--file FILE', 'file') do |file|
    options[:file] = file
  end
end.parse!

mapper = {
  '111' => {
    index: 1000,
    count: 0
  },
  '112' => {
    index: 2000,
    count: 0
  },
  '122' => {
    index: 3000,
    count: 0
  },
  '123' => {
    index: 4000,
    count: 0
  },
  '133' => {
    index: 5000,
    count: 0
  },
  '144' => {
    index: 6000,
    count: 0
  },
  '145' => {
    index: 7000,
    count: 0
  }
}

lines = File.readlines(options[:file])
output = File.open("parsed-#{options[:file]}", 'w')

lines.each do |line|
  unless line =~ /^Mk\d+\=S/i
    output << line
    next
  end

  stimulus_code = line.match(/S\s*\K(\d+)/)[0]

  if mapper.key?(stimulus_code)
    new_code = mapper[stimulus_code][:index] + mapper[stimulus_code][:count]
    mapper[stimulus_code][:count] += 1

    new_line = line.gsub(/S\s*\K(\d+)/, new_code.to_s)
    output << new_line
  else
    output << line
  end
end

output.close
