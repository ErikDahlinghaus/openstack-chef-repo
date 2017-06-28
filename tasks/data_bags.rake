## TODO: Finish or disband this

# Common rake stuff
require_relative 'common'
include CoristaOpenStack::RakeCommon

require 'json'

# verbose output
verbose = true

# load data bag configuration
require_relative '../conf/data_bags'

def password_json(service)
  hash = { id: service }
  hash[service] = generate_password
  hash.to_json
end

# generate knife_cmd
def knife_cmd(sub_cmd)
  ['knife', sub_cmd, '-z', CONFIG_OPT].join(' ')
end

# execute knife in our context with sub_cmd
def knife(sub_cmd)
  chef_exec(knife_cmd(sub_cmd))
end

# execute command and get output
def execute(cmd)
  puts "TRACE: executing '#{cmd}'" if verbose
  require 'open3'
  out_err, st = Open3.capture2e(*cmd.split(' '))
  if st.exitstatus != 0
    puts "ERROR: #{cmd} exited with #{st.exitstatus}\n\n#{out_err}"
    exit st.exitstatus
  end
  out_err
end

# execute knife and get output as array
def knife_output_as_array(sub_cmd)
  execute(knife_cmd(sub_cmd)).split(/\n/).reject(&:empty?)
end

# ingore these lines from knife when processing output
unless defined? KNIFE_JSON_OUTPUT_IGNORE
  KNIFE_JSON_OUTPUT_IGNORE = [
    'Encrypted data bag detected, decrypting with provided secret.'
  ].freeze
end

# execute knife and get output as hash (from json)
def knife_output_as_hash(sub_cmd)
  sub_cmd = [sub_cmd, '-F json'].join(' ')
  output_lines = execute(knife_cmd(sub_cmd)).split(/\n/)
  output_lines = output_lines.reject { |line| KNIFE_JSON_OUTPUT_IGNORE.include? line }
  json = JSON.parse output_lines.join(' ')
rescue StandardError => e
  puts "ERROR: #{e}"
  exit 1
end

# list data bags
def list_data_bags
  @data_bags = @data_bags || knife_output_as_array('data bag list')
end

# create data bag
def create_data_bag(bag)
  knife("data bag create #{bag}")
end

# ensure all data bags exist
def create_all_data_bags
  DATA_BAGS_CONF.keys.each do |bag|
    next if list_data_bags.include? bag
    puts "TRACE: creating missing data bag #{bag}" if verbose
    create_data_bag(bag)
  end
end

# list data bag items
def list_data_bag_items(data_bag_name)
  @items = {} if @items.nil?
  @items[data_bag_name] = @items[data_bag_name] || knife_output_as_array("data bag show #{data_bag_name}")
end

# check for data bag item existence
def data_bag_item_exist?(bag, item)
  list_data_bag_items(bag).include?(item)
end

# show data bag item
def show_data_bag_item(bag, item)
  knife_output_as_hash("data bag show #{bag} #{item}")
end

# create data bag item
def create_data_bag_item(bag, item, value)
  unless data_bag_item_exist?(bag, item)
    require 'json'
    json = { 'id' => item, item => value }.to_json
    puts "TRACE: creating missing data bag item #{bag}/#{item} -- #{json}" if verbose
    puts "TODO: " + knife_cmd("data bag create #{bag} #{item}")
  end
end

# generate passwords for all data bag items
def generate_all_data_bag_items
  DATA_BAGS_CONF.each_pair do |data_bag_name, config|
    config.each_pair do |item, value|
      next unless value
      create_data_bag_item(data_bag_name, item, value)
    end
  end
end

# do all the databag stuff
namespace :data_bags do
  desc 'runs a knife command in the data bag context'
  task :knife, [:command] do |t, args|
    knife(args[:command])
  end

  desc 'list data bags'
  task :list do
    puts list_data_bags.inspect
  end

  desc 'creates all data bags'
  task :create_all do
    create_all_data_bags
  end

  desc 'generates all data bag items'
  task :generate_all do
    generate_all_data_bag_items
  end
end
