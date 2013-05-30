require 'spec_helper'

describe CsiApi::ListGenerator do

  it "should return an empty array if the item_list is nil" do
    list = CsiApi::ListGenerator.generate_list(nil)
    list.should == []
  end
  
  it "should raise a NotImplementedError if an item_list is passed directly to the generate_list method" do
      expect { CsiApi::ListGenerator.generate_list(["something"]) }.to raise_error(NotImplementedError)
  end
  
end