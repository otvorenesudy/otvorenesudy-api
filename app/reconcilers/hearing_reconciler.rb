class HearingReconciler
  attr_reader :hearing, :mapper

  def initialize(hearing, mapper:)
    @hearing = hearing
    @mapper = mapper
  end

  def reconcile!
    hearing.with_lock do
      reconcile_attributes
      reconcile_court
      reconcile_section
      reconcile_subject
      reconcile_form
      reconcile_proceeding
      reconcile_judges
      reconcile_proposers
      reconcile_opponents
      reconcile_defendants

      hearing.save!
      hearing.touch
    end
  end

  def reconcile_attributes
    # TODO: remove source, leave now for compatibility
    hearing.update!(
      uri: mapper.uri,
      type: Hearing::Type.find_by!(value: mapper.type),
      source: Source.find_by!(module: mapper.source),
      source_class: mapper.source_class,
      source_class_id: mapper.source_class_id,
      case_number: mapper.case_number,
      original_case_number: mapper.original_case_number,
      file_number: mapper.file_number,
      date: mapper.date,
      room: mapper.room,
      selfjudge: mapper.selfjudge,
      note: mapper.note,
      special_type: mapper.special_type,
      anonymized_at: Time.now
    )
  end

  def reconcile_court
    hearing.court = Court.find_by!(name: mapper.court)
    hearing.original_court = Court.find_by!(name: mapper.original_court) if mapper.original_court
  end

  def reconcile_section
    hearing.section = Hearing::Section.find_or_create_by!(value: mapper.section)
  end

  def reconcile_subject
    hearing.subject = Hearing::Subject.find_or_create_by!(value: mapper.subject) if mapper.subject
  end

  def reconcile_form
    hearing.form = Hearing::Form.find_or_create_by!(value: mapper.form)
  end

  def reconcile_proceeding
    hearing.proceeding = Proceeding.find_or_create_by!(file_number: mapper.file_number)
  end

  def reconcile_judges
    reconciler = ->(judge, chair:) do
      judging = Judging.find_or_initialize_by(hearing: hearing, judge: judge)

      judging.update!(judge_chair: chair, judge_name_similarity: 1)

      judging
    end

    judgings = mapper.chair_judges.map { |name| reconciler.call(name, chair: true) }
    judgings += mapper.judges.map { |name| reconciler.call(name, chair: false) }

    hearing.purge!(:judgings, except: judgings)
  end

  def reconcile_opponents
    opponents =
      mapper.opponents.map do |name|
        opponent = Opponent.find_or_initialize_by(name_unprocessed: name, hearing: hearing)

        opponent.update!(name: RandomInitialsProvider.provide)

        opponent
      end

    hearing.purge!(:opponents, except: opponents)
  end

  def reconcile_defendants
    defendants =
      mapper.defendants.map do |name|
        defendant = Defendant.find_or_initialize_by(name_unprocessed: name, hearing: hearing)

        defendant.update!(name: RandomInitialsProvider.provide)

        defendant
      end

    hearing.purge!(:defendants, except: defendants)
  end

  def reconcile_proposers
    proposers =
      mapper.proposers.map do |name|
        proposer = Proposer.find_or_initialize_by(name_unprocessed: name, hearing: hearing)

        proposer.update!(name: RandomInitialsProvider.provide)

        proposer
      end

    hearing.purge!(:proposers, except: proposers)
  end

  class RandomInitialsProvider
    def self.provide
      ('A'..'Z').to_a.sample(2).map { |e| "#{e}." }.join(' ')
    end
  end
end
