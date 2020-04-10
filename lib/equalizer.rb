
require 'open-uri'
require 'json'

class Equalizer
  attr_accessor :diplomats

  def self.get_currencies(diplomats = [])

    json = JSON.load(open('https://www.cbr-xml-daily.ru/daily_json.js'))

    input = 1
    while input == 1
      puts
      puts "Введите 3-х значное обозначение вашей валюты на латиннице"

      sym = get_sym
      puts
      puts "Сколько её у вас?"

      amount = get_amount


      rate = rate(sym, json)

      if rate.nil?
        puts
        puts "Введите её стоимость в рублях."
        rate = get_amount
      end

      diplomats.push CurrencyDiplomat.new(amount, rate, sym)

      puts "Если вы закончили нажмите enter, чтобы ввести еще - 1."
      input = gets.to_i
    end
    Equalizer.new(diplomats)
  end

  def initialize(diplomats)
    @diplomats = diplomats
  end

  def calculate
    diff = diff(rub_values)
    puts to_s(result(diff))
  end

  def self.get_amount
    input = gets.to_f
    while input == 0
      puts "Введите только число в формате 0.00"
      input = gets.to_f
    end
    input
  end

  def self.get_sym
    currency = gets.strip
    until currency =~ /^[a-z]{3}$/
      puts "Введите например \'usd\'"
      currency = gets.strip
    end
    currency.to_sym
  end

  def self.rate(sym, json)
    json["Valute"][sym.to_s.upcase]["Value"].round(2)
  end

  private

  def to_s (results)
    to_buy = "Вам надо купить:"
    to_sell = "Вам надо продать:"

    if results.size < 2
      return "Портфели сбалансированы, редкая удача."
    end

    results.each_with_index do |value, indx|
      if value < 0
        to_buy << "\n #{diplomats[indx].sym}: #{value.abs.round(2)}"
      else
        to_sell << "\n #{diplomats[indx].sym}: #{value.abs.round(2)}"
      end
    end
    to_sell << "\n"
    to_buy << "\n"
  end

  def result(diff)
    diff.map.with_index { |val, indx| val / diplomats[indx].rate }
  end

  def rub_values
    diplomats.map { |dipl| dipl.rate * dipl.amount }
  end

  def diff(rub_values)
    mean = rub_values.sum / diplomats.size
    diff = rub_values.map { |value| value - mean }
    diff.reject { |value| value.abs < 2 }
  end
end