
class ForumMessagesController < ApplicationController
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