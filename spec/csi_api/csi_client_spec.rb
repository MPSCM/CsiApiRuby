require 'spec_helper'
require 'savon/mock/spec_helper'

describe CsiApi::CsiClient do
  include Savon::SpecHelper
  
  before(:all) { savon.mock! }
  after(:all) { savon.unmock! }
  let(:base_client) { Savon.client(wsdl: "spec/fixtures/ApiService.wsdl") } 
  let(:options) { { wsdl: "spec/fixtures/ApiService.wsdl", consumer_username: "test_user",
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
  
end