require 'spec_helper'

describe CsiApi::CartItem do
  include CsiApiMocks
  
  let(:cart_response) { mock_savon_response File.read("spec/fixtures/get_cart_by_mem_num_response.xml") }
  let(:cart_item_info) { cart_response.body[:get_cart_by_mem_num_response][:get_cart_by_mem_num_result][:value][:ols_cart_item][0] }
  
  let(:cart_item) { CsiApi::CartItem.new(cart_item_info) }
  
  it "should initialize from the cart item info returned from the API" do
    cart_item.should be_an_instance_of CsiApi::CartItem
  end
  
  it "should properly parse the attributes" do
    cart_item.reservation_id.should  == "833"
    cart_item.schedule_id.should  == "1286945"
    cart_item.class_name.should  == "Karate"
    cart_item.description.should  == "Karate"
    cart_item.amount.should  == "10.0000"
    cart_item.quantity.should  == "1"
    cart_item.tax.should  == "0"
    cart_item.site_id.should  == "142"
  end
  
end

describe CsiApi::CartGenerator do
  include CsiApiMocks
  
  let(:array_of_item_hashes) do
    response = mock_savon_response File.read("spec/fixtures/get_cart_by_mem_num_response.xml")
    response.body[:get_cart_by_mem_num_response][:get_cart_by_mem_num_result][:value]
  end
  
  let(:item_list) { CsiApi::CartGenerator.generate_list(array_of_item_hashes) }
  
  it "should generate an array when given an array of equipment hashes" do
    item_list.should be_an_instance_of Array
  end
  
  it "should be an array of CartItem objects" do
    item_list[0].should be_an_instance_of CsiApi::CartItem
  end
  
  it "should return an empty array if there is no associated equipment" do
    empty_item_response = mock_savon_response File.read("spec/fixtures/get_cart_by_mem_num_empty_response.xml")
    item_list = CsiApi::CartGenerator.generate_list empty_item_response.body[:get_cart_by_mem_num_response][:get_cart_by_mem_num_result][:value]
    item_list.should == []
  end
  
end
