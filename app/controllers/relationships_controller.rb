class RelationshipsController < ApplicationController
  before_filter :authenticate

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    
    redirect_by_format(@user)
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    
    redirect_by_format(@user)
  end
  
  private
    
    def redirect_by_format(path)
      respond_to do |format|
        format.html { redirect_to path }
        format.js
      end
    end

end
