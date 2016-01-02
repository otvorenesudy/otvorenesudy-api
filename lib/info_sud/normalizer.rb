module InfoSud
  class Normalizer
    using UnicodeString

    def self.normalize_phone(value)
      value = value.gsub(/(\d+\s*)+/) { |part|
        part.gsub!(/\s/, '')

        case part.size
        when  7 then "#{part[0   ]} #{part[1..3]} #{part[4..6]} "
        when  8 then "#{part[0..1]} #{part[2..4]} #{part[5..7]} "
        when 10 then "#{part[0..3]} #{part[4..6]} #{part[7..9]} "
        else
          part + ' '
        end
      }

      value.gsub!(/\s*\/+\s*/, '/')
      value.gsub!(/\s*\-+\s*/, ' - ')
      value.gsub!(/\s*([\,\;])+\s*/, ', ')

      value.gsub!(/fax\s*\.\s*/i, ' fax ')
      value.gsub!(/kl(apka)?\s*\.\s*/i, ' klapka ')

      value.gsub!(/\s*@\s*/, '@')

      value.strip.squeeze(' ')
    end

    def self.normalize_hours(value)
      value = value.gsub(/[a-z]+/i, '')

      times = value.split(/\s*\-\s*|\,\s*|\;\s*|\s+/).map do |time|
        hour, minute = time.split(/\:/)
        "#{'%d' % hour.to_i}:#{'%02d' % minute.to_i}"
      end

      times.each_slice(2).map { |interval| "#{interval.first} - #{interval.last}" }.join ', '
    end
  end
end
