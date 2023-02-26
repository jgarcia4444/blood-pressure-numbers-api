
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