require 'spec_helper'
require 'savon/mock/spec_helper'

describe CsiApi::Member do
  include Savon::SpecHelper
  before(:all) { savon.mock! }
  after(:all) { savon.unmock! }

  let(:member_info) do
    xml_info = File.read("spec/fixtures/authenticate_member_response.xml")
    Http = Struct.new(:code, :headers, :body) do
      def error?
        false
      end
    end
    http = Http.new(200, {}, xml_info)
    savon_local_options = Savon::LocalOptions.new
    savon_global_options = Savon::GlobalOptions.new
    savon_response = Savon::Response.new(http, savon_global_options, savon_local_options)
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