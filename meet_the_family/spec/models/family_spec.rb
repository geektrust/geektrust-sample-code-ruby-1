require_relative '../../lib/models/family'

RSpec.describe Family do
  subject { described_class.new('King') }
  let(:person) { double('person', name: 'nana') }

  describe '#get_relatives' do
    let(:relationship) { 'uncle' }

    context 'when the person is found' do
      before do
        expect(subject).to(
          receive(:find_person_by_name!).with(person.name)
        ).and_return(person)
      end

      it 'sends the relationship method call to the person object' do
        expect(person).to receive(relationship)
        subject.get_relatives(person.name, relationship)
      end
    end

    context 'when the person not found' do
      before do
        expect(subject).to(
          receive(:find_person_by_name!).with(person.name)
        ).and_raise NoPersonError
      end

      it 'raises no person error' do
        expect {
          subject.get_relatives(person.name, relationship)
        }.to raise_error(NoPersonError)
      end
    end
  end

  describe '#find_person_by_name' do
    context 'when the person is found' do
      before do
        allow(subject).to receive(:members).and_return([person])
      end

      it 'returns the person' do
        expect(subject.find_person_by_name(person.name)).to eq(person)
      end
    end

    context 'when the person is not found' do
      before do
        allow(subject).to receive(:members).and_return([])
      end

      it 'returns nil' do
        expect(subject.find_person_by_name(person.name)).to be_nil
      end
    end
  end

  describe '#find_person_by_name!' do
    context 'when the person is found' do
      before do
        allow(subject).to(
          receive(:find_person_by_name).with(person.name)
        ).and_return(person)
      end

      it 'returns the person' do
        expect(subject.find_person_by_name(person.name)).to eq(person)
      end
    end

    context 'when the person is not found' do
      before do
        allow(subject).to(
          receive(:find_person_by_name).with(person.name)
        ).and_return(nil)
      end

      it 'raises no person error' do
        expect {
          subject.find_person_by_name!(person.name)
        }.to raise_error(NoPersonError)
      end
    end
  end
end