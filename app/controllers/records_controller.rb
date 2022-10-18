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
        if params[:user_id]
            user_id = params[:user_id]
            found_user = User.find_by(id: user_id)
            if found_user
                if params[:new_record_info]
                    new_record_info = params[:new_record_info]
                    persisted_record = Record.new(record_params)
                    persisted_record.user_id = user_id
                    persisted_record.save
                    if persisted_record.valid?
                        render :json => {
                            success: true,
                            persistedRecord: {
                                systolic: persisted_record.systolic,
                                diastolic: persisted_record.diastolic,
                                rightArmRecorded: persisted_record.right_arm_recorded,
                                notes: persisted_record.notes
                            }
                        }
                    else
                        record_persistance_error = {
                            errorType: "RECORD",
                            message: "There were error(s) when attempting to persist the record"
                        }
                        render :json => {
                            success: false,
                            errors: [record_persistance_error],
                            backendErrorData: persisted_record.errors.full_messages,
                        }
                    end
                else
                    info_error = {
                        errorType: "PARAMS",
                        message: "Proper information was not sent with the request. Record is unable to be saved."
                    }
                    render :json => {
                        success: false,
                        errors: [info_error]
                    }
                end
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
                message: "Proper identification was not sent with the request. Record is unable to be saved."
            }
            render :json => {
                success: false,
                errors: [info_error]
            }
        end
    end

    private
        def record_params
            params.require(:new_record_info).permit(:systolic, :diastolic, :notes, :right_arm_recorded)
        end

end