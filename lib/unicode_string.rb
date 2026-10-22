# frozen_string_literal: true

module UnicodeString
  refine String do
    def strip
      dup.tap(&:strip!)
    end

    def strip!
      left = gsub!(/\A[[:space:]]+/, '')
      right = gsub!(/[[:space:]]+\z/, '')

      left || right ? self : nil
    end
  end
end
