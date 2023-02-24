class RecordsController < ApplicationController
    def index
        if params[:user_id]
            user_id = params[:user_id]
            found_user = User.find_by(id: user_id.to_i)
            if found_user
                formatted_records = found_user.format_user_records
                render :json => {
                    success: true,
                    userRecords: formatted_records
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
                                id: persisted_record.id,
                                systolic: persisted_record.systolic,
                                diastolic: persisted_record.diastolic,
                                rightArmRecorded: persisted_record.right_arm_recorded,
                                notes: persisted_record.notes,
                                dateRecorded: persisted_record.created_at
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

    def destroy
        if params[:user_id]
            user_id = params[:user_id]
            if params[:record_id]
                record_id = params[:record_id]
                record = Record.find_by(id: record_id.to_i, user_id: user_id.to_i)
                if record
                    record_destroyed = record.destroy
                    if record_destroyed
                        render :json => {
                            success: true,
                            userRecordId: record_destroyed.id,
                        }
                    else
                        render :json => {
                            success: false,
                            error: {
                                message: "An error occurred while attempting to destroy the record."
                            }
                        }
                    end
                else
                    render :json => {
                        success: false,
                        error: {
                            message: "Record was not found with the given information"
                        }
                    }
                end
            else
                render :json => {
                    success: false,
                    error: {
                        message: "A record id must be present with this route."
                    }
                }
            end
        else
            render :json => {
                success: false,
                error: {
                    message: "A user id must be present with this route."
                }
            }
        end
    end

    def update 
        if params[:update_record_info]
            update_info = params[:update_record_info]
            if update_info[:user_id]
                user_id = update_info[:user_id]
                user = User.find_by(id: user_id.to_i)
                if user
                    if update_info[:systolic]
                        systolic = update_info[:systolic]
                        if update_info[:diastolic]
                            diastolic = updat_info[:diastolic]
                            if update_info[:notes]
                                notes = update_info[:notes]
                                if update_info[:right_arm_recorded]
                                    right_arm_recorded = update_info[:right_arm_recorded]
                                    if update_info[:record_id]
                                        record_id = update_info[:record_id]
                                        record = Record.find_by(id: record_id)
                                        if record
                                            record.update(systolic: systolic, diastolic: diastolic, notes: notes, right_arm_recorded: right_arm_recorded)
                                            if record.valid?
                                                render :json => {
                                                    success: true,
                                                    updatedRecord: record.format_for_frontend
                                                }
                                            else
                                                render :json => {
                                                    success: false,
                                                    error: {
                                                        message: "An error occurred while updating the record."
                                                    }
                                                }
                                            end
                                        else
                                            render :json => {
                                                success: false,
                                                error: {
                                                    message: "A record was not found with the given information."
                                                }
                                            }
                                        end
                                    else
                                        render :json => {
                                            success: false,
                                            error: {
                                                message: "The record id must be present to complete this request."
                                            }
                                        }
                                    end
                                else
                                    render :json => {
                                        success: false,
                                        error: {
                                            message: "The right arm recorded value must be present to complete this request."
                                        }
                                    }
                                end
                            else
                                render :json => {
                                    success: false,
                                    error: {
                                        message: "Notes must be present to finish this request."
                                    }
                                    
                                }
                            end
                        else
                            render :json => {
                                success: false,
                                error: {
                                    message: "An input for diastolic must be present."
                                }
                            }
                        end
                    else
                        render :json => {
                            success: false,
                            error: {
                                message: "An input for systolic must be present."
                            }
                        }
                    end
                else
                    render :json => {
                        success: false,
                        error: {
                            message: "A user was not found with the given user id."
                        }
                    }
                end
            else
                render :json => {
                    success: false,
                    error: {
                        message: "A user id must be present to complete this request."
                    }
                }
            end
        else
            render :json => {
                success: false,
                error: {
                    message: "The required info was not formatted properly."
                }
            }
        end
    end

    private
        def record_params
            params.require(:new_record_info).permit(:systolic, :diastolic, :notes, :right_arm_recorded)
        end

end