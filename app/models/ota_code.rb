class OtaCode < ApplicationRecord
    belongs_to :user

    def self.generate_code
        code = ""
        6.times do |n|
            code += rand(10).to_s
        end
        code
    end
end