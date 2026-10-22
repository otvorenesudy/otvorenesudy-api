# frozen_string_literal: true

require 'rails_helper'

# The normalizations of the old justice.gov.sk crawler, which the importers still use for court and person names,
# phones, office hours, e-mails and addresses. The examples pin what each returns today, branch by branch.
RSpec.describe Legacy::Normalizer do
  describe '.normalize_court_name' do
    it 'spells out abbreviations, numbers and municipalities in court names' do
      names = {
        'OS BA1' => 'Okresný súd Bratislava I',
        'KS v Košiciach' => 'Krajský súd Košice',
        'Okresný súd Bratislava 3' => 'Mestský súd Bratislava III',
        'Kraj. súd v Žiline' => 'Krajský súd Žilina',
        'OS B. Bystrica' => 'Okresný súd Banská Bystrica',
        'Okresný súd D. Kubín' => 'Okresný súd Dolný Kubín',
        'OS Nové Mesto n/V' => 'Okresný súd Nové Mesto nad Váhom',
        'Okresný súd Vranov n/T' => 'Okresný súd Vranov nad Topľou',
        'Okresný súd Vranov n.T.' => 'Okresný súd Vranov nad Topľou',
        'Okresný súd Žiar n/H' => 'Okresný súd Žiar nad Hronom',
        'Okresný súd Bánovce n/B' => 'Okresný súd Bánovce nad Bebravou',
        'NS SR' => 'Najvyšší súd Slovenskej republiky',
        'MS SR' => 'Ministerstvo Spravodlivosti Slovenskej republiky',
        'ŠTS v Pezinku' => 'Špecializovaný trestný súd',
        'ŠTS' => 'Špecializovaný trestný súd',
        'Okresný súd v BA' => 'Okresný súd Bratislava',
        'KS v ZA' => 'Krajský súd Žilina',
        'OS KE' => 'Okresný súd Košice',
        'OS BB' => 'Okresný súd Banská Bystrica',
        'Okresný súd Bratislava lll' => 'Mestský súd Bratislava III',
        'Okresný súd Bratislava 2' => 'Mestský súd Bratislava II',
        'Okresný súd Bratislava 4' => 'Mestský súd Bratislava IV',
        'Okresný súd Bratislava 5' => 'Okresný súd Bratislava V'
      }

      expect(names.keys.index_with { |name| described_class.normalize_court_name(name) }).to eq(names)
    end

    it 'keeps the names of courts the sources already spell out, without the "v" before the seat' do
      names = {
        'Mestský súd Bratislava I' => 'Mestský súd Bratislava I',
        'Správny súd v Banskej Bystrici' => 'Správny súd Banská Bystrica',
        'Okresný súd Lučenec' => 'Okresný súd Lučenec',
        'Krajský súd v Banskej Bystrici' => 'Krajský súd Banská Bystrica',
        'Najvyšší súd Slovenskej republiky' => 'Najvyšší súd Slovenskej republiky',
        'Špecializovaný trestný súd' => 'Špecializovaný trestný súd',
        'Okresný súd Nové Zámky' => 'Okresný súd Nové Zámky',
        'Najvyšší správny súd SR' => 'Najvyšší Správny súd',
        'Najvyšší správny súd Slovenskej republiky' => 'Najvyšší Správny súd',
        'Okresný súd Bratislava I' => 'Mestský súd Bratislava I',
        'Okresný súd Bratislava II' => 'Mestský súd Bratislava II',
        'Okresný súd Bratislava III' => 'Mestský súd Bratislava III',
        'Okresný súd Bratislava IV' => 'Mestský súd Bratislava IV',
        'Okresný súd Košice I' => 'Mestský súd Košice',
        'Krajský súd v Trnave' => 'Krajský súd Trnava',
        'Krajský súd v Prešove' => 'Krajský súd Prešov',
        'Okresný súd Košice - okolie' => 'Okresný súd Košice okolie',
        'Krajský súd v Trenčíne' => 'Krajský súd Trenčín',
        'Krajský súd v Nitre' => 'Krajský súd Nitra',
        'Krajský súd v Bratislave' => 'Krajský súd Bratislava',
        'Najvyšší súd SR' => 'Najvyšší súd Slovenskej republiky',
        'Krajský súd v Žiline' => 'Krajský súd Žilina',
        'OKRESNÝ SÚD PREŠOV' => 'Okresný súd Prešov',
        'Okresný súd Dunajská Streda' => 'Okresný súd Dunajská Streda',
        'Krajský súd pre ZA' => 'Krajský súd pre Žilina'
      }

      expect(names.keys.index_with { |name| described_class.normalize_court_name(name) }).to eq(names)
    end

    it 'normalizes nothing to an empty name' do
      expect([nil, ''].map { |name| described_class.normalize_court_name(name) }).to eq(['', ''])
    end
  end

  describe '.partition_person_name' do
    def partitions(names, **)
      names.index_with do |name|
        described_class.partition_person_name(name, **).reject do |key, value|
          value.nil? || value == [] || key == :unprocessed
        end
      end
    end

    it 'splits titles, names and suffixes, capitalizing names written in capitals' do
      names = [
        'JUDr. Peter Novák, PhD.',
        'NOVÁK Ján JUDr.',
        'prof. JUDr. Ján Svák, DrSc.',
        'JUDr. René MILTÁK',
        'JUDr. Erika NÉMETHOVÁ STIFFELOVÁ, LL.M.',
        'Mgr. Denisa Slivová',
        'JUDr. Alena ADAMCOVÁ',
        'JUDr.,Mgr. Peter Pan (PhD.)',
        'doc. JUDr. Mária Nová, CSc.',
        'Ing. Mgr. art. Peter Pan',
        'Peter'
      ]
      expected = {
        'JUDr. Peter Novák, PhD.' => {
          value: 'JUDr. Peter Novák, PhD.', prefix: 'JUDr.', first: 'Peter', last: 'Novák', suffix: 'PhD.'
        },
        'NOVÁK Ján JUDr.' => { value: 'JUDr. Ján Novák', prefix: 'JUDr.', first: 'Ján', last: 'Novák' },
        'prof. JUDr. Ján Svák, DrSc.' => {
          value: 'prof. JUDr. Ján Svák, DrSc.', prefix: 'prof. JUDr.', first: 'Ján', last: 'Svák', suffix: 'DrSc.'
        },
        'JUDr. René MILTÁK' => { value: 'JUDr. René Milták', prefix: 'JUDr.', first: 'René', last: 'Milták' },
        'JUDr. Erika NÉMETHOVÁ STIFFELOVÁ, LL.M.' => {
          value: 'JUDr. Erika Némethová Stiffelová',
          prefix: 'JUDr.',
          first: 'Erika',
          middle: 'Némethová',
          last: 'Stiffelová'
        },
        'Mgr. Denisa Slivová' => { value: 'Mgr. Denisa Slivová', prefix: 'Mgr.', first: 'Denisa', last: 'Slivová' },
        'JUDr. Alena ADAMCOVÁ' => { value: 'JUDr. Alena Adamcová', prefix: 'JUDr.', first: 'Alena', last: 'Adamcová' },
        'JUDr.,Mgr. Peter Pan (PhD.)' => {
          value: 'JUDr. Mgr. Peter Pan, PhD.', prefix: 'JUDr. Mgr.', first: 'Peter', last: 'Pan', suffix: 'PhD.'
        },
        'doc. JUDr. Mária Nová, CSc.' => {
          value: 'doc. JUDr. Mária Nová, CSc.', prefix: 'doc. JUDr.', first: 'Mária', last: 'Nová', suffix: 'CSc.'
        },
        'Ing. Mgr. art. Peter Pan' => {
          value: 'Ing. Mgr. Peter Pan', prefix: 'Ing. Mgr.', first: 'Peter', last: 'Pan'
        },
        'Peter' => { value: 'Peter', last: 'Peter' }
      }

      expect(partitions(names)).to eq(expected)
    end

    it 'joins double surnames with a spaced hyphen' do
      names = [
        'JUDr.  Peter  Novák-Kováč',
        'JUDr. Peter Pan - Novák'
      ]
      expected = {
        'JUDr.  Peter  Novák-Kováč' => {
          value: 'JUDr. Peter Novák - Kováč', prefix: 'JUDr.', first: 'Peter', last: 'Novák - Kováč'
        },
        'JUDr. Peter Pan - Novák' => {
          value: 'JUDr. Peter Pan - Novák', prefix: 'JUDr.', first: 'Peter', last: 'Pan - Novák'
        }
      }

      expect(partitions(names)).to eq(expected)
    end

    it 'keeps a junior or senior after the name and a maiden name after rod.' do
      names = [
        'Mgr. Ján Kováč ml.',
        'JUDr. Anna Malá st.',
        'JUDr. Jana Nováková rod. Kováčová'
      ]
      expected = {
        'Mgr. Ján Kováč ml.' => {
          value: 'Mgr. Ján Kováč ml.', prefix: 'Mgr.', first: 'Ján', last: 'Kováč', addition: 'ml.', flags: %i[relative]
        },
        'JUDr. Anna Malá st.' => {
          value: 'JUDr. Anna Malá st.',
          prefix: 'JUDr.',
          first: 'Anna',
          last: 'Malá',
          addition: 'st.',
          flags: %i[relative]
        },
        'JUDr. Jana Nováková rod. Kováčová' => {
          value: 'JUDr. Jana Nováková rod. Kováčová',
          prefix: 'JUDr.',
          first: 'Jana',
          middle: 'Nováková rod.',
          last: 'Kováčová',
          flags: %i[born]
        }
      }

      expect(partitions(names)).to eq(expected)
    end

    it 'turns a regional court spokesperson into a role' do
      names = [
        'Mgr. Peter Malý, hovorca KS v Trenčíne',
        'JUDr. Ivana Veľká, hovorca KS Trnava',
        'hovorca KS v Trnave'
      ]
      expected = {
        'Mgr. Peter Malý, hovorca KS v Trenčíne' => {
          value: 'Mgr. Peter Malý, hovorca krajského súdu v Trenčíne',
          prefix: 'Mgr.',
          first: 'Peter',
          last: 'Malý',
          flags: %i[representantive],
          role: 'Hovorca krajského súdu v Trenčíne'
        },
        'JUDr. Ivana Veľká, hovorca KS Trnava' => {
          value: 'JUDr. Ivana Veľká, hovorca krajského súdu v Trnave',
          prefix: 'JUDr.',
          first: 'Ivana',
          last: 'Veľká',
          flags: %i[representantive],
          role: 'Hovorca krajského súdu v Trnave'
        },
        'hovorca KS v Trnave' => {
          value: 'Hovorca krajského súdu v Trnave',
          last: '',
          flags: %i[representantive],
          role: 'Hovorca krajského súdu v Trnave'
        }
      }

      expect(partitions(names)).to eq(expected)
    end

    it 'reads names written surname first, the given name last, when told to reverse them' do
      names = [
        'Vandžurová Nehilová Beáta, JUDr.',
        'Pan Peter',
        'Malá Anna Mária Ingrid, Mgr.',
        'Novák Ján rod. Kováč'
      ]
      expected = {
        'Vandžurová Nehilová Beáta, JUDr.' => {
          value: 'JUDr. Beáta Vandžurová Nehilová',
          prefix: 'JUDr.',
          first: 'Beáta',
          middle: 'Vandžurová',
          last: 'Nehilová'
        },
        'Pan Peter' => { value: 'Peter Pan', first: 'Peter', last: 'Pan' },
        'Malá Anna Mária Ingrid, Mgr.' => {
          value: 'Mgr. Ingrid Malá Anna Mária', prefix: 'Mgr.', first: 'Ingrid', middle: 'Malá Anna', last: 'Mária'
        },
        'Novák Ján rod. Kováč' => {
          value: 'Kováč Novák rod. Ján', first: 'Kováč', middle: 'Novák rod.', last: 'Ján', flags: %i[born]
        }
      }

      expect(partitions(names, reverse: true)).to eq(expected)
    end

    it 'keeps the name as given' do
      expect(described_class.partition_person_name(' JUDr. Peter Novák ')[:unprocessed]).to eq('JUDr. Peter Novák')
    end
  end

  describe '.normalize_person_name' do
    it 'is the whole name of the partition' do
      expect(described_class.normalize_person_name('NOVÁK Ján JUDr.')).to eq('JUDr. Ján Novák')
    end
  end

  describe '.normalize_phone' do
    it 'groups the digits of phone numbers and spells out fax and extension' do
      values = {
        '02/88 811 180, fax 02/88 811 192' => '02/88 811 180, fax 02/88 811 192',
        '+421 2 1234567' => '+42121234567',
        '0905123456' => '0905 123 456',
        '02/50 118 340 kl. 123' => '02/50 118 340 klapka 123',
        '1234567' => '1 234 567',
        '12345678' => '12 345 678',
        '1234567890' => '1234 567 890',
        '123' => '123',
        'tel. 033/1234567 - 8' => 'tel. 033/1 234 567 - 8',
        '02 / 888 111 ; 02/888 112' => '02/888111, 02/888112',
        'fax. 02/1234567' => 'fax 02/1 234 567',
        '02/1234567 klapka.12' => '02/1 234 567 klapka 12',
        'info @ justice.sk' => 'info@justice.sk'
      }

      expect(values.keys.index_with { |value| described_class.normalize_phone(value) }).to eq(values)
    end
  end

  describe '.normalize_hours' do
    it 'writes office hours as intervals of hours and minutes' do
      values = {
        '8:00 - 15:30' => '8:00 - 15:30',
        '7.30-15.30 hod.' => '7:00 - 15:00, 0:00 - 0:00',
        '8:00 - 12:00, 13:00 - 15:00' => '8:00 - 12:00, 13:00 - 15:00',
        '7:30 - 15:30; 8:00 - 12:00' => '7:30 - 15:30, 8:00 - 12:00',
        '8 - 15' => '8:00 - 15:00'
      }

      expect(values.keys.index_with { |value| described_class.normalize_hours(value) }).to eq(values)
    end
  end

  describe '.normalize_email' do
    it 'separates several addresses with commas' do
      values = {
        'a@b.sk; c@d.sk' => 'a@b.sk, c@d.sk',
        'x@y.sk , z@w.sk' => 'x@y.sk, z@w.sk',
        'single@justice.sk' => 'single@justice.sk'
      }

      expect(values.keys.index_with { |value| described_class.normalize_email(value) }).to eq(values)
    end
  end

  describe '.normalize_street' do
    it 'abbreviates square, street and number, and spells out slov.' do
      values = {
        'Námestie SNP 12' => 'Nám. SNP 12',
        'Ulica Kozia 20' => 'Ul. Kozia 20',
        'Číslo 5' => 'Č. 5',
        'sv. Gorazda 2' => 'sv. Gorazda 2',
        'Slov. národného povstania 2' => 'slovenskej národného povstania 2',
        'Hlavná,12' => 'Hlavná 12',
        'Kozia  20' => 'Kozia 20',
        'Nám. slobody 1' => 'Nám. slobody 1'
      }

      expect(values.keys.index_with { |value| described_class.normalize_street(value) }).to eq(values)
    end
  end

  describe '.normalize_zipcode' do
    it 'writes postal codes as three and two digits' do
      values = {
        '81244' => '812 44',
        '812 44' => '812 44',
        '81 244' => '812 44',
        ' 812  44 ' => '812 44'
      }

      expect(values.keys.index_with { |value| described_class.normalize_zipcode(value) }).to eq(values)
    end
  end
end
