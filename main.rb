# encoding: utf-8

require_relative 'lib/equalizer'
require_relative 'lib/currency_diplomat'

puts "Будьте готовы ввести актуальные курсы ваших валют и размеры валютных портфелей."

session = Equalizer.get_currencies

if session.diplomats.count <= 1
  puts "Нужно ввести больше 1 валюты."
  sleep 1
  exit
end

session.calculate