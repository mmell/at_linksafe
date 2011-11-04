require 'rails'
require 'at_linksafe'
require 'at_linksafe/helper_extensions'

module AtLinksafe
  class Engine < Rails::Engine
    engine_name :at_linksafe

    ActionController::Base.send(:include, AtLinksafe::ControllerExtensions)
    ActionView::Base.send(:include, AtLinksafe::HelperExtensions)

  end
end

