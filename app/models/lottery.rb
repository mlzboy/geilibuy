class Lottery < ActiveRecord::Base
end

# == Schema Information
#
# Table name: lotteries
#
#  id          :integer(4)      not null, primary key
#  first_num   :integer(4)      default(0)
#  second_num  :integer(4)      default(0)
#  third_num   :integer(4)      default(0)
#  first_rate  :integer(4)      default(300)
#  second_rate :integer(4)      default(200)
#  third_rate  :integer(4)      default(100)
#  created_at  :datetime
#  updated_at  :datetime
#

