class ActivityLog < ApplicationRecord
  belongs_to :user

  def sanitized
    {
      id: id,
      browser: browser,
      ip_address: ip_address,
      controller: controller,
      action: action,
      params: params,
      note: note,
      created_at: created_at,
      user: user.sanitized
    }
  end

end
