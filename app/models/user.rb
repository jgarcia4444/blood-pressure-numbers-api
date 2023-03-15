class User < ApplicationRecord
    has_secure_password
    has_many :records, dependent: :destroy
    has_one :day_streak, dependent: :destroy
    has_one :permission, dependent: :destroy
    has_many :forum_messages, dependent: :destroy

    validates :email, uniqueness: true
    validates :username, uniqueness: true


    def format_user_records
        if self.records.count == 0
            return []
        else
            self.records.map do |record|
                {
                    systolic: record.systolic,
                    diastolic: record.diastolic,
                    notes: record.notes,
                    rightArmRecorded: record.right_arm_recorded,
                    dateRecorded: record.created_at,
                    id: record.id
                }
            end
        end
    end

end
