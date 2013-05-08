require 'spec_helper'
require 'savon/mock/spec_helper'

describe CsiApi::GroupExClassList do
  include CsiApiMocks
  include Savon::SpecHelper
  
  before(:all) { savon.mock! }
  after(:all) { savon.unmock! }
  
  let(:get_class_schedules_response) { File.read("spec/fixtures/get_class_schedules_response.xml") }
  let(:get_class_schedules_message) { { mod_for: "GRX_Group_Exercise"  } }
  let(:tax_day) { DateTime.parse("2013-04-15") }
  
  
  let(:csi_client) do
    client = double()
    client.stub(:get_class_list).with(142, a_kind_of(String), a_kind_of(String)) { mock_savon_response get_class_schedules_response }
    client
  end
  
  let(:list) { CsiApi::GroupExClassList.new(csi_client, { site_id: 142 }) }
  
  before(:each) do
    CsiApi::GroupExClass.should_receive(:new).with(anything(), a_kind_of(Date)).at_least(1).times
    CsiApi::ClientFactory.should_receive(:generate_soap_client).exactly(0).times
  end    
  
  it "should get the list of classes from CSI's API" do
    csi_client.should_receive(:get_class_list).with(142, a_kind_of(String), a_kind_of(String))
    list
  end
  
  it "should save the CsiApi::CsiClient instance" do
    list
    list.csi_client.should == csi_client
  end
  
  it "should have :start_date and :end_date that default to the current date" do
    list
    list.start_date.to_date.should == DateTime.now.to_date
    list.end_date.to_date.should == DateTime.now.to_date
  end
  
  it "should take a :start_date and :end_date option and create matching DateTime objects" do
    start_date = tax_day
    end_date = DateTime.strptime("04/15/2013", "%m/%d/%Y")
    CsiApi::GroupExClassList.new(csi_client, { site_id: 142, start_date: start_date, end_date: end_date })
  end
  
  it "should make a separate call to the CSI API for each day in the range of :start_date..:end_date" do
    n = 3
    start_date = tax_day
    end_date = DateTime.parse("2013-04-17")
    csi_client.should_receive(:get_class_list).with(142, a_kind_of(String), a_kind_of(String)).exactly(n).times
    CsiApi::GroupExClassList.new(csi_client, { site_id: 142, start_date: start_date, end_date: end_date })
  end
  
  it "should create an array of classes" do
    list
    list.class_list.should be_an_instance_of Array
    list.class_list.should_not be_empty
  end

  it "should handle a soap response that consists of zero classes for a particular day" do
    csi_client.should_receive(:get_class_list).with(142, "2013-04-20", "2013-04-20") { mock_savon_response File.read("spec/fixtures/get_class_schedules_response_zero.xml") }
    zero_class_list = CsiApi::GroupExClassList.new(csi_client, { site_id: 142, start_date: "2013-04-20", end_date: "2013-04-20" })
    zero_class_list.class_list.length.should == 0
    # This is just to satisfy the before(:each) requirement for GroupExClass.
    # Because there are no classes, GroupExClass is not called.
    CsiApi::GroupExClass.new(142, DateTime.now)
  end

  it "should handle a soap response that consists of only one class for a particular day" do
    csi_client.should_receive(:get_class_list).with(142, "2013-04-16", "2013-04-16") { mock_savon_response File.read("spec/fixtures/get_class_schedules_response_single.xml") }
    single_class_list = CsiApi::GroupExClassList.new(csi_client, { site_id: 142, start_date: "2013-04-16", end_date: "2013-04-16" })
    single_class_list.class_list.length.should == 1
  end
  
  it "should create instances of CsiApi::GroupExClass from the soap response" do
    list
    # GroupExClass is being stubbed out; it is receiving calls to ::new
  end
  
  it "should combine the responses received for each day into the array of classes" do
    start_date = DateTime.parse("2013-04-15")
    end_date = DateTime.parse("2013-04-17")
    number_of_classes_expected = 0
    start_date.to_date.upto(end_date.to_date) do |date|
      response = mock_savon_response File.read("spec/fixtures/date_range/#{date.to_date.to_s}.xml")
      response_body = response.body[:get_class_schedules_response][:get_class_schedules_result][:value][:class_schedules_info]
      class_array = response_body.class == Array ? response_body : [response_body]
      number_of_classes_expected += class_array.length
      csi_client.should_receive(:get_class_list).with(142, date.to_date.to_s, date.to_date.to_s) { response }
    end
    date_range_list = CsiApi::GroupExClassList.new(csi_client, { site_id: 142, start_date: start_date, end_date: end_date })
    date_range_list.class_list.length.should == number_of_classes_expected
  end
  
  it "should sort the classes in the list by date/time" do
    list
    pending
  end
  
  it "should return a subset of the list chosen by class name" do
    list
    pending
  end
  
  it "should return a subset of the list chosen by instructor name" do 
    list
    pending
  end
  
  it "should return a subset of the list chosen by category" do
    list
    pending
  end
  
  it "should response to #each" do
    list
    pending
  end
  
end