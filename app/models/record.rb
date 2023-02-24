class Record < ApplicationRecord
    belongs_to :user

    def format_for_frontend
        {
            diastolic: self.diastolic,
            systolic: self.systolic,
            notes: self.notes,
            id: self.id,
            rightArmRecorded: self.right_arm_recorded
        }
    end
end
