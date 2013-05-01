require 'spec_helper'
require 'savon/mock/spec_helper'

describe CsiApi::ClientFactory do
  
  include Savon::SpecHelper
  before(:all) { savon.mock! }
  after(:all) { savon.unmock! }
  
  let(:factory) do
    factory = CsiApi::ClientFactory
    factory.configure_factory({ wsdl: "spec/fixtures/ApiService.wsdl", consumer_username: "test_user", consumer_password: "test_password" })
    factory
  end
  
  let(:consumer_message) { { consumer_name: "test_user", consumer_password: "test_password" } }
  
  let(:auth_consumer_response) { fixture = File.read("spec/fixtures/factory/authenticate_consumer_response.xml") }
  
  subject { factory }
  
  describe "generate soap client" do
    it "generates a soap client" do
      
      savon.expects(:authenticate_consumer).with(message: consumer_message).returns(auth_consumer_response)
      
      csi_client = factory.generate_soap_client
      csi_client.should be_an_instance_of Savon::Client
      (csi_client.globals[:soap_header]).should have_key "tns:ConsumerAuthTicket" 
    end
    
    describe "generate a member client" do
      let(:member_auth_ticket) do
        value = File.read("spec/fixtures/factory/member_auth_ticket.xml")
        auth_ticket = { value: value }
      end
      it "should generate a member client" do
        savon.expects(:authenticate_consumer).with(message: consumer_message).returns(auth_consumer_response)
        csi_member_client = factory.generate_member_client(member_auth_ticket)
        csi_member_client.should be_an_instance_of Savon::Client
        csi_member_client.globals[:soap_header].should have_key "tns:MemberAuthTicket"
        csi_member_client.globals[:soap_header].should_not have_key "tns:EmployeeAuthTicket"
      end
      
    end
    
    describe "generate an employee client" do
      let(:employee_auth_ticket) do 
        value = File.read("spec/fixtures/factory/employee_auth_ticket.xml")
        auth_ticket = { value: value }
      end
      it "should generate an employee client" do
        savon.expects(:authenticate_consumer).with(message: consumer_message).returns(auth_consumer_response)
        csi_employee_client = factory.generate_employee_client(employee_auth_ticket)
        csi_employee_client.should be_an_instance_of Savon::Client
        csi_employee_client.globals[:soap_header].should have_key "tns:EmployeeAuthTicket"
        csi_employee_client.globals[:soap_header].should_not have_key "tns:MemberAuthTicket"
      end
      
    end
    
  end
  
end