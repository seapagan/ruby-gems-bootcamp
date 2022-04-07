# frozen-string-literal: true

# Define helper functions for the Users Classes
module UsersHelper
  def ban_status(user)
    if user.access_locked?
      'Unban'
    else
      'Ban'
    end
  end
end
