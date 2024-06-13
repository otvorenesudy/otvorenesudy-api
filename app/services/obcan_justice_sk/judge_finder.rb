module ObcanJusticeSk
  class JudgeFinder
    attr :name

    def self.find_by(name:, guid:)
      return ::Judge.find_by(name: name) unless guid

      obcan_justice_sk_judge = ObcanJusticeSk::Judge.find_by!(guid: guid)

      ::Judge.find_by(source_class: obcan_justice_sk_judge.class.name, source_class_id: obcan_justice_sk_judge.id)
    end
  end
end
