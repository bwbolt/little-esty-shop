class Holiday
  attr_reader :name, :date

  def initialize(info)
    @name = info[:name]
    @date = info[:date]
  end
end
