require_relative '../../lib/meet_the_family'

RSpec.describe MeetTheFamily do

  describe 'test with test_input_1.txt' do
    let(:test_file) { File.join(File.dirname(__FILE__), '..', 'fixtures','test_input_1.txt') }

    it 'prints correct result' do
      expect(STDOUT).to receive(:puts).with("CHILD_ADDITION_SUCCEEDED").ordered
      expect(STDOUT).to receive(:puts).with("James John").ordered
      expect(STDOUT).to receive(:puts).with("Albus John").ordered

      described_class.run(test_file)
    end
  end

  describe 'test with test_input_2.txt' do
    let(:test_file) { File.join(File.dirname(__FILE__), '..', 'fixtures','test_input_2.txt') }

    it 'prints correct result' do
      expect(STDOUT).to receive(:puts).with("Lily").ordered
      expect(STDOUT).to receive(:puts).with("NONE").ordered
      expect(STDOUT).to receive(:puts).with("PERSON_NOT_FOUND").ordered

      described_class.run(test_file)
    end
  end

end