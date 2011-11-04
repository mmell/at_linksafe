module AtLinksafe
  
  class Inumber
    
    Sep = '!'
  
    attr_accessor :parent, :segment, :errors
    def initialize(parent, segment = nil)
      @errors = []
      @parent = parent.strip
      @errors << "The base part of the inumber appears to be invalid." and return false unless AtLinksafe::Inumber.valid?(@parent) or GCS.include?(@parent)
      if segment.blank?
        parts = Inumber.split(@parent)
        if parts.size > 1 # @parent is the minimum
          @segment = parts.pop
          @parent = Inumber.join( *parts )
        else
          @segment = '' # @parent is unchanged
        end
      else
        @segment = segment.strip
        @errors << "The segment final segment appears to be invalid." and return false unless AtLinksafe::Inumber.valid_segment?(segment)
      end
    end
  
    def sep
      Inumber::Sep
    end
    
    def compose
      Inumber.join( @parent, @segment )
    end

    def to_s
      compose
    end

    def ok?
      @errors.empty?
    end

    def valid?
      Inumber.valid?(self.compose)
    end

    def segments
      arr = Inumber.split(self.compose)
      gcs = arr.shift
      arr[0] = gcs + Inumber::Sep + arr[0]
      arr
    end
    
    def self.valid_segment?(s)
      s.match(/\A[\.1234567890ABCDEF]{4,}\z/)
    end

    def self.valid?(s)
      s.match(/\A(xri:\/\/)?[@=](![\.1234567890ABCDEF]{4,})+\z/)
    end

    def self.join( *parts )
      parts.join(Inumber::Sep)
    end

    def self.split( composed_inumber )
      composed_inumber.strip.split(/\!/)
    end

    def self.is_inumber?(s)
      s =~ /^(xri:\/\/)?[@=]!/
    end

  end

end
