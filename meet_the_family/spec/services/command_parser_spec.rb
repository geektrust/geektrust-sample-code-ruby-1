require_relative '../../lib/services/command_parser'

RSpec.describe CommandParser do
  let(:family) { double('family') }
  let(:family_builder) { double('family builder', family: family) }
  let(:input_file) { double('test file') }
  let(:file_line_1) { 'action_1 param_1 param_2' }
  let(:file_line_2) { 'action_2 param_3 param_4 param_5' }

  before do
    allow(File).to(
      receive(:open).with(input_file)
    ).and_return([file_line_1, file_line_2])
  end

  subject { described_class.new(input_file: input_file, family_builder: family_builder)}

  describe '#execute' do
    it 'reads and parses each line from the input file' do
      expect(subject).to receive(:action_1).with(file_line_1.split(' '))
      expect(subject).to receive(:action_2).with(file_line_2.split(' '))

      subject.execute
    end
  end

  describe '#add_child' do
    let(:params) { ['add_child', 'mother_name', 'child_name', 'child_gender'] }

    context 'when child addition succeeds' do
      it 'adds the child and prints success message' do
        expect(family_builder).to(
          receive(:add_child).with('mother_name', 'child_name', 'child_gender')
        )
        expect(STDOUT).to receive(:puts).with('CHILD_ADDITION_SUCCEEDED')

        subject.send(:add_child, params)
      end
    end

    context 'when child addition fails' do
      context 'when cannot find the mother person' do
        before do
          expect(family_builder).to(
            receive(:add_child)
          ).and_raise NoPersonError
        end

        it 'prints no person found error' do
          expect(STDOUT).to receive(:puts).with('PERSON_NOT_FOUND')

          subject.send(:add_child, params)
        end
      end

      context 'when the found person is not a valid mother' do
        before do
          expect(family_builder).to(
            receive(:add_child)
          ).and_raise InvalidMotherNameError
        end

        it 'prints child addition failed error' do
          expect(STDOUT).to receive(:puts).with('CHILD_ADDITION_FAILED')

          subject.send(:add_child, params)
        end
      end
    end
  end

  describe '#get_relationship' do
    let(:command_relation) { 'command relation'}
    let(:method_relation) { 'method name relation'}
    let(:params) { ['get_relationship', 'person_name', command_relation] }
    let(:relative_1) { double('person', name: 'nana') }
    let(:relative_2) { double('person', name: 'momo') }

    before do
      allow(CommandParser::COMMANDS_RELATIONS_MAPPING).to(
        receive(:[]).with(command_relation.to_sym)
      ).and_return(method_relation)
    end

    context 'when relatives found' do
      before do
        expect(family).to(
          receive(:get_relatives).with('person_name', method_relation)
        ).and_return([relative_1, relative_2])
      end

      it 'prints all the relatives' do
        expect(STDOUT).to receive(:puts).with("nana momo")

        subject.send(:get_relationship, params)
      end
    end

    context 'when no relative found' do
      before do
        expect(family).to(
          receive(:get_relatives).with('person_name', method_relation)
        ).and_return([])
      end

      it 'prints NONE' do
        expect(STDOUT).to receive(:puts).with("NONE")

        subject.send(:get_relationship, params)
      end
    end

    context 'when the person is not found' do
      before do
        expect(family).to(
          receive(:get_relatives).with('person_name', method_relation)
        ).and_raise(NoPersonError)
      end

      it 'prints person not found' do
        expect(STDOUT).to receive(:puts).with("PERSON_NOT_FOUND")

        subject.send(:get_relationship, params)
      end
    end
  end

end