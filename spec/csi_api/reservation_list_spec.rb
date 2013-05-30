require 'spec_helper'

describe CsiApi::ReservationList do

  include CsiApiMocks
  
  let(:res_list) { CsiApi::ReservationList.new("534763") }
  
  it "should inherit from GroupExClassList" do
    CsiApi::ReservationList.superclass.should == CsiApi::GroupExClassList
  end
  
  it "should initialize @class_list to an empty array" do
    res_list.class_list.should == []
  end
  

  
  it "should initialize with an array of reservations from the API" do
   schedules_response = mock_savon_response File.read("spec/fixtures/get_group_ex_schedules_response.xml") 
   schedules_array = schedules_response.body[:get_group_ex_schedules_response][:get_group_ex_schedules_result][:value][:member_schedule_info]
   reservation_list = CsiApi::ReservationList.new("534763", schedules_array)
   reservation_list.should be_an_instance_of CsiApi::ReservationList
 end
 
 it "should convert reservations into Reservations, and append them to @class_list" do
   schedules_response = mock_savon_response File.read("spec/fixtures/get_group_ex_schedules_response.xml") 
   schedules_array = schedules_response.body[:get_group_ex_schedules_response][:get_group_ex_schedules_result][:value][:member_schedule_info]
   reservation_list = CsiApi::ReservationList.new("534763", schedules_array)
   reservation_list.class_list[0].should be_an_instance_of CsiApi::Reservation
 end   
 
 it "should return an empty Reservation list if the array of reservations is []" do
   reservation_list = CsiApi::ReservationList.new("534763", [])
   reservation_list.class_list.should == []
 end
 
 it "should not fail if the array of reservations has only one reservation" do
   schedules_response = mock_savon_response File.read("spec/fixtures/get_group_ex_schedules_single_item_response.xml")
   schedules_array =    schedules_response.body[:get_group_ex_schedules_response][:get_group_ex_schedules_result][:value][:member_schedule_info]
   reservation_list = CsiApi::ReservationList.new("534763", schedules_array)
   reservation_list.class_list.length.should == 1
 end
  
end