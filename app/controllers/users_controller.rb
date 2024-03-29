class UsersController < ApplicationController
before_filter :authenticate, :only => [:edit, :index, :edit, :update, :destroy]
before_filter :correct_user, :only => [:edit, :update]
before_filter :admin_user, :only => :destroy


def following
@title = "Following"
@user = User.find(params[:id])
@users = @user.following.paginate(:page => params[:page])
render 'show_follow'
end

def followers
@title = "Followers"
@user = User.find(params[:id])
@users = @user.followers.paginate(:page => params[:page])
render 'show_follow'
end




def index
   @users = User.paginate(:page => params[:page])
    @title = "All users"

end

def destroy

if params[:id] != 1.to_s
User.find(params[:id]).destroy
flash[:success] = params[:id] != 1.to_s
else
flash[:error]="You cannot delete yourself"
end
redirect_to users_path
end



 def show
   @user = User.find(params[:id])
   @microposts = @user.microposts.paginate(:page => params[:page])
  @title = @user.name
 end

  def new
redirect_to(root_path) unless !signed_in?
  @user = User.new
  @title = "Sign up"
  end

def authenticate
deny_access unless signed_in?
end

def correct_user
@user = User.find(params[:id])
redirect_to(root_path) unless current_user?(@user)
end


def edit
@title = "Edit user"
end


def update
@user = User.find(params[:id])
if @user.update_attributes(params[:user])
flash[:success] = "Profile updated."
redirect_to @user
else
@title = "Edit user"
render 'edit'
end
end



def create
redirect_to(root_path) unless !signed_in?
@user = User.new(params[:user])
if @user.save
sign_in @user
flash[:success] = "Welcome to the Sample App!"
redirect_to @user
else
@title = "Sign up"
render "new"
end
end


private 

def admin_user
redirect_to(root_path) unless current_user.admin?
end



end
