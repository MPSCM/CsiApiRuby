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
    soap_client = double("Savon::Client")
    CsiApi::ClientFactory.should_receive(:generate_member_client).with(member_auth_token).at_least(:once)  { soap_client }
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
    message = { message: { mem_num: member.member_number } }
    member.soap_client.should_receive(:call).with(:get_group_ex_schedules, message) { mock_savon_response File.read("spec/fixtures/get_group_ex_schedules_response.xml") }
    reservation_list = member.get_gx_reservations
    reservation_list.should be_an_instance_of CsiApi::ReservationList
    reservation_list.class_list.length.should == 4
    reservation_list.class_list.first.should be_an_instance_of CsiApi::Reservation
  end
  
  it "should remove an item from the member's cart" do
    message = { mem_num: member.member_number, reservation_id: "831" }
    member.soap_client.should_receive(:call).with(:remove_cart_item_by_mem_num, message: message) { mock_savon_response File.read("spec/fixtures/remove_cart_item_by_mem_num_response.xml") }
    Item = Struct.new(:reservation_id)
    item = Item.new("831")
    member.remove_item_from_cart(item).should be_true
  end
  
  it "should clear the member's cart" do
    member.soap_client.should_receive(:call).with(:member_clear_cart) { mock_savon_response File.read("spec/fixtures/member_clear_cart_response.xml") }
    member.clear_cart.should be_true
  end
  
  it "should return a list of cart items" do
    member.soap_client.should_receive(:call).with(:get_cart_by_mem_num, message: { mem_num: member.member_number }) { mock_savon_response File.read("spec/fixtures/get_cart_by_mem_num_response.xml") }
    cart = member.get_cart
    cart.should be_an_instance_of Array
    cart[0].should be_an_instance_of CsiApi::CartItem
  end
  
end