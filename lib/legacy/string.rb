module Legacy
  module String
    refine ::String do
      # The string in UTF-8, as ActiveSupport::Multibyte::Chars (mb_chars, gone in Rails 8.2) made it.
      def utf8
        encoding == Encoding::UTF_8 ? self : dup.force_encoding(Encoding::UTF_8)
      end

      # Each word capitalized and the rest lowercase ("NOVÁK-KRÁĽ" becomes "Novák-Kráľ"), as Chars#titleize did; unlike
      # String#titleize, it keeps hyphens and underscores.
      def capitalize_words
        downcase.gsub(/\b('?\S)/u) { Regexp.last_match(1).upcase }
      end

      def ascii
        return self if self.ascii_only?

        self.utf8.unicode_normalize(:nfkd).bytes.map { |b| (0x00..0x7F).include?(b) ? b.chr : '' }.join
      end

      def downcase_first
        self.sub(/^\D{0,1}/) { |c| c.downcase }
      end

      def downcase_first!
        self.sub!(/^\D{0,1}/) { |c| c.downcase }
      end

      def upcase_first
        self.sub(/^\D{0,1}/) { |c| c.upcase }
      end

      def upcase_first!
        self.sub!(/^\D{0,1}/) { |c| c.upcase }
      end
    end
  end
end
