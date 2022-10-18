class RecordsController < ApplicationController
    def index
        if params[:user_id]
            user_id = params[:user_id]
            found_user = User.find(id: user_id)
            if found_user
                formatted_records = found_user.format_user_records
                render :json => {
                    success: true,
                    records: formatted_records
                }
            else 
                find_user_error = {
                    errorType: "USER_INFO",
                    message: "A user was not found with the given identifier."
                }
                render :json => {
                    success: false,
                    errors: [find_user_error]
                }
            end
        else
            info_error = {
                errorType: "PARAMS",
                message: "Proper identification was not sent with the request. Records are unable to be retrieved."
            }
            render :json => {
                success: false,
                errors: [info_error]
            }
        end
    end
    def create
end