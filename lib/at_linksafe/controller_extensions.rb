require 'at_linksafe/controller_extensions/auth.rb'
require 'at_linksafe/controller_extensions/message.rb'

module AtLinksafe
  module ControllerExtensions
    include AtLinksafe::ControllerExtensions::Auth
    include AtLinksafe::ControllerExtensions::Message

    def loggedin_display
      get_session_login.iname if logged_in?
    end
    alias_method :displayname_for_user, :loggedin_display

    def logged_in_as?(xri)
      return false unless logged_in?
      get_session_login.cid == resolve_canonical_id(xri)
    end

    def logged_in?
      !get_session_login.blank?
    end

    def get_session_login
      begin
        session[:login]
      rescue # ActionController::SessionRestoreError
        session_logout
        return nil
      end
     end
    alias_method :login, :get_session_login # controller actions named :login squash this login

    def resolve_canonical_id(xri)
      return xri if AtLinksafe::Iname.is_inumber?(xri)
      AtLinksafe::Resolver::Resolve.new(xri).canonical_id
    end

  end
end
