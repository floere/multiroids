require File.dirname(__FILE__) + '/../spec_helper'

describe MotherShip do
  
  before(:each) do
    @mother = Class.new do
      include MotherShip
    end.new
  end
  
  it "should description" do
    
  end
  
end