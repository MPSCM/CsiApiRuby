require 'spec_helper'
require 'savon/mock/spec_helper'

describe CsiApi::Member do
  include CsiApiMocks
  include Savon::SpecHelper
  
  let(:member_info) do
    xml_response = File.read("spec/fixtures/authenticate_member_response.xml")
    mock_savon_response xml_response
  end  
  
  let(:member_auth_token) do
    member_info.body[:authenticate_member_response][:authenticate_member_result][:value][:member_ticket]
  end
  
  let(:member) do
    CsiApi::ClientFactory.should_receive(:generate_member_client).with(member_auth_token).at_least(:once)  
    CsiApi::Member.new member_info
  end
  
  it "should initialize" do
    member.should be_an_instance_of CsiApi::Member    
  end
  
  it "should create attribute accessors from keys" do
    member.should respond_to :first_name
    member.should respond_to :last_name
  end
  
  it "should have array of attributes" do
    member.class.attr_list.should be_an_instance_of Array
    member.class.attr_list.should include(:first_name)
  end
  
  it "should properly populate attributes" do
    member.first_name.should == "KIM"
    member.last_name.should == "WOOD"
  end
  
  it "should not reset attributes when another instance is initialized" do
    member
    new_member = CsiApi::Member.new member_info
    member.first_name.should == "KIM"
    new_member.first_name.should == "KIM"
  end
  
  it "should not have multiple copies of attributes in attribute array after multiple initializations" do
    member
    new_member = CsiApi::Member.new member_info
    CsiApi::Member.attr_list.count(:first_name).should == 1
  end
  
  it "should list reservations for group ex classes" do
    message = { message: { mem_id: member.member_id } }
    member.soap_client.should_receive(:call).with(:get_group_ex_schedules, message) { mock_savon_response File.read("spec/fixtures/get_group_ex_schedules_response.xml") }
    reservation_list = member.get_gx_reservations
    reservation_list.should be_an_instance_of Array
    reservation_list.length.should == 4
  end
    
  
end