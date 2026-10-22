# frozen_string_literal: true

# TODO: assembled from legacy JusticeGovSk::Helper::Normalizer to retain compatibility for data refinements
# TODO add more specs and refactor legacy code and eventually remove

module Legacy
  module Normalizer
    extend self

    using Legacy::String

    COURT_NAME_NUMERALS = { '1' => ' I ', '2' => ' II ', '3' => ' III ', '4' => ' IV ', '5' => ' V ' }.freeze

    COURT_NAME_ABBREVIATIONS = {
      /lll|III/i => ' III ',
      /okolie/i => ' okolie ',
      /Kraj.\s*súd/ => 'Krajský súd',
      /B\.?\s*Bystrica/ => 'Banská Bystrica',
      /D\.\s*Kubín/ => 'Dolný Kubín'
    }.freeze

    # The seat after "v", as the sources write it, to the seat's name.
    COURT_NAME_SEATS = {
      /\s+v\s+BA/ => ' Bratislava',
      /\s+v\s+ZA/ => ' Žilina',
      /\s+v\s+Bansk(á|ej)\s+Bystric(a|i)/i => ' Banská Bystrica',
      /\s+v\s+Bratislav(a|e)/i => ' Bratislava',
      /\s+v\s+Košic(a|iach)/i => ' Košice',
      /\s+v\s+Nitr(a|e)/i => ' Nitra',
      /\s+v\s+Prešove?/i => ' Prešov',
      /\s+v\s+Trenčíne?/i => ' Trenčín',
      /\s+v\s+Trnav(a|e)/i => ' Trnava',
      /\s+v\s+Žilin(a|e)/i => ' Žilina'
    }.freeze

    COURT_NAMES = {
      %r{n/B}i => 'nad Bebravou',
      %r{n/V}i => 'nad Váhom',
      %r{n/T|n\.T\.}i => 'nad Topľou',
      %r{n/H}i => 'nad Hronom',
      /Najvyšší\s*súd\s*(SR|Slovenskej*\srepubliky)?/i => 'Najvyšší súd Slovenskej republiky',
      /ŠTS(\s*v\s*Pezinku)?/i => 'Špecializovaný trestný súd',
      /MS\s*SR/ => 'Ministerstvo spravodlivosti Slovenskej republiky',
      /NS\s*SR/ => 'Najvyšší súd Slovenskej republiky',
      /Najvyšší\ssprávny\ssúd\s*(SR|Slovenskej\srepubliky)?/i => 'Najvyšší správny súd',
      /\AOkresný súd Bratislava I\z/i => 'Mestský súd Bratislava I',
      /\AOkresný súd Bratislava II\z/i => 'Mestský súd Bratislava II',
      /\AOkresný súd Bratislava III\z/i => 'Mestský súd Bratislava III',
      /\AOkresný súd Bratislava IV\z/i => 'Mestský súd Bratislava IV',
      /\AOkresný súd Košice I\z/i => 'Mestský súd Košice'
    }.freeze

    COURT_NAME_WORDS = {
      'KS' => 'Krajský súd',
      'OS' => 'Okresný súd',
      'BA' => 'Bratislava',
      'KE' => 'Košice',
      'ZA' => 'Žilina',
      'BB' => 'Banská Bystrica'
    }.freeze

    # A court's spokesperson: "Mgr. Ján Novák, hovorca KS v Trenčíne".
    PERSON_NAME_REPRESENTATIVE = /(?:(?:,\s+)?hovorca)?\s+KS\s+(?:v\s+)?(?<municipality>.+)\z/i
    PERSON_NAME_ROLE = /(?:(?:,\s+)?hovorca\s+)?KS\s+(?:v\s+)?.+\z/i

    def normalize_court_name(value)
      value = replace_all(value.to_s.utf_8.gsub(/[-,]/, ''), COURT_NAME_NUMERALS.merge(COURT_NAME_ABBREVIATIONS))
      value = replace_all(" #{value} ", COURT_NAME_SEATS).squeeze(' ').strip
      value = replace_all(value, COURT_NAMES).delete('.')

      value.split(/\s+/).map { |word| normalize_court_name_word(word) }.join(' ')
    end

    def normalize_person_name(value, options = {})
      partition_person_name(value, options)[:value]
    end

    def partition_person_name(value, options = {})
      name = value.dup.utf_8
      municipality = name[PERSON_NAME_REPRESENTATIVE, :municipality]
      name.sub!(PERSON_NAME_ROLE, '') if municipality

      parts = person_name_parts(name)
      parts[:flags].unshift(:representantive) if municipality
      parts[:names] = order_names(parts[:names], reverse: options[:reverse], born: parts[:flags].include?(:born))
      parts[:role] = "Hovorca krajského súdu v #{representative_seat(municipality)}" if municipality

      person_name_hash(value, parts)
    end

    def normalize_zipcode(value)
      value = value.dup.ascii.strip.gsub(/\s+/, '')

      "#{value[0..2]} #{value[3..]}"
    end

    def normalize_street(value)
      value = value.dup.utf_8

      value.tr!(',', ' ')
      value.gsub!(/\.\s*/, '. ')
      value.gsub!(/sv\./i, 'sv.')
      value.gsub!(/slov\./i, 'slovenskej')

      value.gsub!(/Námestie/i) { |s| "#{s[0]}ám." }
      value.gsub!(/Ulica/i) { |s| "#{s[0]}l." }
      value.gsub!(/Číslo/i) { |s| "#{s[0]}." }

      value.strip!
      value.squeeze!(' ')

      value.to_s
    end

    def normalize_email(value)
      value.split(/,|;/).map(&:strip).join ', '
    end

    def normalize_phone(value)
      value = value.gsub(/(\d+\s*)+/) { |part| group_phone_digits(part.gsub(/\s/, '')) }

      value.gsub!(%r{\s*/+\s*}, '/')
      value.gsub!(/\s*-+\s*/, ' - ')
      value.gsub!(/\s*([,;])+\s*/, ', ')

      value.gsub!(/fax\s*\.\s*/i, ' fax ')
      value.gsub!(/kl(apka)?\s*\.\s*/i, ' klapka ')

      value.gsub!(/\s*@\s*/, '@')

      value.strip.squeeze(' ')
    end

    def normalize_hours(value)
      value = value.dup.ascii.gsub(/[a-z]+/i, '')

      times =
        value
        .split(/\s*-\s*|,\s*|;\s*|\s+/)
        .map do |time|
          hour, minute = time.split(':')
          "#{format('%d', hour.to_i)}:#{format('%02d', minute.to_i)}"
        end

      times.each_slice(2).map { |interval| "#{interval.first} - #{interval.last}" }.join ', '
    end

    private

    def replace_all(value, replacements)
      replacements.reduce(value) { |result, (pattern, replacement)| result.gsub(pattern, replacement) }
    end

    def normalize_court_name_word(word)
      COURT_NAME_WORDS.fetch(word) do
        case word
        when /\A(I|V)+\z/ then word
        when /\ASR\z/i then 'Slovenskej republiky'
        when /\A(a|v|nad|pre|súd|okolie|trestný|republiky)\z/i then word.downcase
        else word.capitalize_words
        end
      end
    end

    def person_name_parts(name)
      parts = { prefixes: [], suffixes: [], additions: [], uppercase: [], mixedcase: [], flags: [] }
      name = name.strip.gsub(/[,;()]/, '').gsub(/(\.+\s*)+/, '. ').gsub(/\s*-\s*/, '-')

      name.split(/\s+/).each { |part| add_person_name_part(part, parts) }

      {
        prefixes: parts[:prefixes].uniq,
        suffixes: parts[:suffixes].uniq,
        additions: parts[:additions],
        names: parts[:mixedcase] + parts[:uppercase],
        flags: parts[:flags]
      }
    end

    def add_person_name_part(part, parts)
      key = person_name_map_key(part)

      if (prefix = person_name_prefix_map[key])
        parts[:prefixes] << prefix
      elsif (suffix = person_name_suffix_map[key])
        parts[:suffixes] << suffix
      elsif part.include?('.')
        add_person_name_abbreviation(part, parts)
      else
        parts[part.upcase == part ? :uppercase : :mixedcase] << part.split('-').map(&:capitalize_words).join(' - ')
      end
    end

    def add_person_name_abbreviation(part, parts)
      if /rod\./i.match?(part)
        parts[:flags] << :born
      elsif /(ml|st)\./.match?(part)
        parts[:flags] << :relative
        parts[:additions] << part
      end
    end

    def order_names(names, reverse:, born:)
      names = names.size >= 3 ? names.rotate(-1) : names.reverse if reverse

      return names unless born

      names += [names.last]
      names[-2] = 'rod.'
      names
    end

    def representative_seat(municipality)
      if municipality.match?(/(TN|Trenčín(e)?)/)
        'Trenčíne'
      elsif municipality.match?(/(TT|Trnav(a|e){1})/)
        'Trnave'
      end
    end

    def person_name_hash(value, parts)
      names = parts[:names]

      {
        unprocessed: value.strip,
        value: join_person_name(parts).to_s,
        prefix: parts[:prefixes].presence&.join(' '),
        first: names.count >= 2 ? names.first.to_s : nil,
        middle: names.count >= 3 ? names[1..-2].join(' ') : nil,
        last: names.last.to_s,
        suffix: parts[:suffixes].presence&.join(' '),
        addition: parts[:additions].presence&.join(' '),
        flags: parts[:flags],
        role: parts[:role]
      }
    end

    def join_person_name(parts)
      value = parts[:names].join(' ').presence
      value = "#{parts[:prefixes].join(' ')} #{value}" if parts[:prefixes].any?
      value = "#{value} #{parts[:additions].join(' ')}" if parts[:additions].any?
      value = "#{value}, #{parts[:suffixes].join(' ')}" if parts[:suffixes].any?

      return value unless parts[:role]

      value.blank? ? parts[:role] : "#{value}, #{parts[:role].downcase_first}"
    end

    def person_name_prefix_map
      @person_name_prefix_map ||=
        person_name_map_using [
          'abs. v. š.',
          'akad.',
          'akad. arch.',
          'akad. mal.',
          'akad. soch.',
          'arch.',
          'Bc.',
          'Bc. arch.',
          'BcA.',
          'B.Ed.',
          'B.Sc.',
          'Bw. (VWA)',
          'doc.',
          'Dr.',
          'Dr hab.',
          'Dr inž.',
          'Dr. jur.',
          'Dr.h.c.',
          'Dr.ir.',
          'Dr.phil.',
          'Eng.',
          'ICDr.',
          'Ing.',
          'Ing. arch.',
          'JUC.',
          'JUDr.',
          'Kfm.',
          'Kfm. (FH)',
          'Lic.',
          'Mag',
          'Mag.',
          'Mag. (FH)',
          'Mag. iur',
          'Magistra Artium',
          'Mag.rer.nat.',
          'MDDr.',
          'MgA.',
          'Mgr.',
          'Mgr. art.',
          'mgr inž.',
          'Mgr. phil.',
          'MMag.',
          'Mr.sc.',
          'MSDr.',
          'MUc.',
          'MUDr.',
          'MVc.',
          'MVDr.',
          'PaedDr.',
          'PharmDr.',
          'PhDr.',
          'PhMr.',
          'prof.',
          'prof. mpx. h.c.',
          'prof.h.c.',
          'RCDr.',
          'RNDr.',
          'RSDr.',
          'ThDr.',
          'ThLic.'
        ]
    end

    def person_name_suffix_map
      @person_name_suffix_map ||=
        person_name_map_using [
          'ArtD.',
          'BA',
          'BA (Hons)',
          'BBA',
          'BBS',
          'BBus',
          'BBus (Hons)',
          'BS',
          'BSBA',
          'BSc',
          'Cert Mgmt',
          'CPA',
          'CSc.',
          'DDr.',
          'Dipl. Ing.',
          'Dipl. Kfm.',
          'Dipl.ECEIM',
          'DiS.',
          'DiS.art',
          'Dr.',
          'Dr.h.c.',
          'DrSc.',
          'DSc.',
          'EMBA',
          'E.M.M.',
          'Eqm.',
          'Litt.D.',
          'LL.A.',
          'LL.B.',
          'LL.M.',
          'M.A.',
          'MAE',
          'MAS',
          'MBA',
          'MBSc',
          'M.C.L.',
          'MEng.',
          'MIM',
          'MMBA',
          'MPH',
          'M.Phil.',
          'MS',
          'MSc',
          'M.S.Ed.',
          'Ph.D.',
          'PhD.',
          'prom. biol.',
          'prom. ek.',
          'prom. fil.',
          'prom. filol.',
          'prom. fyz.',
          'prom. geog.',
          'prom. geol.',
          'prom. hist.',
          'prom. chem.',
          'prom. knih.',
          'prom. logop.',
          'prom. mat.',
          'prom. nov.',
          'prom. ped.',
          'prom. pharm.',
          'prom. práv.',
          'prom. psych.',
          'prom. vet.',
          'prom. zub.',
          'ThD.'
        ]
    end

    def person_name_map_using(values)
      values.index_by do |v|
        person_name_map_key(v)
      end
    end

    def person_name_map_key(value)
      value.to_s.ascii.downcase.gsub(/[\s.,;\-()]/, '').to_sym
    end

    def group_phone_digits(digits)
      case digits.size
      when 7 then "#{digits[0]} #{digits[1..3]} #{digits[4..6]} "
      when 8 then "#{digits[0..1]} #{digits[2..4]} #{digits[5..7]} "
      when 10 then "#{digits[0..3]} #{digits[4..6]} #{digits[7..9]} "
      else "#{digits} "
      end
    end
  end
end
