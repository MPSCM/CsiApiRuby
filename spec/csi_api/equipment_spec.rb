require 'spec_helper'

describe Equipment do
  include CsiApiMocks

  let(:equipment_hash) do
    response = mock_savon_response File.read("spec/fixtures/get_equipment_list_response.xml")
    response.body[:get_equipment_list_response][:get_equipment_list_result][:value][:equipment_list][:equipment_info][0]
  end
  
  let(:eqipment_obj) { Equipment.new equipment_hash }
  
  describe "it should initialize with a hash of options" do 
    equipment = Equipment.new(equipment_hash).should_not be_nil
  end
  
  describe "it should return the equipment name" do
    equipment_obj.name.should == "Bike 2"
  end
  
  describe "it should return the x and y coordinates" do
    equipment_obj.x.should == 147
    equipment_obj.y.should == 0
  end
  
  describe "it should return true/false for an associated member" do
    equipment_obj.member_associated?.should == false
  end
  
  describe "it should return true/false for being booked" do
    equipment_obj.booked?.should == false
  end

end