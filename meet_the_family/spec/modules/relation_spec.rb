require_relative '../../lib/modules/relation'

class DummyPersonClass
  include Relation
end

RSpec.describe Relation do
  subject { DummyPersonClass.new }

  let(:member) { double('person')}
  let(:member_1) { double('person') }
  let(:member_2) { double('person') }
  let(:family) { double('family') }

  before do
    allow(subject).to receive(:family).and_return family
  end

  describe '#sons' do
    before do
      allow(family).to receive(:members).and_return([member])
    end

    context 'when gender and parents match' do
      before do
        expect(member).to(
          receive(:parents)
        ).and_return([subject])

        expect(member).to(
          receive('male?')
        ).and_return(true)
      end

      it 'returns an array with sons' do
        expect(subject.sons).to eq([member])
      end
    end

    context 'when gender does not match' do
      before do
        expect(member).to(
          receive(:parents)
        ).and_return([subject])

        expect(member).to(
          receive(:male?)
        ).and_return(false)
      end

      it 'returns empty array' do
        expect(subject.sons).to be_empty
      end
    end

    context 'when parents does not match' do
      before do
        expect(member).to(
          receive(:parents)
        ).and_return([])
      end

      it 'returns empty array' do
        expect(subject.sons).to be_empty
      end
    end
  end

  describe '#daughters' do
    before do
      allow(family).to receive(:members).and_return([member])
    end

    context 'when gender and parents match' do
      before do
        expect(member).to(
          receive(:parents)
        ).and_return([subject])

        expect(member).to(
          receive('female?')
        ).and_return(true)
      end

      it 'returns an array with daughters' do
        expect(subject.daughters).to eq([member])
      end
    end

    context 'when gender does not match' do
      before do
        expect(member).to(
          receive(:parents)
        ).and_return([subject])

        expect(member).to(
          receive(:female?)
        ).and_return(false)
      end

      it 'returns empty array' do
        expect(subject.daughters).to be_empty
      end
    end

    context 'when parents does not match' do
      before do
        expect(member).to(
          receive(:parents)
        ).and_return([])
      end

      it 'returns empty array' do
        expect(subject.daughters).to be_empty
      end
    end
  end

  describe '#siblings' do
    before do
      allow(family).to receive(:members).and_return([member])
    end

    context 'when same parents' do
      before do
        expect(subject).to(
          receive(:same_parents?)
        ).and_return(true)
      end

      it 'returns an array with siblings' do
        expect(subject.siblings).to eq([member])
      end
    end

    context 'when different parents' do
      before do
        expect(subject).to(
          receive(:same_parents?)
        ).and_return(false)
      end

      it 'returns empty array' do
        expect(subject.siblings).to be_empty
      end
    end
  end

  describe '#brothers_in_law' do
    before do
      expect(subject).to(
        receive(:spouse_brothers)
      ).and_return([member, member_1])

      expect(subject).to(
        receive(:husbands_of_siblings)
      ).and_return([member_1, member_2])
    end

    it 'get a unique array merged from spouse brothers and husbands of siblings' do
      expect(subject.brothers_in_law).to eq([member, member_1, member_2])
    end
  end

  describe '#sisters_in_law' do
    before do
      expect(subject).to(
        receive(:spouse_sisters)
      ).and_return([member, member_1])

      expect(subject).to(
        receive(:wives_of_siblings)
      ).and_return([member_1, member_2])
    end

    it 'get a unique array merged from spouse brothers and husbands of siblings' do
      expect(subject.sisters_in_law).to eq([member, member_1, member_2])
    end
  end

  describe '#maternal_aunts' do
    context 'when there are maternal aunts' do
      before do
        expect(subject).to receive_message_chain(:mother, :sisters).and_return([member])
      end

      it 'returns an array of maternal aunts' do
        expect(subject.maternal_aunts).to eq([member])
      end
    end

    context 'when there is no mother record' do
      before do
        expect(subject).to receive(:mother)
      end

      it 'returns an empty array' do
        expect(subject.maternal_aunts).to be_empty
      end
    end

    context 'when there is no maternal aunt' do
      before do
        expect(subject).to receive_message_chain(:mother, :sisters).and_return([])
      end

      it 'returns an empty array' do
        expect(subject.maternal_aunts).to be_empty
      end
    end
  end

  describe '#paternal_aunts' do
    context 'when there are paternal aunts' do
      before do
        expect(subject).to receive_message_chain(:father, :sisters).and_return([member])
      end

      it 'returns an array of paternal aunts' do
        expect(subject.paternal_aunts).to eq([member])
      end
    end

    context 'when there is no father record' do
      before do
        expect(subject).to receive(:father)
      end

      it 'returns an empty array' do
        expect(subject.paternal_aunts).to be_empty
      end
    end

    context 'when there is no paternal aunt' do
      before do
        expect(subject).to receive_message_chain(:father, :sisters).and_return([])
      end

      it 'returns an empty array' do
        expect(subject.paternal_aunts).to be_empty
      end
    end
  end

  describe '#maternal_uncles' do
    context 'when there are maternal uncles' do
      before do
        expect(subject).to receive_message_chain(:mother, :brothers).and_return([member])
      end

      it 'returns an array of maternal uncles' do
        expect(subject.maternal_uncles).to eq([member])
      end
    end

    context 'when there is no mother record' do
      before do
        expect(subject).to receive(:mother)
      end

      it 'returns an empty array' do
        expect(subject.maternal_uncles).to be_empty
      end
    end

    context 'when there is no maternal uncles' do
      before do
        expect(subject).to receive_message_chain(:mother, :brothers).and_return([])
      end

      it 'returns an empty array' do
        expect(subject.maternal_uncles).to be_empty
      end
    end
  end

  describe '#paternal_uncles' do
    context 'when there are paternal uncles' do
      before do
        expect(subject).to receive_message_chain(:father, :brothers).and_return([member])
      end

      it 'returns an array of paternal uncles' do
        expect(subject.paternal_uncles).to eq([member])
      end
    end

    context 'when there is no father record' do
      before do
        expect(subject).to receive(:father)
      end

      it 'returns an empty array' do
        expect(subject.paternal_uncles).to be_empty
      end
    end

    context 'when there is no paternal uncles' do
      before do
        expect(subject).to receive_message_chain(:father, :brothers).and_return([])
      end

      it 'returns an empty array' do
        expect(subject.paternal_uncles).to be_empty
      end
    end
  end

  describe '#parents' do
    before do
      expect(subject).to receive(:mother).and_return(member)
      expect(subject).to receive(:father).and_return(member_1)
    end

    it 'returns an array that has mother and father' do
      expect(subject.parents).to eq([member, member_1])
    end
  end

  describe '#brothers' do
    context 'when there are brothers' do
      before do
        expect(subject).to receive(:siblings).and_return([member])
        expect(member).to receive(:male?).and_return(true)
      end

      it 'returns an array of brothers' do
        expect(subject.brothers).to eq([member])
      end
    end

    context 'when there is no brother' do
      before do
        expect(subject).to receive(:siblings).and_return([member])
        expect(member).to receive(:male?).and_return(false)
      end

      it 'returns an empty array' do
        expect(subject.brothers).to be_empty
      end
    end
  end

  describe '#sisters' do
    context 'when there are sisters' do
      before do
        expect(subject).to receive(:siblings).and_return([member])
        expect(member).to receive(:female?).and_return(true)
      end

      it 'returns an array of sisters' do
        expect(subject.sisters).to eq([member])
      end
    end

    context 'when there is no sister' do
      before do
        expect(subject).to receive(:siblings).and_return([member])
        expect(member).to receive(:female?).and_return(false)
      end

      it 'returns an empty array' do
        expect(subject.sisters).to be_empty
      end
    end
  end

  describe '#same_parents?' do
    context 'when mother or father is not recorded' do
      before do
        expect(subject).to receive(:mother)
      end

      it 'returns false' do
        expect(subject.send(:same_parents?, member)).to be_falsey
      end
    end

    context 'when parents are different' do
      before do
        expect(member).to receive(:parents).and_return([member_1, member_2])
        allow(subject).to receive(:mother).and_return(member)
        allow(subject).to receive(:father).and_return(member_2)
      end

      it 'returns false' do
        expect(subject.send(:same_parents?, member)).to be_falsey
      end
    end

    context 'when parents are the same' do
      before do
        expect(member).to receive(:parents).and_return([member_1, member_2])
        allow(subject).to receive(:mother).and_return(member_1)
        allow(subject).to receive(:father).and_return(member_2)
      end

      it 'returns true' do
        expect(subject.send(:same_parents?, member)).to be_truthy
      end
    end
  end

  describe '#husbands_of_siblings' do
    let(:male_spouse) { double('person', male?: true)}
    let(:female_spouse) { double('person', male?: false)}

    context 'when there are husbands of siblings' do
      before do
        expect(subject).to receive(:siblings).and_return([member, member_1, member_2])
        expect(member).to receive(:spouse)
        expect(member_1).to receive(:spouse).and_return(male_spouse)
        expect(member_2).to receive(:spouse).and_return(female_spouse)
      end

      it 'returns an array of husbands of siblings' do
        expect(subject.send(:husbands_of_siblings)).to eq([member_1])
      end
    end

    context 'when there is no siblings' do
      before do
        expect(subject).to receive(:siblings).and_return([])
      end

      it 'returns an empty array' do
        expect(subject.send(:husbands_of_siblings)).to be_empty
      end
    end

    context 'when there is no husbands of siblings' do
      before do
        expect(subject).to receive(:siblings).and_return([member, member_1])
        expect(member).to receive(:spouse)
        expect(member_1).to receive(:spouse).and_return(female_spouse)
      end

      it 'returns an empty array' do
        expect(subject.send(:husbands_of_siblings)).to be_empty
      end

    end
  end

  describe '#wives_of_siblings' do
    let(:male_spouse) { double('person', female?: false)}
    let(:female_spouse) { double('person', female?: true)}

    context 'when there are wives of siblings' do
      before do
        expect(subject).to receive(:siblings).and_return([member, member_1, member_2])
        expect(member).to receive(:spouse)
        expect(member_1).to receive(:spouse).and_return(male_spouse)
        expect(member_2).to receive(:spouse).and_return(female_spouse)
      end

      it 'returns an array of wives of siblings' do
        expect(subject.send(:wives_of_siblings)).to eq([member_2])
      end
    end

    context 'when there is no siblings' do
      before do
        expect(subject).to receive(:siblings).and_return([])
      end

      it 'returns an empty array' do
        expect(subject.send(:wives_of_siblings)).to be_empty
      end
    end

    context 'when there is no wives of siblings' do
      before do
        expect(subject).to receive(:siblings).and_return([member, member_1])
        expect(member).to receive(:spouse)
        expect(member_1).to receive(:spouse).and_return(male_spouse)
      end

      it 'returns an empty array' do
        expect(subject.send(:wives_of_siblings)).to be_empty
      end

    end
  end

  describe '#spouse_brothers' do
    context 'when there are spouse brothers' do
      before do
        expect(subject).to receive_message_chain(:spouse, :brothers).and_return([member])
      end

      it 'returns an array of spouse brothers' do
        expect(subject.send(:spouse_brothers)).to eq([member])
      end
    end

    context 'when there is no spouse record' do
      before do
        expect(subject).to receive(:spouse)
      end

      it 'returns an empty array' do
        expect(subject.send(:spouse_brothers)).to be_empty
      end
    end

    context 'when there is no spouse brothers' do
      before do
        expect(subject).to receive_message_chain(:spouse, :brothers).and_return([])
      end

      it 'returns an empty array' do
        expect(subject.send(:spouse_brothers)).to be_empty
      end
    end
  end

  describe '#spouse_sisters' do
    context 'when there are spouse sisters' do
      before do
        expect(subject).to receive_message_chain(:spouse, :sisters).and_return([member])
      end

      it 'returns an array of spouse sisters' do
        expect(subject.send(:spouse_sisters)).to eq([member])
      end
    end

    context 'when there is no spouse record' do
      before do
        expect(subject).to receive(:spouse)
      end

      it 'returns an empty array' do
        expect(subject.send(:spouse_sisters)).to be_empty
      end
    end

    context 'when there is no spouse sisters' do
      before do
        expect(subject).to receive_message_chain(:spouse, :sisters).and_return([])
      end

      it 'returns an empty array' do
        expect(subject.send(:spouse_sisters)).to be_empty
      end
    end
  end

end