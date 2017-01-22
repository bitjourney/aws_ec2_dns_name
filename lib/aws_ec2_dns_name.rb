# frozen_string_literal: true
require "aws-sdk"

class AwsEc2DnsName
  attr_accessor :client

  # @param [String] region
  # @param [String] access_key_id
  # @param [String] secret_access_key
  def initialize(region: nil, access_key_id: nil, secret_access_key: nil)
    self.client = Aws::EC2::Client.new(region: region,
                                       access_key_id: access_key_id,
                                       secret_access_key: secret_access_key)
  end

  # @return [Array<Struct::Instance>]
  def instances
    instance_struct = Struct.new("Instance", :name_tag, :dns_name)

    client.describe_instances.first.reservations.map do |reservation|
      instance = reservation.instances.first
      name_tag = instance.tags.find { |tag| tag.key == "Name" }.value
      dns_name = dns_name(instance)
      next if dns_name.nil?
      instance_struct.new(name_tag, dns_name)
    end.sort_by { |i| i[:name_tag] }
  end
  alias_method :list, :instances

  private

  # @param [Aws::EC2::Types::Instance] instance
  # @return [String, NilClass]
  def dns_name(instance)
    public_dns_name = instance.public_dns_name
    private_dns_name = instance.private_dns_name

    if public_dns_name.empty?
      private_dns_name
    else
      public_dns_name
    end
  end
end
