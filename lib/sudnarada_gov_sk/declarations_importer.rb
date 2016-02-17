module SudnaradaGovSk
  class DeclarationsImporter
    def self.import(path)
      xml = File.read(path)
      declarations = SudnaradaGovSk::DeclarationsParser.parse(xml)

      declarations.each do |attributes|
        SudnaradaGovSk::DeclarationImporter.import(attributes, factory: DeclarationFactory)
      end
    end
  end

  class DeclarationImporter
    def self.import(attributes, factory:)
      # TODO resolve absence of proclaims and statements

      declaration = DeclarationFactory.create(attributes)

      return unless declaration

      attributes[:lists].each do |list_attributes|
        list = factory.create_list(list_attributes, declaration: declaration)

        list_attributes[:items].each do |item_attributes|
          factory.create_item(item_attributes, list: list)
        end
      end

      attributes[:incomes].each do |income_attributes|
        factory.create_income(income_attributes, declaration: declaration)
      end

      attributes[:related_people].each do |related_people_attributes|
        factory.create_related_person(related_people_attributes, declaration: declaration)
      end
    end
  end

  class DeclarationFactory
    def self.create(attributes)
      judge = Judge.find_by(name: attributes[:judge])
      court = Court.find_by(name: attributes[:court])

      return unless judge && court

      source = Source.find_by(module: 'SudnaradaGovSk')
      declaration = Judge::Property::Declaration.find_or_initialize_by(judge: judge, year: attributes[:year])

      declaration.source = source
      declaration.court = court

      declaration.save!

      declaration
    end

    def self.create_list(attributes, declaration:)
      category = Judge::Property::Category.find_or_create_by!(value: attributes[:category])

      Judge::Property::List.find_or_create_by!(
        category: category,
        declaration: declaration
      )
    end

    def self.create_item(attributes, list:)
      reason = Judge::Property::AcquisitionReason.find_or_create_by!(value: attributes[:acquisition_reason])
      ownership_form = Judge::Property::OwnershipForm.find_or_create_by!(value: attributes[:ownership_form])
      change = Judge::Property::Change.find_or_create_by!(value: attributes[:change]) if attributes[:change]

      Judge::Property.find_or_create_by!(
        list: list,
        acquisition_reason: reason,
        change: change,
        ownership_form: ownership_form,
        description: attributes[:description],
        acquisition_date: attributes[:acquisition_date],
        cost: attributes[:cost],
        share_size: attributes[:share_size]
      )
    end

    def self.create_income(attributes, declaration:)
      income = Judge::Income.find_or_initialize_by(
        property_declaration: declaration,
        description: attributes[:description],
      )

      income.value = attributes[:value]

      income.save!
    end

    def self.create_related_person(attributes, declaration:)
      person = Judge::RelatedPerson.find_or_initialize_by(property_declaration: declaration, name_unprocessed: attributes[:name_unprocessed])

      person.name = attributes[:name]
      person.function = attributes[:function]
      person.institution = attributes[:institution]

      person.save!
    end
  end
end
