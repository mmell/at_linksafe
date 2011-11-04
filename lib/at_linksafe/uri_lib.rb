require 'net/https'
require 'uri'
require 'rexml/document'
require 'rexml/xpath'

module AtLinksafe
  module UriLib

    def self.get_rexml(uri)
      resp = fetch_uri(uri)
      REXML::Document.new( resp.body.unpack("C*").pack("U*") )
    end

    def self.post(uri_str, payload, headers = {}, use_ssl=true, opts = {})
      opts[:time_out] ||= 30
      uri_parsed = URI.parse(uri_str)
      connect = Net::HTTP.new( uri_parsed.host, uri_parsed.port )
      connect.read_timeout=( opts[:time_out] )
      connect.use_ssl = use_ssl
      connect.post(uri_parsed.path, payload, headers )
    end

    def self.post_rexml(host, port, path, headers, xml, use_ssl=true, opts = {})
      opts[:time_out] ||= 30
      connect = Net::HTTP.new( host, port )
      connect.read_timeout=( opts[:time_out] ) #secs to wait for response
      connect.use_ssl = use_ssl
      resp_xml = connect.post(path, xml, headers ).body.unpack("C*").pack("U*")
      REXML::Document.new( resp_xml )
    end

    def self.fetch_uri(uri_str, redirect_limit = 10, opts = {})
      opts[:time_out] ||= 30

      raise ArgumentError, 'HTTP redirects exceeded limit' if redirect_limit == 0
      uri = URI.parse( uri_str)
      uri.path = '/' if uri.path.empty?
      uri.path << ('?' + uri.query) unless uri.query.nil?
      site = Net::HTTP.new(uri.host, uri.port)
      site.read_timeout=( opts[:time_out] ) #secs to wait for response
      site.use_ssl = (uri.port == 443)? true : false
      begin
        response = site.get2(uri.path)
      rescue
        raise
      end
      redir = ['301', '302', '303', '305', '307']
      if response.code == '200'
        response
      elsif redir.include? response.code
        fetch_uri(response['location'], redirect_limit - 1, opts)
      else
        response.error!
      end
    end

    # wrap the xpath in a rescue
    def self.safe_xpath(itemdoc, xpath)
      begin
        REXML::XPath.first(itemdoc, xpath).text.strip
      rescue NoMethodError # catch when there is no data value for the xpath        
        nil
      end
    end
  end
end
