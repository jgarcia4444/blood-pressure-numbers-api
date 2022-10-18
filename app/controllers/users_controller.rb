class UsersController < ApplicationController
    def create
        if params[:new_user_info]
            new_user_info = params[:new_user_info]
            if new_user_info[:email]
                email = new_user_info[:email]
                if new_user_info[:password]
                    password = new_user_info[:password]
                    created_user = User.create(email: email.downcase, password: password)
                    if created_user.valid?
                        render :json => {
                            success: true,
                            userInfo: {
                                userId: created_user.id,
                                email: created_user.email
                            }
                        }
                    else
                        general_error = {
                            errorType: "GENERAL",
                            message: "There was an error saving your user information."
                        }
                        render :json => {
                            success: false,
                            errors: [general_error],
                            backendErrorData: created_user.errors.full_messages
                        }
                    end
                else
                    no_pasword = {
                        errorType: "PASSWORD",
                        message: "Password cannot be left blank"
                    }
                    render :json => {
                        success: false,
                        errors: [no_pasword]
                    }
                end
            else
                no_email = {
                    errorType: "EMAIL",
                    message: "Email cannot be left blank"
                }
                render :json => {
                    success: false,
                    errors: [no_email]
                }
            end
        else
            general_error = {
                errorType: "GENERAL", 
                message: "Users information was not sent properly."
            }
            render :json => {
                success: false,
                errors: [general_error]
            }
        end
    end

    private
        def user_params
          params.require(:new_user_info).permit(:email, :password)  
        end
end