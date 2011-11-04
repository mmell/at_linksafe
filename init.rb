require 'at_linksafe.rb'
          
ActionController::Base.send(:include, AtLinksafe::ControllerExtensions)
ApplicationHelper.send(:include, AtLinksafe::HelperExtensions)
ActionView::Base.send(:include, AtLinksafe::HelperExtensions)
