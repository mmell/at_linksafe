# FIXME This comes from the ootao xdi lib. don't duplicate
#   the IDP uses this lib
require 'net/https'
require 'uri'
require 'rexml/document'
require 'rexml/xpath'
#require 'at_linksafe/xdi_status.rb'

module AtLinksafe
module Resolver
#  PROXY_RESOLVER = 'http://beta.xri.net/'
  class Resolve
    attr_reader :xrds, :error_msg, :query, :response
    DEBUG = true
    TYPE_XRDS = "application/xrds%2Bxml"
    TYPE_XRD = "application/xrd%2Bxml"

    def initialize( authority, sepType = nil, sepMediaType = nil, trustType = nil, 
        sepSelect = true, followRefs = true , contentType = TYPE_XRD 
        )
      resolve( authority, sepType, sepMediaType, trustType, sepSelect, followRefs , contentType)
    end
    def error(s)
      @error = true
      @error_msg = s
      false
    end
    def valid?
      !@error
    end
    def canonical_id
      return nil if @error
      xpath_first_text( @response, "//XRD[last()]/CanonicalID" ) #[@priority<=10]
    end
    def canonical_ids
      return [nil] if @error
      map = []
      REXML::XPath.each(@response, '//XRD/CanonicalID') { |e| map << e.text.strip }
      map
    end

    def proxy_endpoint(endpoint = nil)
      endpoint or PROXY_RESOLVER or 'http://xri.net/' 
    end
    def resolveViaProxy( authority, sepType, sepMediaType, trustType = nil, 
        sepSelect = true, followRefs = true , contentType = TYPE_XRD 
        ) 
      amp_args = []
      amp_args << ("_xrd_t=" + sepType) if sepType
      amp_args << ("_xrd_m=" + sepMediaType) if sepMediaType
      amp_args << ("_xrd_r=" + contentType) if contentType
      colon_args = [amp_args.join('&')]
      colon_args << "trust=#{trustType}" if trustType
      colon_args << "sep=#{sepSelect and sepType ? 'true' : 'false'}"
      colon_args << "ref=#{followRefs ? 'true' : 'false'}"
      @query = "#{proxy_endpoint}#{authority}?#{colon_args.join(';')}"
      begin
        @response = get_rexml( @query )
        check_status
      rescue StandardError => e
        @status_code = AtLinksafe::XdiStatus::CODE_320;
        error("XDIResponse/Status Resolution Failed: #{e} (#{@status_code}) #{@response.to_s}") 
      end
    end
    alias_method( :resolve, :resolveViaProxy )

    def check_status
      status = REXML::XPath.first(@response, '//XRD[last()]/Status') # XRDS isn't always returned
      @status_code = status.attributes.get_attribute('code').value.strip
      unless @status_code == AtLinksafe::XdiStatus::SUCCESS
        error("//XRD/Status #{status.text.strip} (#{@status_code}) #{@query}") 
      else
        true
      end
    end
    def xpath_first_text(itemdoc, xpath)
      begin
        REXML::XPath.first(itemdoc, xpath).text.strip
      rescue NoMethodError # catch when there is no data value for the xpath        
        nil
      end
    end
    def get_rexml(uri)
      resp = fetch_uri(uri)
      REXML::Document.new( resp.body.unpack("C*").pack("U*") )
    end
    def fetch_uri(uri_str, limit = 10)
      raise ArgumentError, 'HTTP redirects exceeded limit' if limit == 0
      uri = URI.parse( uri_str)
      uri.path = '/' if uri.path.empty?
      uri.path << ('?' + uri.query) unless uri.query.nil?
      site = Net::HTTP.new(uri.host, uri.port)
      site.read_timeout=(30) #secs to wait for response
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
        fetch_uri(response['location'], limit - 1)
      else
        response.error!
      end
    end

    def debug(*args)
      args.each {|e| p e } if DEBUG
    end

  end
  class ResolveXRD < Resolve
    def initialize( authority, sepType = nil, sepMediaType = nil, trustType = nil, 
        sepSelect = true, followRefs = true , contentType = TYPE_XRD
        )
      resolve( authority, sepType, sepMediaType, trustType, sepSelect, followRefs, contentType )
    end
    def check_status
      status = REXML::XPath.first(@response, '/XRD/Status[last()]')
      @status_code = status.attributes.get_attribute('code').value.strip
      unless @status_code == AtLinksafe::XdiStatus::SUCCESS
        error("/XRDS/XRD/Status #{status.text.strip} (#{@status_code})") 
      else
        true
      end
    end
    def canonical_id
      return nil if @error
      xpath_first_text( @response, "/XRD[last()]/CanonicalID" ) #[@priority<=10]
    end
    def canonical_ids
      return [nil] if @error
      [canonical_id]
    end

  end
  class ResolveAuthToXRDS < Resolve
    def initialize( authority, trustType = nil, followRefs = true) # Appendix E: operation #1.
      resolve( authority, nil, nil, trustType, false, followRefs, TYPE_XRDS) 
    end
  end
  class ResolveAuthToXRD < ResolveXRD
    def initialize( authority, trustType = nil, followRefs = true) # Appendix E: operation #2.
      resolve( authority, nil, nil, trustType, false, followRefs, TYPE_XRD) 
    end
  end
  class ResolveSEPToXRDS < Resolve
    def initialize( authority, sepType = nil, sepMediaType=nil, trustType = nil, followRefs = true) # Appendix E: operation #3.
      resolve( authority, sepType, sepMediaType, trustType, true, followRefs, TYPE_XRDS) 
    end
  end
  class ResolveSEPToXRD < ResolveXRD
    def initialize( authority, sepType = nil, sepMediaType = nil, trustType = nil, followRefs = true) # Appendix E: operation #4.
      resolve( authority, sepType, sepMediaType, trustType, true, followRefs, TYPE_XRD) 
    end
    def uri
      xpath_first_text( @response, "XRD/Service/URI" )
    end
  end
  class ResolveSEPToURIList < Resolve
    def initialize( authority, sepType = nil, sepMediaType = nil, trustType = nil, followRefs = true )# Appendix E: operation #5.
      #TODO: Invoke resolve and convert to URI list.
    end
  end

end
end