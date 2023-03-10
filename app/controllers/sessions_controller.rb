class SessionsController < ApplicationController
    def login
        if params[:login_info]
            login_info = params[:login_info]
            if login_info[:email]
                email = login_info[:email]
                found_user = User.find_by(email: email.downcase)
                if found_user
                    puts "User was found"
                    if login_info[:password]
                        puts "Password info was found"
                        passed_password = login_info[:password]
                        if found_user.authenticate(passed_password)
                            puts "User Password correct"
                            render :json => {
                                success: true,
                                userInfo: {
                                    email: found_user.email,
                                    userId: found_user.id,
                                    username: found_user.username,
                                }
                            }
                        else
                            puts "User password incorrect"
                            incorrect_password = {
                                errorType: "PASSWORD",
                                message: "Incorrect password."
                            }
                            render :json => {
                                success: false,
                                errors: [incorrect_password]
                            }
                        end
                    else
                        password_error = {
                            errorType: "PASSWORD",
                            message: "A password must be present to login."
                        }
                        render :json => {
                            success: false,
                            errors: [password_error]
                        }
                    end
                else
                    user_found_error = {
                        errorType: "GENERAL",
                        message: "No user found with this email."
                    }
                    render :json => {
                        success: false,
                        errors: [user_found_error]
                    }
                end
            else
                email_error = {
                    errorType: "EMAIL",
                    message: "An email must be present to login."
                }
                render :json => {
                    success: false,
                    errors: [email_error]
                }
            end
        else 
            info_error = {
                errorType: "PARAMS",
                message: "Information was sent improperly to login."
            }
            render :json => {
                success: false,
                errors: [info_error]
            }
        end
    end

    def welcome
        render :json => {
            message: "Welcome to the EC2 instance of the BPN API."
        }
    end
end