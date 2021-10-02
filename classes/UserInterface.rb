require 'tty-font'
require 'pastel'
require 'tty-prompt'
require 'tty-table'
require_relative '../classes/PropertyList'
require_relative '../classes/UserInterface'
require 'json'
require 'rainbow'
require 'tty-pie'

class UserInterface
    attr_accessor :property_full_list, :property_list, :prompt

    def initialize
        @property_list = PropertyList.new
        @prompt = TTY::Prompt.new
    end
    
    def main_menu()
        user = @prompt.ask("What is your name?", required: true)
        puts Rainbow("Welcome #{user}").yellow

        main_menu_options = {
            "Print my property portfolio list": 1,
            "Create a new leasing property": 2,
            "Update existing property": 3,
            "Remove property": 4,
            "Print Summary": 5,
            "Exit": 6
        }

        print_menu_options = {
            "All Properties List": 1,
            "Vacant Properties List": 2,
            "Occupied Properties List": 3
        }

        menuLoop = true
        while menuLoop == true
             pastel = Pastel.new
            user_selection = @prompt.select("Please select one of the following action: ", main_menu_options)

            case user_selection
            when 1
                print_selection = @prompt.select("Which list do you want to print?", print_menu_options)
                case print_selection
                when 1
                   print_full_list(1) 
                when 2
                    print_full_list(2)
                when 3
                    print_full_list(3)
                end
            when 2
                begin
                create_new_property()
                rescue StreetNumberTypeError => e
                    puts e.street_number_error
                rescue RentTypeError => e
                    puts e.rent_error
                end
            when 3
                update_exist_property()
            when 4
                remove_property()
            when 5
                print_pie()
            when 6
               return menuLoop = false

            end
        end
    end

    def print_full_list(list_selection)
        headers  = ["Type", "Address", "Weekly rent", "Status", "Landlord", "Tenant"]
        full_list = []
        vacant_list = []
        occupied_list = []
        @property_list.array.each do |property|
            full_list.push([property.type, "#{property.address[:street_number]} #{property.address[:street_name]}, #{property.address[:suburb]}", property.rent, property.status, "#{property.landlord.first_name} #{property.landlord.last_name}", "#{property.tenant.first_name} #{property.tenant.last_name}"])

            vacant_list.push([property.type, "#{property.address[:street_number]} #{property.address[:street_name]}, #{property.address[:suburb]}", property.rent, property.status, "#{property.landlord.first_name} #{property.landlord.last_name}", "#{property.tenant.first_name} #{property.tenant.last_name}"]) if property.status == "Vacant"
            
            occupied_list.push([property.type, "#{property.address[:street_number]} #{property.address[:street_name]}, #{property.address[:suburb]}", property.rent, property.status, "#{property.landlord.first_name} #{property.landlord.last_name}", "#{property.tenant.first_name} #{property.tenant.last_name}"]) if property.status == "Occupied"
        end
        case list_selection
        when 1
            table = TTY::Table.new(headers, full_list)
            puts Rainbow("There is no property in list yet").yellow if full_list.length < 1
        when 2
            table = TTY::Table.new(headers, vacant_list)
            puts Rainbow("The vacant list is empty!").yellow if vacant_list.length < 1 
        when 3
            table = TTY::Table.new(headers, occupied_list)
            puts Rianbow("The occupied list is empty!").yellow if occupied_list.length < 1
        end
        puts table.render(:ascii)
    end

    def create_new_property
        type = @prompt.select("Choose the property type?", %w(Unit House Townhouse))
        street_number = @prompt.ask("What is the street number?", required: true) do |q|
            number_input_validate(q)
        end
        
        street_name = @prompt.ask("What is the street name?", required: true) do |q|
            letter_input_validate(q)
        end
        suburb = @prompt.ask("What is the suburb?", required: true) do |q|
            letter_input_validate(q)
        end

        weekly_rent = @prompt.ask("What is the weekly rent? (number only)", required: true) do |q|
            number_input_validate(q)
        end

        property_status = @prompt.select("Please select the current property status?", %w(Occupied Vacant))
        if property_status == 'Occupied'
            tenant_first_name = @prompt.ask("What is the current tenant first name?", required: true) do |q|
                letter_input_validate(q)
            end
            tenant_last_name = @prompt.ask("What is the current tenant last name?", required: true) do |q|
                letter_input_validate(q)
            end
        end
        landlord_firstname = @prompt.ask("What is the landlord firstname", required: true) do |q|
            letter_input_validate(q)
        end
        landlord_lastname = @prompt.ask("What is the landlord lastname", required: true) do |q|
            letter_input_validate(q)
        end

        @property_list.create_property(type, "$#{weekly_rent}", property_status, {street_number: street_number, street_name: street_name, suburb: suburb}, {first_name: landlord_firstname, last_name: landlord_lastname}, {first_name: tenant_first_name, last_name: tenant_last_name})
    end

    def update_exist_property
        return puts "Your portfolio is empty" if @property_list.array.length < 1 
        options = @property_list.property_options
        choice = @prompt.select("What property to update", options)
        fields = {
            "Weekly Rent": 1,
            "Tenant Name": 2,
            "Landlord Name": 3
        }
        field = @prompt.select("Which filed", fields)

        case field
            when 1
                updated_rent = @prompt.ask("what's new rent") do |q|
                    number_input_validate(q)
                end
                @property_list.array.each do |property|
                property.rent = updated_rent if property.property_id == choice
                end
            when 2 
                first_name = @prompt.ask("Tenant firstname?") do |q|
                    letter_input_validate(q)
                end
                last_name = @prompt.ask("Tenant lastname") do |q|
                    letter_input_validate(q)
                end
                @property_list.update_tenant(choice, first_name, last_name)
            when 3
                first_name = @prompt.ask("Landlord firstname?") do |q|
                    letter_input_validate(q)
                end
                last_name = @prompt.ask("Landlord lastname") do |q|
                    letter_input_validate(q)
                end
                @property_list.update_landlord(choice, first_name, last_name)
        end
    end

    def remove_property
        return puts "Your portfolio is empty" if @property_list.array.length < 1 
        options = @property_list.property_options
        choice = @prompt.select("Which property to be deleted", options)
        @property_list.remove_property(choice)
    end

    def print_pie
        data = [
            {name: "Occupancy", value: (@property_list.array.select {|property| property.status == 'Occupied'}).length, color: :bright_magenta, fill: '*'},
            {name: "Vacancy", value: (@property_list.array.select {|property| property.status == 'Vacant'}).length, color: :bright_cyan, fill: '+'},
        ]
        pie_chart = TTY::Pie.new(data: data, radius: 5)
        puts pie_chart

        occupied_property = @property_list.array.select {|p| p.status == "Occupied"}

        total_weekly_rent = 0
        occupied_property.each do |occupied_p|
        total_weekly_rent = occupied_p.rent[1..-1].to_i + total_weekly_rent
        end

        total_property_number = @property_list.array.length
        occupied_property_number = occupied_property.length
        vacant_property_number = total_property_number - occupied_property_number

        table = TTY::Table.new(["Rent Receivable p/w ","Management Fee p/w", "Occupied Properties", "Vacant Properties", "Total Properties"], [["$#{total_weekly_rent}", "$#{total_weekly_rent * 0.08}", "#{occupied_property_number}", "#{vacant_property_number}", "#{total_property_number}"]])
        puts table.render(:ascii)

    end

    def letter_input_validate(q)
        q.validate (/[a-zA-Z]/)
        q.messages[:valid?] = "Input must be letter only"
    end

    def number_input_validate(q)
        q.validate (/\d/)
        q.messages[:valid?] = "Input must be number only"
    end
end

