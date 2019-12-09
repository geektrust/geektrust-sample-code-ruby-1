require 'yaml'
require_relative '../models/family'
require_relative '../models/error'

class FamilyBuilder
  attr_reader :family

  def initialize(family)
    @family = family
  end

  def create_from_file(family_file)
    members_hash = YAML.load(family_file)

    members_hash.each do |name, details|
      create_person(name.to_s, details)
    end

    members_hash.each do |name, details|
      add_relations(name.to_s, details)
    end
  end

  def add_child(mother_name, child_name, child_gender)
    mother = @family.find_person_by_name!(mother_name)

    raise InvalidMotherNameError unless mother.female?

    Person.new(
      name: child_name,
      gender: child_gender,
      mother: mother,
      father: mother.spouse,
      family: @family
    )
  end

  private

  def create_person(name, details)
    Person.new(
      name: name,
      gender: details['gender'],
      family: @family
    )
  end

  def add_relations(name, details)
    member = @family.find_person_by_name(name)

    member.father = @family.find_person_by_name(details['father'])
    member.mother = @family.find_person_by_name(details['mother'])
    member.spouse = @family.find_person_by_name(details['spouse'])
  end
end