module ObcanJusticeSk
  class Uri
    attr_accessor :template

    def initialize(template)
      @template = template
    end

    def build(page:)
      template.gsub(/<page>/, page.to_s)
    end
  end
end
