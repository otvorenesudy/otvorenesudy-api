class UpdateDelegator
  extend Forwardable

  attr_reader :record, :attributes, :restricted_attributes
  def_delegator :@record, :update_attributes!

  def initialize(record, restricted_attributes: [])
    @record = record
    @restricted_attributes = restricted_attributes.map(&:to_sym)
  end

  def attributes=(attributes)
    @attributes = attributes.deep_symbolize_keys
  end

  def changed?
    raise ArgumentError.new('You need to provide attributes to compare with first.') unless @attributes

    keys = @attributes.keys - @restricted_attributes

    @record.attributes.deep_symbolize_keys.slice(*keys) != @attributes.slice(*keys)
  end
end
