# frozen_string_literal: true
require "aws-sdk"

require "aws_ec2_dns_name/instance"

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

  # @return [Array<AwsEc2DnsName:Instance>]
  def instances
    client.describe_instances.first.reservations.map do |reservation|
      ec2_instance = reservation.instances.first
      name_tag = ec2_instance.tags.find { |tag| tag.key == "Name" }.value
      dns_name = dns_name(ec2_instance)
      next if dns_name.nil?
      AwsEc2DnsName::Instance.new(name_tag, dns_name)
    end.sort_by { |i| i[:name_tag] }
  end
  alias list instances

  private

  # @param [Aws::EC2::Types::Instance] ec2_instance
  # @return [String, NilClass]
  def dns_name(ec2_instance)
    public_dns_name = ec2_instance.public_dns_name
    private_dns_name = ec2_instance.private_dns_name

    if public_dns_name.empty?
      private_dns_name
    else
      public_dns_name
    end
  end
end
