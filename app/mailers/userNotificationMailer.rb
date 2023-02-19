class UserNotifierMailer < ApplicationMailer

    default from: "bloodpressurenumbers2020@gmail.com"

    def send_verification_code(email_info)
        @code = email_info[:ota_code]
        mail to: email_info[:user_email], subject: "Password Reset Verification"
    end

end