module JusticeGovSk
  module Refinements
    module UnicodeString
      # TODO consider better naming when expands

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
