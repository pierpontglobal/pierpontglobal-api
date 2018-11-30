class Color < ApplicationRecord
  scope :sanitized, lambda { |mapper, l_alias|
    select("#{mapper}.name as color_name_#{l_alias}",
           "#{mapper}.hex as color_hex_#{l_alias}")
  }
end
