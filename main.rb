require 'tty-font'
require 'pastel'
require 'tty-prompt'
require_relative './classes/PropertyList'
require_relative './classes/UserInterface'
require 'json'

font = TTY::Font.new(:doom)
pastel = Pastel.new
puts pastel.blue(font.write("Rent Easy", letter_spacing: 1))

begin
user = UserInterface.new
user.main_menu
rescue JSON::ParserError
    File.open('./data/properties.json', 'w') do |f|
        f.write([])
    end
    retry
end
