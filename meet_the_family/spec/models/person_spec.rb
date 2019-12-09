require_relative '../../lib/models/person'

RSpec.describe Person do
  let(:name) { 'nana' }
  let(:gender) { 'female' }
  let(:family) { double('family', members: []) }

  subject { described_class.new(
      name: name,
      gender: gender,
      family: family
    )
  }

  describe '#initialize' do
    it 'adds into the family' do
      expect(family.members).to eq([subject])
    end
  end

  describe '#male?' do
    context 'when the person is male' do
      before do
        expect(subject).to receive(:gender).and_return('Male')
      end

      it 'returns true' do
        expect(subject.male?).to be_truthy
      end
    end

    context 'when the person is female' do
      before do
        expect(subject).to receive(:gender).and_return('Female')
      end

      it 'returns false' do
        expect(subject.male?).to be_falsey
      end
    end
  end

  describe '#female?' do
    context 'when the person is male' do
      before do
        expect(subject).to receive(:gender).and_return('Male')
      end

      it 'returns false' do
        expect(subject.female?).to be_falsey
      end
    end

    context 'when the person is female' do
      before do
        expect(subject).to receive(:gender).and_return('Female')
      end

      it 'returns true' do
        expect(subject.female?).to be_truthy
      end
    end
  end
end