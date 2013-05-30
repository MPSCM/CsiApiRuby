require 'spec_helper'

describe CsiApi::Equipment do
  include CsiApiMocks

  let(:equipment_hash) do
    response = mock_savon_response File.read("spec/fixtures/get_equipment_list_response.xml")
    response.body[:get_equipment_list_response][:get_equipment_list_result][:value][:equipment_list][:equipment_info][0]
  end
  
  let(:equipment_obj) { CsiApi::Equipment.new equipment_hash }
  
  it "should initialize with a hash of options" do
    equipment_hash
    equipment = CsiApi::Equipment.new(equipment_hash).should_not be_nil
  end
  
  it "should return the equipment name" do
    equipment_obj.name.should == "Bike  2"
  end
  
  it "should return the x and y coordinates" do
    equipment_obj.x.should == 147
    equipment_obj.y.should == 0
  end
  
  it "should return true/false for an associated member" do
    equipment_obj.member_associated?.should == false
  end
  
  it "should return true/false for being booked" do
    equipment_obj.booked?.should == false
  end

end

describe CsiApi::EquipmentListGenerator do
  include CsiApiMocks
  
  let(:array_of_equipment_hashes) do
    response = mock_savon_response File.read("spec/fixtures/get_equipment_list_response.xml")
    response.body[:get_equipment_list_response][:get_equipment_list_result][:value][:equipment_list]
  end
  
  let(:equipment_list) { CsiApi::EquipmentListGenerator.generate_list(array_of_equipment_hashes) }
  
  it "should generate an array when given an array of equipment hashes" do
    equipment_list.should be_an_instance_of Array
  end
  
  it "should be an array full of Equipment Objects" do
    equipment_list[0].should be_an_instance_of CsiApi::Equipment
  end  
  
  it "should return an empty array if there is no associated equipment" do
    empty_equipment_response = mock_savon_response File.read("spec/fixtures/get_equipment_list_empty_response.xml")
    equipment_list = CsiApi::EquipmentListGenerator.generate_list empty_equipment_response.body[:get_equipment_list_response][:get_equipment_list_result][:value][:equipment_list]
    equipment_list.should == []
  end
  
  it "should not fail if the input has a single class hash and is not an array" do
    single_item_response = mock_savon_response File.read("spec/fixtures/get_equipment_list_single_item_response.xml")
    equipment_list = CsiApi::EquipmentListGenerator.generate_list single_item_response.body[:get_equipment_list_response][:get_equipment_list_result][:value][:equipment_list]
    equipment_list.length.should == 1
  end
  
end