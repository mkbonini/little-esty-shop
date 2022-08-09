class HolidaySearch
    def next_holidays
        @_holiday ||= service.get_holidays.map do |data|
            Holiday.new(data)
        end
    end

    def service
        HolidayService.new
    end
end