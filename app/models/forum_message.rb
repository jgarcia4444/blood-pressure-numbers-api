class ForumMessage < ApplicationRecord
    belongs_to :user


    def self.format_messages 
        messages = ForumMessage.all
        messages.map do |forum_message| 
            username = User.find_by(id: forum_message.user_id).username
            {
                message: forum_message.message, 
                username: username ? username : "",
                createdAt: forum_message.created_at
            }
        end
        messages
    end
end
