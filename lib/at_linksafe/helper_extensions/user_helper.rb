module AtLinksafe
  module HelperExtensions
    module UserHelper
      def loggedin_display
        controller.loggedin_display
      end
      alias_method :displayname_for_user, :loggedin_display

      def logged_in?
        controller.logged_in?
      end

      def login
        controller.get_session_login
      end
      alias :get_session_login :login
    end
  end
end
