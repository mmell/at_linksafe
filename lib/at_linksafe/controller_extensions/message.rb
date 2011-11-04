module AtLinksafe
  module ControllerExtensions
    module Message
      def errors_empty
        (!defined?(flash[:errors]) or flash[:errors].nil? or flash[:errors].size == 0) and \
        (!defined?(@errors_now) or @errors_now.nil? or @errors_now.size == 0)
      end
      def add_to_array( arr, val )
        klass = val.class.to_s
        case klass
        when 'Array'
          arr = arr + val 
        when 'String'
          arr << val unless val.nil? or val.empty?
        end
        arr
      end
      def errors_now( s_or_a )
        logger.debug(s_or_a.inspect)
        @errors_now ||= []
        @errors_now = add_to_array( @errors_now, s_or_a )
      end
      def alerts_now( s_or_a )
        logger.debug(s_or_a.inspect)
        @alerts_now ||= []
        @alerts_now = add_to_array( @alerts_now, s_or_a )
      end
      def notices_now( s_or_a )
        @notices_now ||= []
        @notices_now = add_to_array( @notices_now, s_or_a )
      end
      def errors( s_or_a )
        logger.debug(s_or_a.inspect)
        flash[:errors] ||= []
        flash[:errors] = add_to_array( flash[:errors], s_or_a )
      end
      def alerts( s_or_a )
        logger.debug(s_or_a.inspect)
        flash[:alerts] ||= []
        flash[:alerts] = add_to_array( flash[:alerts], s_or_a )
      end
      def notices( s_or_a )
        flash[:notices] ||= []
        flash[:notices] = add_to_array( flash[:notices], s_or_a )
      end

      def messages_empty_errors
        flash[:error] = nil
        flash[:errors] = nil
        @errors_now = []
      end
      def messages_empty_alerts
        flash[:alerts] = nil
        @alerts_now = []
      end
      def messages_empty_notices
        flash[:notice] = nil
        flash[:notices] = nil
        @notice_now = []
        flash[:message] = nil
        flash[:messages] = nil
      end
    end
  end
end
