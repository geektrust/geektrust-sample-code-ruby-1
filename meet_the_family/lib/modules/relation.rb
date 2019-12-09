module Relation
  def sons
    members_without_self.select { |member|
      member.parents.include?(self) && member.male?
    }
  end

  def daughters
    members_without_self.select { |member|
      member.parents.include?(self) && member.female?
    }
  end

  def siblings
    members_without_self.select { |member|
      same_parents?(member)
    }
  end

  def brothers_in_law
    spouse_brothers | husbands_of_siblings
  end

  def sisters_in_law
    spouse_sisters | wives_of_siblings
  end

  def maternal_aunts
    mother&.sisters || []
  end

  def paternal_aunts
    father&.sisters || []
  end

  def maternal_uncles
    mother&.brothers || []
  end

  def paternal_uncles
    father&.brothers || []
  end

  def parents
    [mother, father]
  end

  def brothers
    siblings.select { |member| member.male? }
  end

  def sisters
    siblings.select { |member| member.female? }
  end

  private

  def same_parents?(member)
    return false if mother.nil? || father.nil?

    member.parents == self.parents
  end

  def husbands_of_siblings
    siblings.select { |sibling|
      sibling.spouse&.male?
    }
  end

  def wives_of_siblings
    siblings.select { |sibling|
      sibling.spouse&.female?
    }
  end

  def spouse_brothers
    spouse&.brothers || []
  end

  def spouse_sisters
    spouse&.sisters || []
  end

  def members_without_self
    family.members - [self]
  end
end