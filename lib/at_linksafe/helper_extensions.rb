require 'at_linksafe/controller_extensions/auth.rb' # yes, it's controller_extensions
require 'at_linksafe/helper_extensions/message_helper.rb'
require 'at_linksafe/helper_extensions/user_helper.rb'

module AtLinksafe
  module HelperExtensions
    include AtLinksafe::ControllerExtensions::Auth    
    include UserHelper
    include MessageHelper
  end
end
