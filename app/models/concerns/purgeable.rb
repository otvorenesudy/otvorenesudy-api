module Purgeable
  def purge!(relation_name, except: nil)
    relation = public_send(relation_name)

    relation.where.not(id: except).destroy_all
  end
end
