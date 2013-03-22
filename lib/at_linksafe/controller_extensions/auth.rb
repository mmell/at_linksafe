module AtLinksafe
  module ControllerExtensions
    module Auth

      def current_url_for
        url_for( :only_path => false ) # request.env['REQUEST_URI'] retains the query args but no host. url_for drops the args that are not in the current route
      end

      def redirect_to_default
        root_url( :only_path => false )
      end

      def referer
        request.env['HTTP_REFERER'].blank? ? redirect_to_default : request.env['HTTP_REFERER']
      end

      def redirect_to_save( url_string = nil )
        session[:redirect_to] = (url_string or referer)
      end

      def redirect_to_session( default = referer )
        to = ( session[:redirect_to] || default )
        redirect_to( to ) if to and to != url_for
        session[:redirect_to] = nil
      end

      def redirect_to_get
        session[:redirect_to]
      end

      def session_logout
        session[:login] = nil
      end

      def session_login(iname = nil, cid = nil, user_id = nil)
        session[:login] = SessionLogin.new(iname, cid, user_id) unless iname.blank? and cid.blank?
      end

    end
  end
end
