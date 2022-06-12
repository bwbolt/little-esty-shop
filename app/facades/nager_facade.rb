class NagerFacade
  def self.create_holidays
    json = NagerService.get_holidays

    a = json.first(3).map do |info|
      Holiday.new(info)
    end
  end
end
