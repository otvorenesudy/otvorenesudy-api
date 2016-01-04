module Legacy
  module String
    refine ::String do
      def utf8
        self.mb_chars
      end

      def ascii
        return self if self.ascii_only?

        self.utf8.normalize(:kd).bytes.map { |b| (0x00..0x7F).include?(b) ? b.chr : '' }.join
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
