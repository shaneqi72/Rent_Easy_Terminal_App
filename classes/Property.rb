class Property

    attr_accessor :type, :address, :rent, :status

    def initialize(type, rent, status= "vacant")
        @type = type
        @rent = rent
        @status = status
        @address = {}
    end

    def update_rent(weekly_rent)
        @rent = weekly_rent
    end

    def update_status(status)
        @status = status
    end

    def update_address(street_number, street_name, suburb)
        @address = {
            street_number: street_number,
            street_name: street_name,
            suburb: suburb
        }
    end
end

