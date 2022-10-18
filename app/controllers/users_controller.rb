class UsersController < ApplicationController
    def create
    end

    private
        def user_params
          params.require(:new_user_info).permit(:email, :password)  
        end
end