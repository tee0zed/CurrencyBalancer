require 'equalizer'
require 'currency_diplomat'

describe Equalizer do
  diplomat = [CurrencyDiplomat.new(100, 65, :usd), CurrencyDiplomat.new(1000, 1, :rub)]
  session = Equalizer.new(diplomat)
  it 'count session.diplomat' do
    expect(session.diplomats.count).to eq 2
  end
end
