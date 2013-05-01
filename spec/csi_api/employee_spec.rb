require 'spec_helper'

describe CsiApi::Employee do
  include CsiApiMocks
  
  let(:employee_info) do
    xml_response = File.read("spec/fixtures/authenticate_employee_response.xml")
    mock_savon_response xml_response
  end
  
  let(:employee_auth_token) do
    employee_info.body[:authenticate_employee_response][:authenticate_employee_result][:value][:employee_ticket]
  end
  
  it "should initialize" do
    CsiApi::ClientFactory.should_receive(:generate_employee_client).with(employee_auth_token)
    employee = CsiApi::Employee.new employee_info
    employee.should be_an_instance_of CsiApi::Employee
  end
end