require_relative 'models/family'
require_relative 'services/family_builder'
require_relative 'services/command_parser'

class MeetTheFamily
  FAMILY_FILE = File.join(File.dirname(__FILE__), '..', 'data', 'family_members.yml')

  def self.run(input_file)
    family =  Family.new("Kingdom")
    family_builder = FamilyBuilder.new(family)
    family_builder.create_from_file(File.open(FAMILY_FILE))

    command_parser = CommandParser.new(
      input_file: input_file,
      family_builder: family_builder
    )
    command_parser.execute
  end
end