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
  
  context "validations" do
    it "should require a user id" do
      Micropost.new(@attr).should_not be_valid
    end
    
    it "should require a non-blank content" do
      @user.microposts.build(:content => "    ").should_not be_valid
    end
    
    it "should reject a very long content" do
      @user.microposts.build(:content => "a" * 141).should_not be_valid
    end
  end
  
  context "from_users_followed_by" do
    before(:each) do
      @other_user = Factory(:user, :email => Factory.next(:email))
      @third_user = Factory(:user, :email => Factory.next(:email))
      
      @user_post = @user.microposts.create!(:content => "foo")
      @other_post = @other_user.microposts.create!(:content => "bar")
      @third_post = @third_user.microposts.create!(:content => "baz")
      
      @user.follow!(@other_user)
    end
    
    it "should have a from_users_followed_by class method" do
      Micropost.should respond_to(:from_users_followed_by)
    end
    
    it "should include the followed user's microposts" do
      Micropost.from_users_followed_by(@user).should include(@other_post)
    end
    
    it "should include the user's own microposts" do
      Micropost.from_users_followed_by(@user).should include(@user_post)
    end
    
    it "should not include an unfollowed user's microposts" do
      Micropost.from_users_followed_by(@user).should_not include(@third_post)
    end
  end
end


