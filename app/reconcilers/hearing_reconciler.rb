class HearingReconciler
  attr_reader :hearing, :mapper

  def initialize(hearing, mapper:)
    @hearing = hearing
    @mapper = mapper
  end
end
