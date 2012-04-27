module AtLinksafe
  module HelperExtensions
    module MessageHelper

      def close_button_html
        "X (Close) " # you can override this method in a ActionView::Base.class_eval do...end
      end

      def messages(arr, html_class, opts = {} )
        return '' if arr.nil? or arr.empty?
        id = "#{html_class}_messages"
        s = "<div id='#{id}' class='#{html_class}'>"
        if opts[:fade_delay_secs]
          s << %Q{
<script>
function fade_#{id}() { jQuery('##{id}').fadeOut(2000); }
</script>
<a href='#' onclick='javascript:fade_#{id}();return false;'>#{close_button_html}</a>
}
        end

        if 1 == arr.size
          s << arr[0]
        else
          s << '<ul><li>' << arr.join('</li><li>') << '</li></ul>'
        end
        s << '</div>'
        s.html_safe
      end

      def errors
        arr = []
        arr += @errors_now unless @errors_now.nil?
        arr += flash[:errors] unless flash[:errors].nil?
        arr << flash[:error] unless flash[:error].nil?
        controller.messages_empty_errors
        messages(arr, 'error')
      end

      def alerts
        arr = []
        arr += flash[:alerts] unless flash[:alerts].nil?
        arr += @alerts_now unless @alerts_now.nil?
        controller.messages_empty_alerts
        messages(arr, 'alert')
      end

      def notices
        arr = []
        arr += flash[:notices] unless flash[:notices].nil?
        arr += @notices_now unless @notices_now.nil?
        arr << flash[:notice] unless flash[:notice].nil?
        arr << flash[:messages] unless flash[:messages].nil?
        arr << flash[:message] unless flash[:message].nil?
        controller.messages_empty_notices
        messages(arr, 'notice', :fade_delay_secs => 4)
      end
    end
  end
end
