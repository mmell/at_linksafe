module AtLinksafe

  class Synonym
    def self.normalize(name)
      # use the OpenID::Util.normalize ?
      s = name.sub(/\A#{PROXY_RESOLVER}\/?/, '')
      s.sub!(/\Ahttps?:\/\//, '')
      s.sub!(/\Axri:\/\//, '')
      s.sub!(/\Axri\.net\//, '')
      s.sub!(/\Aopenid\.xri\.net\//, '')
      s.sub!(/\/\Z/, '')
      s
    end
  end
  
end
