class PresaleConsulting < ActiveRecord::Base
  belongs_to:product
  belongs_to:user
end

# == Schema Information
#
# Table name: presale_consultings
#
#  id         :integer(4)      not null, primary key
#  content    :text
#  ip         :string(255)
#  created_at :datetime
#  updated_at :datetime
#  reply      :text
#  product_id :integer(4)
#  value      :boolean(1)      default(FALSE)
#  hide       :boolean(1)      default(FALSE)
#  user_id    :integer(4)      default(-1)
#  satisfy    :boolean(1)
#

