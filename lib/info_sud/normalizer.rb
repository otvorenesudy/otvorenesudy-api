module InfoSud
  class Normalizer
    using UnicodeString

    # TODO implement specs for checking legacy compatibility

    def self.normalize_court_name(value)
      value.gsub!(/[\-\,]/, '')

      value.gsub!(/1/, ' I ')
      value.gsub!(/2/, ' II ')
      value.gsub!(/3/, ' III ')
      value.gsub!(/4/, ' IV ')
      value.gsub!(/5/, ' V ')

      value.gsub!(/lll|III/i, ' III ')
      value.gsub!(/okolie/i, ' okolie ')

      value.gsub!(/Kraj.\s*súd/, 'Krajský súd')

      value.gsub!(/B\.?\s*Bystrica/, 'Banská Bystrica')
      value.gsub!(/D\.\s*Kubín/, 'Dolný Kubín')

      value = " #{value} "

      value.gsub!(/\s+v\s+BA/, ' Bratislava')
      value.gsub!(/\s+v\s+ZA/, ' Žilina')

      value.gsub!(/\s+v\s+Bansk(á|ej)\s+Bystric(a|i)/i, ' Banská Bystrica')
      value.gsub!(/\s+v\s+Bratislav(a|e)/i, ' Bratislava')
      value.gsub!(/\s+v\s+Košic(a|iach)/i, ' Košice')
      value.gsub!(/\s+v\s+Nitr(a|e)/i, ' Nitra')
      value.gsub!(/\s+v\s+Prešove?/i, ' Prešov')
      value.gsub!(/\s+v\s+Trenčíne?/i, ' Trenčín')
      value.gsub!(/\s+v\s+Trnav(a|e)/i, ' Trnava')
      value.gsub!(/\s+v\s+Žilin(a|e)/i, ' Žilina')

      value.squeeze!(' ')
      value.strip!

      value.gsub!(/n\/B/i, 'nad Bebravou')
      value.gsub!(/n\/V/i, 'nad Váhom')
      value.gsub!(/n\/T|n\.T\./i, 'nad Topľou')
      value.gsub!(/n\/H/i, 'nad Hronom')

      value.gsub!(/Najvyšší\s*súd\s*(SR|Slovenskej*\srepubliky)?/i, 'Najvyšší súd Slovenskej republiky')
      value.gsub!(/ŠTS(\s*v\s*Pezinku)?/i, 'Špecializovaný trestný súd')
      value.gsub!(/MS\s*SR/, 'Ministerstvo spravodlivosti Slovenskej republiky')
      value.gsub!(/NS\s*SR/, 'Najvyšší súd Slovenskej republiky')

      value.gsub!(/\./, '')

      value.split(/\s+/).map { |word|
        case word
        when 'KS' then 'Krajský súd'
        when 'OS' then 'Okresný súd'
        when 'BA' then 'Bratislava'
        when 'KE' then 'Košice'
        when 'ZA' then 'Žilina'
        when 'BB' then 'Banská Bystrica'

        when /\A(I|V)+\z/
          word
        when /\ASR\z/i
          'Slovenskej republiky'
        when /\A(a|v|nad|pre|súd|okolie|trestný|republiky)\z/i
          word.downcase
        else
          word.titlecase
        end
      }.join ' '
    end

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

    def self.normalize_person_name(value, options = {})
      partition_person_name(value, options)[:value]
    end

    def partition_person_name(value, options = {})
      copy  = value.clone
      value = value

      prefixes  = []
      suffixes  = []
      additions = []
      uppercase = []
      mixedcase = []
      flags     = []

      _, representantive = *value.match(/((\,\s+)?hovorca)?\s+KS\s+(v\s+)?(?<municipality>.+)\z/i)

      unless representantive.nil?
        flags << :representantive
        value.sub!(/((\,\s+)?hovorca\s+)?KS\s+(v\s+)?.+\z/i, '')
      end

      value.strip!
      value.gsub!(/[\,\;\(\)]/, '')
      value.gsub!(/(\.+\s*)+/, '. ')
      value.gsub!(/\s*\-\s*/, '-')

      value.split(/\s+/).each do |part|
        key = person_name_map_key(part)

        if prefix = person_name_prefix_map[key]
          prefixes << prefix
        elsif suffix = person_name_suffix_map[key]
          suffixes << suffix
        else
          part = part.strip

          if part =~ /\./
            if part =~ /rod\./i
              flags << :born
            elsif part =~ /(ml|st)\./
              flags << :relative
              additions << part
            end
          else
            if part.upcase == part
              uppercase << part.split(/\-/).map(&:titlecase).join(' - ')
            else
              mixedcase << part.split(/\-/).map(&:titlecase).join(' - ')
            end
          end
        end
      end

      prefixes.uniq!
      suffixes.uniq!

      names = mixedcase + uppercase

      if options[:reverse]
        if names.size >= 3
          names[0], names[1..-1] = names[-1], names[0..-2]
        else
          names.reverse!
        end
      end

      if flags.include? :born
        names << names.last
        names[-2] = 'rod.'
      end

      value = nil
      value = names.join(' ')                   unless names.empty?
      value = prefixes.join(' ') + ' ' + value  unless prefixes.empty?
      value = value + ' ' + additions.join(' ') unless additions.empty?
      value = value + ', ' + suffixes.join(' ') unless suffixes.empty?

      if flags.include? :representantive
        municipality ||= 'Trenčíne' unless representantive.match(/(TN|Trenčín(e)?)/).nil?
        municipality ||= 'Trnave'   unless representantive.match(/(TT|Trnav(a|e){1})/).nil?

        role  = "Hovorca krajského súdu v #{municipality}"
        value = value.blank? ? role : "#{value}, #{role.downcase_first}"
      end

      {
        unprocessed: copy.strip,
        value:       value,
        prefix:      prefixes.empty? ? nil : prefixes.join(' '),
        first:       names.count >= 2 ? names.first.to_s : nil,
        middle:      names.count >= 3 ? names[1..-2].join(' ') : nil,
        last:        names.last.to_s,
        suffix:      suffixes.empty? ? nil : suffixes.join(' '),
        addition:    additions.empty? ? nil : additions.join(' '),
        flags:       flags,
        role:        role
      }
    end

    def person_name_prefix_map
      @person_name_prefix_map ||= person_name_map_using ['abs. v. š.',
        'akad.', 'akad. arch.', 'akad. mal.', 'akad. soch.', 'arch.', 'Bc.',
        'Bc. arch.', 'BcA.', 'B.Ed.', 'B.Sc.', 'Bw. (VWA)', 'doc.', 'Dr.',
        'Dr hab.', 'Dr inž.', 'Dr. jur.', 'Dr.h.c.', 'Dr.ir.', 'Dr.phil.',
        'Eng.', 'ICDr.', 'Ing.', 'Ing. arch.', 'JUC.', 'JUDr.', 'Kfm.',
        'Kfm. (FH)', 'Lic.', 'Mag', 'Mag.', 'Mag. (FH)', 'Mag. iur',
        'Magistra Artium', 'Mag.rer.nat.', 'MDDr.', 'MgA.', 'Mgr.',
        'Mgr. art.', 'mgr inž.', 'Mgr. phil.', 'MMag.', 'Mr.sc.', 'MSDr.',
        'MUc.', 'MUDr.', 'MVc.', 'MVDr.', 'PaedDr.', 'PharmDr.', 'PhDr.',
        'PhMr.', 'prof.', 'prof. mpx. h.c.', 'prof.h.c.', 'RCDr.', 'RNDr.',
        'RSDr.', 'ThDr.', 'ThLic.']
    end

    def person_name_suffix_map
      @person_name_suffix_map ||= person_name_map_using ['ArtD.', 'BA',
      'BA (Hons)', 'BBA', 'BBS', 'BBus', 'BBus (Hons)', 'BS', 'BSBA', 'BSc',
      'Cert Mgmt', 'CPA', 'CSc.', 'DDr.', 'Dipl. Ing.', 'Dipl. Kfm.',
      'Dipl.ECEIM', 'DiS.', 'DiS.art', 'Dr.', 'Dr.h.c.', 'DrSc.', 'DSc.',
      'EMBA', 'E.M.M.', 'Eqm.', 'Litt.D.', 'LL.A.', 'LL.B.', 'LL.M.',
      'M.A.', 'MAE', 'MAS', 'MBA', 'MBSc', 'M.C.L.', 'MEng.', 'MIM', 'MMBA',
      'MPH', 'M.Phil.', 'MS', 'MSc', 'M.S.Ed.', 'Ph.D.', 'PhD.',
      'prom. biol.', 'prom. ek.', 'prom. fil.', 'prom. filol.',
      'prom. fyz.', 'prom. geog.', 'prom. geol.', 'prom. hist.',
      'prom. chem.', 'prom. knih.', 'prom. logop.', 'prom. mat.',
      'prom. nov.', 'prom. ped.', 'prom. pharm.', 'prom. práv.',
      'prom. psych.', 'prom. vet.', 'prom. zub.', 'ThD.']
    end

    def person_name_map_using(values)
      values.inject({}) { |m, v| m[person_name_map_key(v)] = v; m }
    end

    def person_name_map_key(value)
      value.downcase.gsub(/[\s\.\,\;\-\(\)]/, '').to_sym
    end
  end
end
