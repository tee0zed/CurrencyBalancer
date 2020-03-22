# encoding: utf-8

def to_string(results)
  to_buy = "Вам надо купить:"
  to_sell = "Вам надо продать:"

  if results.size < 2
    puts "Портфели сбалансированы, редкая удача."
    return
  end

  results.each do |key, value|

    if value < 0
      to_buy << "\n #{key}: #{value.abs.round(2)}"
    else
      to_sell << "\n #{key}: #{value.abs.round(2)}"
    end
  end
  puts to_sell << "\n"
  puts to_buy << "\n"
end

def get_result(diff, rates)
  results = Hash.new
  diff.keys.each {|key| results[key] = diff[key] / rates[key]}
  results
end

def get_rub_values(rates, amounts)
  rub_values = Hash.new
  amounts.keys.each {|key| rub_values[key] = rates[key] * amounts[key]}
  rub_values
end

def get_diff(rub_values)
  mean = rub_values.values.sum / rub_values.size
  diff = rub_values.transform_values {|value| value -= mean}
  diff.reject {|key, value| value.abs < 2}
end

def get_sym
  currency = gets.strip

  until currency =~ /^[a-z]{3}$/
    puts "Введите например \'usd\'"
    currency = gets.strip
  end
  currency.to_sym
end

def get_amount
  input = gets.to_f

  while input == 0
    puts "Введите только число в формате 0.00"
    input = gets.to_f
  end
  input
end

rates = Hash.new

amounts = Hash.new

input = 1

puts "Будьте готовы ввести актуальные курсы ваших валют и размеры валютных портфелей."

while input == 1
  puts
  puts "Введите 3-х значное обозначение вашей валюты на латиннице"

  sym = get_sym

  puts
  puts "Сколько её у вас?"

  amount = get_amount

  puts
  puts "Введите её стоимость в рублях."

  rate = get_amount

  rates.store(sym, rate)
  amounts.store(sym, amount)

  puts "Если вы закончили нажмите enter, чтобы ввести еще - 1."
  input = gets.to_i
end

if rates.size == 1
  puts "Нужно ввести больше 1 валюты."
  sleep 1
  exit
end

rub_values = get_rub_values(rates, amounts)

diff = get_diff(rub_values)

result = get_result(diff, rates)

to_string(result)