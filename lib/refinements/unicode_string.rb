module UnicodeString
  refine String do
    alias :utf8 :mb_chars

    def strip
      dup.tap { |string| string.strip! }
    end

    def strip!
      left = gsub!(/\A[[:space:]]+/, '')
      right = gsub!(/[[:space:]]+\z/, '')

      left || right ? self : nil
    end
  end
end
