class User < ApplicationRecord
    has_secure_password
    has_many :records

    validates :email, uniqueness: true
    validates :password, presence: true


    def format_user_records
        if self.records.count == 0
            return []
        else
            self.records.map do |record|
                {
                    systolic: record.systolic,
                    diastolic: record.diastolic,
                    notes: record.notes,
                    rightArmRecorded: record.right_arm_recorded
                }
            end
        end
    end

end
