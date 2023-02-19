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

    def send_user_code
        if params[:user_id]
            user_id = params[:user_id]
            user = User.find_by(user_id: user_id.to_i)
            if user
                ota_code = OtaCode.generate_code
                if ota_code.count == 6
                    created_ota = OtaCode.create(user_id: user_id.to_i, code: ota_code)
                    if created_ota.valid?
                        email_info = {
                            ota_code: created_ota.code,
                            user_email: user.email,
                        }
                        user.update(code_verified: false)
                        begin
                            UserNotificationMailer.send_verification_code(email_info).deliver_now
                            render :json => {
                                success: true,
                            }
                        rescue StandardError => e
                            render :json => {
                                success: false,
                                error: {
                                    message: "An error occured sending the code through email.",
                                    specificError: e.inspect
                                }
                            }
                        end
                    else
                        render :json => {
                            success: false,
                            error: {
                                message: "There was an error persisting the ota code information."
                            }
                        }
                    end
                else
                    render :json => {
                        success: false,
                        error: {
                            message: "There was an error creating the ota code."
                        }
                    }
                end
            else
                render :json => {
                    success: false,
                    error: {
                        message: "No user record found with the given information."
                    }
                }
            end
        else
            render :json => {
                success: false,
                error: {
                    message: "User information must be sent in order to process this request"
                }
            }
        end
    end

    def verify_user_code
    end

    def change_password
    end

    private
        def user_params
          params.require(:new_user_info).permit(:email, :password)  
        end
end