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

# property_list = PropertyList.new
# property_list.create_property('house', '$330', 'vacant', '5', 'hall street', 'milton', 'james', 'lee')
# property_list.create_property('unit', '$430', 'vacant', '10', 'milton street', 'toowong', 'liang', 'wei')
# prompt = TTY::Prompt.new
# choice = prompt.select("What property to update", property_list.property_options)
# File.write('./data/properties.json', JSON.pretty_generate(property_list))
# p property_list
