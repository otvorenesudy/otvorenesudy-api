module UnicodeString
  module UnicodeMethods
    extend ActiveSupport::Concern

    included do
      alias :utf8 :mb_chars
    end

    def ascii
      return self if self.ascii_only?

      self.utf8.normalize(:kd).bytes.map { |b| (0x00..0x7F).include?(b) ? b.chr : '' }.join
    end
  end

  refine String do
    include UnicodeMethods

    def strip
      dup.tap { |string| string.strip! }
    end

    def strip!
      left = gsub!(/\A[[:space:]]+/, '')
      right = gsub!(/[[:space:]]+\z/, '')

      left || right ? self : nil
    end
  end

  class UnicodedString < ::String
    include UnicodeMethods
  end
end
