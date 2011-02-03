class KindeditorImage < ActiveRecord::Base
   #before_create :randomize_file_name
    has_attached_file :data,:url => "/system/uploads/:id_partition/:style/:filename",:path => ":rails_root/public/system/uploads/:id_partition/:style/:filename"
    
    private
    def randomize_file_name

      unless data_file_name.nil?
        extension = File.extname(data_file_name).downcase
        self.data.instance_write(:file_name, "#{ActiveSupport::SecureRandom.hex(16)}#{extension}")
      end
    end
end

# == Schema Information
#
# Table name: kindeditor_images
#
#  id                :integer(4)      not null, primary key
#  data_file_name    :string(255)
#  data_content_type :string(255)
#  data_file_size    :integer(4)
#  data_updated_at   :datetime
#  created_at        :datetime
#  updated_at        :datetime
#

