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
    # TODO remove source, leave now for compatibility
    hearing.update_attributes!(
      uri: mapper.uri,
      type: Hearing::Type.find_by!(value: mapper.type),
      source: Source.find_by!(module: 'JusticeGovSk'),
      case_number: mapper.case_number,
      file_number: mapper.file_number,
      date: mapper.date,
      room: mapper.room,
      selfjudge: mapper.selfjudge,
      note: mapper.note,
      special_type: mapper.special_type
    )
  end

  def reconcile_court
    hearing.court = Court.find_by!(name: mapper.court)
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
    reconciler = ->(name, chair:) do
      judge = JudgeFinder.find_by(name: name)

      Judging.find_or_create_by!(
        hearing: hearing,
        judge: judge,
        judge_name_unprocessed: name,
        judge_name_similarity: judge ? 1 : 0,
        judge_chair: chair
      )
    end

    judgings = mapper.chair_judges.map { |name| reconciler.call(name, chair: true) }
    judgings += mapper.judges.map { |name| reconciler.call(name, chair: false) }

    hearing.purge!(:judgings, except: judgings)
  end

  def reconcile_opponents
    opponents = mapper.opponents.map do |name|
      Opponent.find_or_create_by!(name: name, name_unprocessed: name, hearing: hearing)
    end

    hearing.purge!(:opponents, except: opponents)
  end

  def reconcile_defendants
    defendants = mapper.defendants.map do |name|
      Defendant.find_or_create_by!(name: name, name_unprocessed: name, hearing: hearing)
    end

    hearing.purge!(:defendants, except: defendants)
  end

  def reconcile_proposers
    proposers = mapper.proposers.map do |name|
      Proposer.find_or_create_by!(name: name, name_unprocessed: name, hearing: hearing)
    end

    hearing.purge!(:proposers, except: proposers)
  end
end
