class TuanDetail < ActiveRecord::Base
  belongs_to:tuan
end

# == Schema Information
#
# Table name: tuan_details
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  content    :text
#  position   :integer(4)      default(0)
#  kind       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  tuan_id    :integer(4)
#

