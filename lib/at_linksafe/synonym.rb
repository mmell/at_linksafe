module AtLinksafe

  class Synonym

    Regexps = [
      Regexp.new('\Ahttps?://'),
      Regexp.new('\Axri://'),
      Regexp.new('\Axri.net/'),
      Regexp.new('\Aopenid.xri.net/'),
      Regexp.new('/\z')
    ]

    def self.normalize(name = '')
      return '' if name.nil? or name == ''
      
      @@proxy_regexp ||= Regexp.new('\A' + ProxyResolver.to_s + '/?') # ProxyResolver is normally defined in the rails app and not available at class instantiation

      # use the OpenID::Util.normalize ?
      s = name.sub(@@proxy_regexp, '')
      Regexps.each { |e| s.sub!(e, '') }
      s
    end
  end
  
end
