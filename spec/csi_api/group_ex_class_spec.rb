require 'spec_helper'
require 'savon/mock/spec_helper'

describe CsiApi::GroupExClass do
  include CsiApiMocks
  include Savon::SpecHelper
  
  before(:all) { savon.mock! }
  after(:all) { savon.unmock! }
  
  let(:class_list) { mock_savon_response File.read("spec/fixtures/get_class_schedules_response.xml") }
  let(:class_info) { class_list.body[:get_class_schedules_response][:get_class_schedules_result][:value][:class_schedules_info][0] }
  let(:single_class_info) { File.read("spec/fixtures/get_schedule_by_mem_id_response.xml") }
  let(:base_client) { Savon.client(wsdl: "spec/fixtures/ApiService45.wsdl") } 
  let(:test_date_time) { DateTime.new(2013, 04, 15, 9, 00) }
  let(:group_ex_class) { CsiApi::GroupExClass.new class_info, test_date_time }
  let(:member) do
    consumer_response = File.read("spec/fixtures/factory/authenticate_consumer_response.xml")
    savon.expects(:authenticate_consumer).with(message: anything()).returns(consumer_response)
    member_info = mock_savon_response File.read("spec/fixtures/authenticate_member_response.xml")
    CsiApi::Member.new member_info
  end
  let(:class_with_fees) do
    class_info[:fees] = "Member Fee: $501.00 Non-Member Fee: $551.00"
    CsiApi::GroupExClass.new(class_info, test_date_time)
  end
  
  it "should initialize" do
    group_ex_class.should be_an_instance_of CsiApi::GroupExClass
    group_ex_class.class_name.should == "REV"
  end
  
  it "should make soap call for class details on initialize" do
    group_ex_class
  end
  
  it "should have a DateTime object for :start_date_time and :end_date_time" do
    group_ex_class.start_date_time.should be_an_instance_of(DateTime)
    group_ex_class.end_date_time.should be_an_instance_of(DateTime)
  end
  
  it "should set the DateTime object as a combination of start time for the class and the date passed to ::new" do
    # The Date portion comes from test_date passed into the GroupExClass; 
    # the time portion comes from the class_info[:start_time] and class_info[:end_time]
    group_ex_class.start_date_time.should == DateTime.new(2013, 04, 15, 6, 00)
    group_ex_class.end_date_time.should == DateTime.new(2013, 04, 15, 6, 45)
  end
  
  # Dates and times below based on class_info and test_date: 2013-04-15T06:00:00 and 2013-04-15T06:45:00
  it "should return the class date as a string" do
    group_ex_class.long_date.should == "Monday, Apr 15, 2013"
    group_ex_class.short_date.should == "4/15/2013"
  end
  
  it "should return the class start time as a string" do
    group_ex_class.start_time.should == "6:00 AM"
  end
  
  it "should return the class end time as a string" do 
    group_ex_class.end_time.should == "6:45 AM"
  end
  
  it "should return the date of the class as a date object for sorting" do
    group_ex_class.date.should == Date.parse("2013-04-15")
  end
  
  it "should parse the fees for members" do
    class_with_fees.member_fee.should == "$501.00"
  end
  
  it "should parse the fees for guests" do
    class_with_fees.guest_fee.should == "$551.00"
  end
  
  it "should reserve the class for a member" do
    message = { mem_id: member.member_id, schedule_id: group_ex_class.schedule_id }
    savon.expects(:add_ol_s_cart_entry_for_group_x).with(message: message).returns(File.read("spec/fixtures/add_ol_s_cart_entry_for_group_x_response.xml"))
    group_ex_class.reserve_class(member).should be_true
  end
  
  it "should return a list of equipment associated with a class" do
    savon.expects(:get_equipment_list).with(message: { schedule_id: group_ex_class.schedule_id }).returns(File.read("spec/fixtures/get_equipment_list_response.xml"))
    SoapContainer = Struct.new(:soap_client)
    soap_container = SoapContainer.new(base_client)
    equipment_list = group_ex_class.get_equipment_list(soap_container)
    equipment_list.should be_an_instance_of Array
    equipment_list[0].should be_an_instance_of CsiApi::Equipment
  end
  
  it "should reserve the class with a specific piece of equipment for the member" do
    Equipment = Struct.new(:equipment_id)
    equipment = Equipment.new(5)
    message = { mem_id: member.member_id, schedule_id: group_ex_class.schedule_id, equipment_id: equipment.equipment_id }
    savon.expects(:add_ol_s_cart_entry_for_group_x).with(message: message).returns(File.read("spec/fixtures/add_ol_s_cart_entry_for_group_x_response.xml"))
    group_ex_class.reserve_class(member, equipment).should be_true
  end
  
  it "should return an error string when reservation fails" do
    message = { mem_id: member.member_id, schedule_id: group_ex_class.schedule_id }
    savon.expects(:add_ol_s_cart_entry_for_group_x).with(message: message).returns(File.read("spec/fixtures/add_ol_s_cart_entry_for_group_x_fail_response.xml"))
    group_ex_class.reserve_class(member).should == "Member cannot be enrolled in a past schedule.^^ApplicationModal"
  end
  
  describe "waivers" do
   
    before(:each) do
      CsiApi::ClientFactory.should_receive(:generate_soap_client).once { base_client }
    end
    
    it "should get a soap client" do
      group_ex_class.soap_client.should be_an_instance_of Savon::Client
    end
  
    it "should store the client and not call CsiApi::ClientFactory again" do
      group_ex_class.soap_client
      group_ex_class.soap_client
    end
  
    it "should return the long waiver" do
      savon.expects(:get_waiver_by_schedule_id).with(message: { schedule_id: group_ex_class.schedule_id }).returns(File.read("spec/fixtures/get_waiver_by_schedule_id_response.xml"))
      waiver = group_ex_class.long_waiver
      waiver.should be_an_instance_of String
    end
  
    it "should return the long waiver" do
      savon.expects(:get_waiver_by_schedule_id).with(message: { schedule_id: group_ex_class.schedule_id }).returns(File.read("spec/fixtures/get_waiver_by_schedule_id_response.xml"))
      group_ex_class.short_waiver.should be_an_instance_of String
    end
  
    it "should store both waivers on the first call and not call soap_client a second time" do
      savon.expects(:get_waiver_by_schedule_id).with(message: { schedule_id: group_ex_class.schedule_id }).returns(File.read("spec/fixtures/get_waiver_by_schedule_id_response.xml"))
      group_ex_class.long_waiver
      group_ex_class.short_waiver
     end
   
   end
   
end