
class CurrencyDiplomat
  attr_reader :amount, :rate, :sym

  def initialize(amount, rate, sym)
    @amount = amount
    @rate = rate
    @sym = sym
  end
end