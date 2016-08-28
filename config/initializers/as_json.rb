class ActiveSupport::TimeWithZone
    def as_json(options = {})
        strftime('%y/%m/%d %H:%M')
    end
end
