module ObcanJusticeSk
  module Refinements
    module UnicodeString
      refine String do
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
  end
end
