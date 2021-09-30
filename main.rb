require 'tty-font'
require 'pastel'
require 'tty-prompt'
require_relative './classes/PropertyList'
require_relative './classes/UserInterface'

font = TTY::Font.new(:doom)
pastel = Pastel.new
puts pastel.blue(font.write("Rent Easy", letter_spacing: 1))

user = UserInterface.new
user.main_menu
