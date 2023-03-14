
class ForumMessagesController < ApplicationController

    def create
        if params[:message_info]
            message_info = params[:message_info]
            if message_info[:username]
               username = message_info[:username]
               user = User.find_by(username: username)
               if user
                    if message_info[:message]
                        message = message_info[:message]
                        created_message = ForumMessage.create(user_id: user.id, message: message)
                        if created_message.valid?
                            render :json => {
                                success: true,
                                message: {
                                    message: message,
                                    username: username,
                                    createdAt: created_message.created_at
                                }
                            }
                        else
                            render :json => {
                                success: false,
                                error: {
                                    message: "There was an error creating the forum message.",
                                    errors: created_message.errors.full_messages
                                }
                            }
                        end
                    else
                        render :json => {
                            success: false,
                            error: {
                                message: "Message info was not sent with the request."
                            }
                        }
                    end

               else
                render :json => {
                    success: false,
                    error: {
                        message: "No user was found with the given username."
                    }
                }
               end
            else
                render :json => {
                    success: false,
                    error: {
                        message: "A username was not found associated with this message."
                    }
                }
            end
        else
            render :json => {
                succes: false,
                error: {
                    message: "Message info was not sent properly."
                }
            }
        end
    end

    def index
        messages = ForumMessage.all 
        if messages.count == 0 
            render :json => {
                success: true,
                messages: []
            }
        else
            formatted_messages = ForumMessage.format_messages 
            render :json => {
                success: true,
                messages: formatted_messages
            }
        end
    end

end