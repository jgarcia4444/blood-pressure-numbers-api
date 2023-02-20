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
            user = User.find_by(id: user_id.to_i)
            users_codes = OtaCode.all.select {|ota| ota.user_id == user_id.to_i}
            if user_codes.count > 0
                user_codes.destroy_all
            end
            if user
                ota_code = OtaCode.generate_code
                if ota_code.split('').count == 6
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
        if params[:user_id]
            user_id = params[:user_id].to_i
            user = User.find_by(id: user_id)
            if user 
                if params[:ota_code]
                    ota_code = params[:ota_code]
                    if ota_code.split('').count == 6
                        user_ota_code = OtaCode.find_by(user_id: user_id)
                        if user_ota_code.code == ota_code
                            user.update(code_verified: true)
                            render :json => {
                                success: true,
                            }
                        else
                            render :json => {
                                success: false,
                                error: {
                                    message: "Incorrect Code"
                                }
                            }
                        end
                    else
                        render :json => {
                            success: false,
                            error: {
                                message: "The OTA code is the incorrect length."
                            }
                        }
                    end
                else
                    render :json => {
                        success: false,
                        error: {
                            message: "A code was not sent to the route."
                        }
                    }
                end
            else
                render :json => {
                    success: false,
                    error: {
                        message: "No user was found with the given information."
                    } 
                }
            end
        else
            render :json => {
                success: false,
                error: {
                    message: "User information must be sent to access this route."
                }
            }
        end
    end

    def change_password
        if params[:user_id]
            user_id = params[:user_id].to_i
            user = User.find_by(id: user_id)
            if user
                if user.code_verified == true
                    if params[:new_password]
                        new_password = params[:new_password]
                        if new_password != user.password
                            if new_password.split('').count > 7
                                user.update(password: new_password, code_verified: false)
                                if user.valid?
                                    render :json => {
                                        success: true,
                                    }
                                else
                                    render :json => {
                                        success: false,
                                        error: {
                                            message: "An error occurred while updating the users password."
                                        }
                                    }
                                end
                            else
                                render :json => {
                                    success: false,
                                    error: {
                                        message: "Password must be 8 characters or longer."
                                    }
                                }
                            end
                        else
                            render :json => {
                                success: false,
                                error: {
                                    message: "User must not use an old password"
                                }
                            }
                        end
                    else
                        render :json => {
                            success: false,
                            error: {
                                message: "A new password must be sent to update the user."
                            }
                        }
                    end
                else
                    render :json => {
                        success: false,
                        error: {
                            message: "User must verify with a one time passcode to complete this action."
                        }
                    }
                end
            else
                render :json => {
                    success: false,
                    error: {
                        message: "User was not found with the given information."
                    }
                }
            end
        else
            render: json => {
                success: false,
                error: {
                    message: "User information is needed to access this route."
                }
            }
        end
    end

    private
        def user_params
          params.require(:new_user_info).permit(:email, :password)  
        end
end