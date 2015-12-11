module JusticeGovSk
  module Refinements
    module String
      # TODO consider better naming when expands

      refine ::String do
        def strip
          dup.strip!
        end

        def strip!
          gsub!(/\A[[:space:]]+/, '').gsub!(/[[:space:]]+\z/, '')
        end
      end
    end
  end
end
