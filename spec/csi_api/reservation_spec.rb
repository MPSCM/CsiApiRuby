require 'spec_helper'
require 'savon/mock/spec_helper'

describe CsiApi::Reservation do
  include CsiApiMocks
  include Savon::SpecHelper
  
  before(:all) { savon.mock! }
  after(:all) { savon.unmock! }
  
  let(:get_group_ex_schedules_response) { mock_savon_response File.read("spec/fixtures/get_group_ex_schedules_response.xml") }
  
  let(:reservation) do
    reservation_hash = get_group_ex_schedules_response.body[:get_group_ex_schedules_response][:get_group_ex_schedules_result][:value][:member_schedule_info][0]
    reservation = CsiApi::Reservation.new(reservation_hash, "534763")
  end
  
  it "should initialize from the hash that contains a single schedule reservation" do
    reservation.should be_an_instance_of CsiApi::Reservation
  end
  
  it "should extract the correct attributes from the reservation" do
    reservation.member_id.should == "534763"
    reservation.schedule_id.should == "1286855"
    reservation.class_name.should == "Book Me"
    reservation.site_id.should == "142"
    reservation.equipment_name.should == nil
    reservation.start_date_time.should == DateTime.parse("2013-05-23T12:00:00")
    reservation.end_date_time.should == DateTime.parse("2013-05-23T13:00:00")
  end
  
  it "should include the GroupExClassSharedMethods" do
    # these methods are currently being tested in group_ex_class_spec.rb
    # at some point, they should be extracted out into independent tests
    # this is a sampling of them; they rely on start_date_time and end_date_time
    reservation.long_date.should == reservation.start_date_time.strftime('%A, %b %-d, %Y')
    reservation.end_time.should == reservation.end_date_time.strftime('%-l:%M %p')
  end
  
  it "should call :get_schedule_by_mem_id for extra information" do
    CsiApi::ClientFactory.should_receive(:generate_soap_client) { Savon.client(wsdl: "spec/fixtures/ApiService45.wsdl") }
    savon.expects(:get_schedule_by_mem_id).with(message: { mem_id: reservation.member_id }).returns(File.read("spec/fixtures/get_schedule_by_mem_id_response.xml"))
    reservation.equipment_id
  end
  
  it "should store extra information and not call the API a second time" do
    CsiApi::ClientFactory.should_receive(:generate_soap_client) { Savon.client(wsdl: "spec/fixtures/ApiService45.wsdl") }
    savon.expects(:get_schedule_by_mem_id).with(message: { mem_id: reservation.member_id }).returns(File.read("spec/fixtures/get_schedule_by_mem_id_response.xml"))
    reservation.equipment_id
    reservation.equipment_id
  end
  
  it "should fill in remaining attributes correctly" do
    CsiApi::ClientFactory.should_receive(:generate_soap_client) { Savon.client(wsdl: "spec/fixtures/ApiService45.wsdl") }
    savon.expects(:get_schedule_by_mem_id).with(message: { mem_id: reservation.member_id }).returns(File.read("spec/fixtures/get_schedule_by_mem_id_response.xml"))
    reservation.equipment_id.should == "0"
    reservation.short_desc.should == "REV"
    reservation.bio_url.should == ""
    reservation.instructor.should == "Lisa F."
  end
  
end
  
  