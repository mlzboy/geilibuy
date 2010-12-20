
module UUIDHelper
  require 'uuid'
  def add_uuid
    return UUID.new.generate
  end
end
#include UUIDHelper
#puts UUIDHelper.add_uuid
###require 'uuid'
###puts UUID.new.generate
#def add_uuid
#  return UUID.new.generate
#end
