class MembershipHistory < ApplicationRecord
    def user_changed_name
        user_changed = User.find(self.user_changed_id)
        return user_changed.name
    end

    def changed_by_name
        changed_by = User.find(self.changed_by_id)
        return changed_by.name
    end
end
