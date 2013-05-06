require 'spec_helper'
require 'savon/mock/spec_helper'

describe CsiApi::GroupExClassList do
  include CsiApiMocks
  include Savon::SpecHelper
  
  before(:all) { savon.mock! }
  after(:all) { savon.unmock! }
  
  let(:get_class_schedules_response) { File.read("spec/fixtures/get_class_schedules_response.xml") }
  let(:get_class_schedules_message) { { mod_for: "GRX_Group_Exercise"  } }
  
  
  let(:csi_client) do
    client = double()
    client.stub(:get_class_list).with(142) { mock_savon_response get_class_schedules_response }
    client
  end  
  
  let(:list) { CsiApi::GroupExClassList.new(csi_client, 142) }
  
  before(:each) do
    CsiApi::GroupExClass.should_receive(:new).with(anything()).at_least(1).times
  end    
  
  it "should get the list of classes from CSI's API" do
    # currently site id is hardcoded in. Need to either iterate over stes
    # or have seperate object for each site
    csi_client.should_receive(:get_class_list).with(142)
    list
  end
  
  it "should save the CsiApi::CsiClient instance" do
    list
    list.csi_client.should == csi_client
  end
  
  it "should create an array of classes" do
    list
    list.class_list.should be_an_instance_of Array
    list.class_list.should_not be_empty
  end
  
  it "should create instances of CsiApi::GroupExClass from the soap response" do
    list
  end
  
end