module AtLinksafe
  class ProfileElement

    ValidatedBy = {
      :none => 'None',
      :linksafe => 'Linksafe',
      :llli => 'LLLI'
    }

    class MapName
      attr_reader :profile, :card, :protected
      def initialize(profile, card, protected = false)
        @profile, @card, @protected = profile, card, protected
      end
      
      def protected?
        self.protected
      end
    end

    Map = [
      MapName.new(:nickname, nil),
      MapName.new(:givenname, :given_name),
      MapName.new(:surname, :surname),
      MapName.new(:iname, :iname, true),
      MapName.new(:inumber, :inumber, true),
      MapName.new(:fullname, nil),
      MapName.new(:email, :email_address),
      MapName.new(:dob, :date_of_birth),
      MapName.new(:gender, :gender),
      MapName.new(:postcode, :postal_code),
      MapName.new(:country, :country),
      MapName.new(:language, nil),
      MapName.new(:timezone, nil),
      MapName.new(:ppid, :ppid, true),
      MapName.new(:street, :street_address),
      MapName.new(:stateprovince, :state_province),
      MapName.new(:city, :locality),
      MapName.new(:phone, :home_phone),
      MapName.new(:otherphone, :other_phone),
      MapName.new(:mobilephone, :mobile_phone),
      MapName.new(:webpage, :webpage),
    ]
  
    def ProfileElement.getClaims()
      Map.map { |e| e.card }.delete_if { |e| e.nil? }
    end
    
    def ProfileElement.getClaiments()
      ValidatedBy.values 
    end
    
    def ProfileElement.card_to_profile_element(sym)
      found = ProfileElement.find_by_card(sym)
      found ? found.profile : nil
    end
    
    def ProfileElement.profile_to_card_element(sym)
      found = ProfileElement.find_by_profile(sym)
      found ? found.card : nil
    end
    
    def ProfileElement.find_by_card(sym)
      Map.find { |e| e.card == sym.to_sym }
    end
    
    def ProfileElement.find_by_profile(sym)
      Map.find { |e| e.profile == sym.to_sym }
    end
  end

end
