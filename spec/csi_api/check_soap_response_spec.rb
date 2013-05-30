require 'spec_helper'

describe CsiApi::CheckSoapResponse do
  include CsiApiMocks
  
  let(:valid_soap_response) { mock_savon_response File.read("spec/fixtures/authenticate_employee_response.xml") }
  let(:invalid_soap_response) { mock_savon_response File.read("spec/fixtures/authenticate_employee_exception_response.xml") }
  
  include CsiApi::CheckSoapResponse
  
  it "should return false if there is no exception" do
    check_soap_response(valid_soap_response, :authenticate_employee).should be_false
  end
  
  it "should return the exception string if there is an exception" do
    check_soap_response(invalid_soap_response, :authenticate_employee).should == "Invalid login name or password. Please try again."
  end
  
end