require_relative 'person'
require_relative 'error'

class Family
  attr_accessor :members, :name

  def initialize(name)
    @name = name
    @members = []
  end

  def get_relatives(name, relationship)
    find_person_by_name!(name).send(relationship)
  end

  def find_person_by_name(name)
    members.each do |member|
      return member if member.name == name
    end

    nil
  end

  def find_person_by_name!(name)
    person = find_person_by_name(name)
    raise NoPersonError if person.nil?

    person
  end

end