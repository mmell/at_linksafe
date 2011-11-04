module AtLinksafe
  module Email
    EmailRegExp = /^[^[:space:]@]+@(([[:alnum:]\-_\+\>])+\.)+[[:alpha:]]{2,6}$/

    def self.valid?( email )  
      m = EmailRegExp.match( email )
      not m.nil?
    end
  end
end
