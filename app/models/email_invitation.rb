class EmailInvitation < ApplicationRecord
    belongs_to :user
    belongs_to :organization
    has_secure_token :invitation_code
end
