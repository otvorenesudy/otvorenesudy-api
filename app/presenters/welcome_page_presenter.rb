class WelcomePagePresenter
  attr_reader :cache

  def initialize(cache:)
    @cache = cache
  end

  def decrees_count
    cache.fetch('decrees_count', expires_in: 12.hours) { Decree.count }
  end

  def judges_count
    cache.fetch('judges_count', expires_in: 12.hours) { Judge.count }
  end

  def hearings_count
    cache.fetch('hearings_count', expires_in: 12.hours) { Hearing.count }
  end
end
