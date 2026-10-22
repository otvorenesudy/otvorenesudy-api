# frozen_string_literal: true

module Legacy
  module String
    refine ::String do
      # The string in UTF-8, as ActiveSupport::Multibyte::Chars (mb_chars, gone in Rails 8.2) made it.
      def utf_8
        encoding == Encoding::UTF_8 ? self : dup.force_encoding(Encoding::UTF_8)
      end

      # Each word capitalized and the rest lowercase ("NOVÁK-KRÁĽ" becomes "Novák-Kráľ"), as Chars#titleize did; unlike
      # String#titleize, it keeps hyphens and underscores.
      def capitalize_words
        downcase.gsub(/\b('?\S)/u) { Regexp.last_match(1).upcase }
      end

      def ascii
        return self if ascii_only?

        utf_8.unicode_normalize(:nfkd).bytes.map { |b| (0x00..0x7F).cover?(b) ? b.chr : '' }.join
      end
    end
  end
end
