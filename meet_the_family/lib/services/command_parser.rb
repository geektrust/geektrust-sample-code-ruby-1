require_relative '../services/family_builder'

class CommandParser
  COMMANDS_RELATIONS_MAPPING = {
    'Paternal-Uncle': 'paternal_uncles',
    'Maternal-Uncle': 'maternal_uncles',
    'Paternal-Aunt': 'paternal_aunts',
    'Maternal-Aunt': 'maternal_aunts',
    'Sister-In-Law': 'sisters_in_law',
    'Brother-In-Law': 'brothers_in_law',
    'Son': 'sons',
    'Daughter': 'daughters',
    'Siblings': 'siblings'
  }

  def initialize(family_builder:, input_file:)
    @family_builder = family_builder
    @family = family_builder.family
    @input_file = input_file
  end

  def execute
    File.open(@input_file).each do |line|
      params = line.split(' ')
      action = params.first

      send(action.downcase, params)
    end
  end

  private

  def add_child(params)
    mother_name = params[1]
    child_name = params[2]
    gender = params[3]

    begin
      @family_builder.add_child(mother_name, child_name, gender)
      puts "CHILD_ADDITION_SUCCEEDED"
    rescue NoPersonError => e
      puts "PERSON_NOT_FOUND"
    rescue InvalidMotherNameError => e
      puts "CHILD_ADDITION_FAILED"
    end
  end

  def get_relationship(params)
    name = params[1]
    relationship = COMMANDS_RELATIONS_MAPPING[params[2].to_sym]

    begin
      result = @family.get_relatives(name, relationship).map(&:name)
      if result.size == 0
        puts "NONE"
      else
        puts result.join(' ')
      end
    rescue NoPersonError => e
      puts "PERSON_NOT_FOUND"
    end
  end

end