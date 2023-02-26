
class DayStreaksController < ApplicationController

    def create
        if params[:user_id]
            user_id = params[:user_id].to_i
            user = User.find_by(id: user_id)
            if user 
                expiration = DayStreak.configure_expiration
                day_streak = DayStreak.create(user_id: user.id, expires_at: expiration, days: 1)
                if day_streak.valid?
                    render :json => {
                        success: true,
                        dayStreak: {
                            days: 1,
                            expiresAt: expiration,
                            updatedAt: day_streak.created_at
                        }
                    }
                else
                    render :json => {
                        success: false,
                        error: {
                            message: "While attempting to create the new day streak an error occurred.",
                            errors: day_streak.errors.full_messages
                        }
                    }
                end
            else
                render :json => {
                    succes: false,
                    error: {
                        message: "A User was not ound with the given user id."
                    }
                }
            end
        else
            render :json => {
                success: false,
                error: {
                    message: "A user id must be present to complete this request",
                }
            }
        end
    end

    def update
        if params[:update_info]
            update_info = params[:update_info]
            if update_info[:user_id]
                user_id = update_info[:user_id].to_i
                user = User.find_by(id: user_id)
                if user
                    day_streak = DayStreak.find_by(user_id: user.id)
                    if day_streak
                        days_plus_one = day_streak + 1
                        updated_expiration = DayStreak.configure_expiration
                        day_streak.update(days: days_plus_one, expires_at: updated_expiration)
                        if day_streak.valid?
                        else
                            render :json => {
                                success: false,
                                error: {
                                    message: "There was an error updating the day streak.",
                                    errors: day_streak.errors.full_messages,
                                }
                            }
                        end
                    else
                        render :json => {
                            success: false,
                            error: {
                                message: "Could not find the day streak associated with the user."
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
                    message: "Information was not formatted properly when sent to this route."
                }
            }
        end
    end

    def show
        if params[:user_id]
            user_id = params[:user_id].to_i
            user = User.find_by(id: user_id)
            if user
                day_streak = DayStreak.find_by(user_id: user.id)
                if day_streak 
                    render :json => {
                        success: true,
                        dayStreak: {
                            days: day_streak.days,
                            expiresAt: day_streak.expires_at,
                            updatedAt: day_streak.updated_at
                        }
                    }
                else
                    render :json => {
                        success: true,
                        dayStreak: {
                            days: 0,
                            expiresAt: "",
                            updatedAt: ""
                        }
                    }
                end
            else
                render :json => {
                    succes: false,
                    error: {
                        message: "A User was not ound with the given user id."
                    }
                }
            end
        else
            render :json => {
                success: false,
                error: {
                    message: "A user id must be present to complete this request",
                }
            }
        end
    end
end