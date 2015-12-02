RSpec::Matchers.define :satisfy do |*matchers|
  match do |actual|
    compound = matchers[1..-1].inject(matchers[0]).each { |c, matcher| c.and(matcher) }

    expect(actual).to compound
  end

  supports_block_expectations
end
