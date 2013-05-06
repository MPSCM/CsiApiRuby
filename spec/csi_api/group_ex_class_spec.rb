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
  let(:group_ex_class) { CsiApi::GroupExClass.new class_info }
  
  before(:each) do
    CsiApi::ClientFactory.should_receive(:generate_soap_client) { base_client }
    savon.expects(:get_schedule_by_mem_id).with(message: { schedule_id: "1286511" }).returns(single_class_info)
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
  
  it "should set remaining attributes from the class details soap call" do
    group_ex_class.short_desc.should == "REV"
  end
  
  it "should have a DateTime object for :schedule_date_from and :schedule_date_to" do
    group_ex_class.schedule_date_from.class.should == DateTime 
    group_ex_class.schedule_date_from.should == DateTime.strptime("4/15/2013 6:00:00 AM", '%m/%d/%Y %H:%M:%S %p')
    group_ex_class.schedule_date_to.class.should == DateTime
    group_ex_class.schedule_date_to.should == DateTime.strptime("4/15/2013 6:45:00 AM", '%m/%d/%Y %H:%M:%S %p')
  end

end