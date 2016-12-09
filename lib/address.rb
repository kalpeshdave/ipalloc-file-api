require 'yaml'
require 'resolv'

class Address
  include ActiveModel::Model

  attr_accessor :ip_address, :device
  validates :ip_address, :device, presence: true
  validates :ip_address, format: {  :with => Regexp.union(Resolv::IPv4::Regex, Resolv::IPv6::Regex) }

  define_model_callbacks :create

  def create
    _run_create_callbacks do
      File.open("#{Rails.root}/db/addresses/#{next_id}.yml", "w") do |file|
        file.puts serialize
      end
    end
    YAML.load serialize
  end

  def find(id)
    raise DocumentNotFound, "Arquivo db/addresses/#{id}", caller unless File.exists?("#{Rails.root}/db/magazines/#{id}.yml")
    YAML.load File.open("#{Rails.root}/db/addresses/#{id}.yml", "r")
  end

  def self.find_by_ip_address(ip_address)
    load_all.select do |object|
      should_select? object, "ip_address", ip_address
    end
  end

  private

  def self.should_select?(object, field, argument)
    if argument.kind_of? Regexp
      object.send(field) =~ argument
    else
      object.send(field) == argument
    end
  end

  def self.load_all
    Dir.glob('db/addresses/*.yml').map do |file|
      deserialize file
    end
  end

  def next_id
    Dir.glob("#{Rails.root}/db/addresses/*.yml").size.to_i + 1
  end

  def serialize
    YAML.dump self
  end

  def self.deserialize(file)
    YAML.load File.open(file, "r")
  end

end