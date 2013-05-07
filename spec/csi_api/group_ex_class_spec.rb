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
  
  before(:each) do
    CsiApi::ClientFactory.should_receive(:generate_soap_client) { base_client }
    group_ex_class 
  end
  
  it "should initialize" do
    group_ex_class.should be_an_instance_of CsiApi::GroupExClass
    group_ex_class.class_name.should == "REV"
  end
  
  it "should have a soap client" do
    group_ex_class.soap_client.should == base_client
  end
  
  it "should make soap call for class details on initialize" do
    group_ex_class
  end
  
  it "should have a DateTime object for :start_date_time and :end_date_time" do
    group_ex_class.start_date_time.should be_an_instance_of(DateTime)
    group_ex_class.end_date_time.should be_an_instance_of(DateTime)
  end
  
  it "should set the DateTime object as a combination of start time for the class and the date passed to ::new" do
    group_ex_class.start_date_time.should == DateTime.new(2013, 04, 15, 6, 00)
    group_ex_class.end_date_time.should == DateTime.new(2013, 04, 15, 6, 45)
  end
  
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

end