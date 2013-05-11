module ProxyResolver
  def self.to_s
    'http://proxy.example.com'
  end
end

require 'test/unit'
require 'at_linksafe'
require 'mocha/setup'
