module AtLinksafe
  # self.get will return and AtLinksafe::Iname or AtLinksafe::Inumber
  class Xri
    def self.get(parent, segment = nil)
      if AtLinksafe::Iname.is_inumber?(parent)
        AtLinksafe::Inumber.new(parent, segment)
      else
        AtLinksafe::Iname.new(parent, segment)
      end
    end
  end
end
