require 'spec_helper'
require 'savon/mock/spec_helper'

describe CsiApi::CsiClient do
  include Savon::SpecHelper
  include CsiApiMocks
  
  before(:all) { savon.mock! }
  after(:all) { savon.unmock! }
  let(:base_client) { Savon.client(wsdl: "spec/fixtures/ApiService45.wsdl") } 
  let(:options) { { wsdl: "spec/fixtures/ApiService45.wsdl", consumer_username: "test_user",
                                     consumer_password: "test_password" } }
                                     
  before(:each) do
    CsiApi::ClientFactory.should_receive(:configure_factory).with(options)
    CsiApi::ClientFactory.should_receive(:generate_soap_client) { base_client }
  end
  
  describe "initialization" do
    it "should initialize" do  
      client = CsiApi::CsiClient.new(options)
      client.should be_an_instance_of CsiApi::CsiClient
      client.soap_client.should == base_client
    end
  end
  
  describe "generate employees and members" do
    let(:csi_client) { CsiApi::CsiClient.new(options) }

     it "should fetch member information" do
       message = { username: "test_user", password: "test_password" }
       response = File.read("spec/fixtures/authenticate_member_response.xml")
       savon.expects(:authenticate_member).with(message: message).returns(response)
       member_info = csi_client.get_member_info("test_user", "test_password")
       member_info.should_not be_false
       member_info.body.should have_key :authenticate_member_response
     end
     
     it "should fetch employee information" do
       message = { user_name: "test_user", password: "test_password" }
       response = File.read("spec/fixtures/authenticate_employee_response.xml")
       savon.expects(:authenticate_employee).with(message: message).returns(response)
       employee_info = csi_client.get_employee_info("test_user", "test_password")
       employee_info.should_not be_false
       employee_info.body.should have_key :authenticate_employee_response
     end
     
  end
  
  describe "retrieve list of classes" do
    let(:csi_client) { CsiApi::CsiClient.new(options) }
    
    it "should query the CSI API for a list of classes" do
      tax_day = "2013-04-15"
      schedules_message = { mod_for: "GRX_Group_Exercise", site_id: 142, from_date: "2013-04-15", to_date: "2013-04-15" }
      response = File.read("spec/fixtures/get_class_schedules_response.xml")
      savon.expects(:get_class_schedules).with(message: schedules_message).returns(response)
      csi_client.get_class_list(142, tax_day, tax_day)
    end
  end
  
end