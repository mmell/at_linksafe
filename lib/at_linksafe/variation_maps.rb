module AtLinksafe

  class VariationMaps
    # VariationMaps registers spelling variants and a canonical @code for data like country names
    attr_reader :variation_maps
    def initialize()
      @variation_maps = []
    end
    def add(code, variations = [])
      @variation_maps << AtLinksafe::VariationMap.new(code, variations)
    end
    def find_by_code(s)
      @variation_maps.find { |e| e.code == s }
    end
    def find_by_variation(s)
      @variation_maps.find { |e| e.match?(s) }
    end
    alias_method :find, :find_by_variation
  end

  class VariationMap
    # a single variant, like state
    attr_reader :code
    def initialize(code, variations = [])
      @code = code
      @variations = []
      add_variations(*variations)
    end
    def add_variations(*variations)
      variations.each { |e| @variations << e.downcase }
    end
    alias_method :add, :add_variations
    def primary_variation
      @variations.first
    end
    def variations
      @variations
    end
    def match?(s)
      return false if s.nil?
      @code == s or @variations.include?(s.downcase)
    end
    def to_s
      @code
    end
  end

end
