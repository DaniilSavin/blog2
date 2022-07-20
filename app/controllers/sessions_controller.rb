class SessionsController < ApplicationController
    def new
    end
  
  
    def create
      user = User.find_by(name: params[:session][:name].downcase)
      if user
          sign_in user
          redirect_to user
      else
      flash.now[:error] = "Invalid email/password combination"
      render 'new'
    end
  
    def destroy
    end
end
