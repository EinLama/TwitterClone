require 'spec_helper'

describe Micropost do
  before :each do
    @user = Factory(:user)
    @attr = { :content => "some text" }
  end

  it "should create a new instance given valid attributes" do
    @user.microposts.create!(@attr)
  end
  
  context "in association with users" do
    before(:each) do
      @micropost = @user.microposts.create(@attr)
    end
    
    it "each micropost should have a user attribute" do
      @micropost.should respond_to(:user)
    end
    
    it "a micropost should refer to the right user" do
      @micropost.user_id.should == @user.id
      @micropost.user.should == @user
    end
  end
end
