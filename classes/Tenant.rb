class Tenant
    attr_accessor :first_name, :last_name
    def initialize(first_name, last_name)
        @first_name = first_name
        @last_name = last_name
    end

    def update_tenant(first_name, last_name)
        @first_name = first_name
        @last_name = last_name
    end
end