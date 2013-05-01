require 'spec_helper'

describe CsiApi::Member do
  include CsiApiMocks
  
  let(:member_info) do
    xml_response = File.read("spec/fixtures/authenticate_member_response.xml")
    mock_savon_response xml_response
  end  
  
  let(:member_auth_token) do
    member_info.body[:authenticate_member_response][:authenticate_member_result][:value][:member_ticket]
  end
  
  it "should initialize" do
    CsiApi::ClientFactory.should_receive(:generate_member_client).with(member_auth_token)
    member = CsiApi::Member.new member_info
    member.should be_an_instance_of CsiApi::Member    
  end
  
end