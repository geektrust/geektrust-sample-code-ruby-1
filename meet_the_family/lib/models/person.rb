require_relative '../modules/relation'

class Person
  include Relation
  attr_accessor :name, :gender, :father, :mother, :spouse
  attr_reader :family

  def initialize(name:, gender:, father: nil, mother: nil, spouse: nil, family:)
    @name = name
    @gender = gender
    @father = father
    @mother = mother
    @spouse = spouse
    @family = family

    @family.members << self
  end

  def male?
    gender == 'Male'
  end

  def female?
    gender == 'Female'
  end
end