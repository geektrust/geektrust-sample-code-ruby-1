require_relative '../../lib/services/family_builder'
require 'spec_helper'

RSpec.describe FamilyBuilder do
  let(:family) { double('family') }
  subject { described_class.new(family) }

  describe '#create_from_file' do
    let(:family_file) { double('family file') }
    let(:members_hash) { {'king': {}, 'queen': {}} }

    before do
      allow(YAML).to(
        receive(:load).with(family_file)
      ).and_return(members_hash)
    end

    it 'builds person then adds relations to each person' do
      expect(subject).to receive(:create_person).with('king', {}).ordered
      expect(subject).to receive(:create_person).with('queen', {}).ordered
      expect(subject).to receive(:add_relations).with('king', {}).ordered
      expect(subject).to receive(:add_relations).with('queen', {}).ordered

      subject.create_from_file(family_file)
    end
  end

  describe '#add_child' do
    let(:father) { double('father') }
    let(:mother) { double('mother', name:'test mom', spouse: father) }
    let(:child_name) { 'test child' }
    let(:child_gender) { 'female' }

    context 'when mother is found' do
      before do
        expect(family).to(
          receive(:find_person_by_name!).with(mother.name)
        ).and_return(mother)
        expect(mother).to receive(:female?).and_return(true)
      end

      it 'adds child to the family tree' do
        expect(Person).to(
          receive(:new).with(
            name: child_name,
            gender: child_gender,
            mother: mother,
            father: father,
            family: family
          )
        )
        subject.add_child(mother.name, child_name, child_gender)
      end
    end

    context 'when mother is with wrong gender' do
      before do
        expect(family).to(
          receive(:find_person_by_name!).with(mother.name)
        ).and_return(mother)
        expect(mother).to receive(:female?).and_return(false)
      end

      it 'adds child to the family tree' do
        expect {
          subject.add_child(mother.name, child_name, child_gender)
        }.to raise_error(InvalidMotherNameError)
      end
    end

    context 'when mother is not found' do
      before do
        expect(family).to(
          receive(:find_person_by_name!).with(mother.name)
        ).and_raise(NoPersonError)
      end

      it 'raises NoPersonError' do
        expect {
          subject.add_child(mother.name, child_name, child_gender)
        }.to raise_error(NoPersonError)
      end
    end
  end


  describe '#create_person' do
    let(:name) { 'new person' }
    let(:details) { {gender: "male"} }

    it 'creates a person in the family' do
      expect(Person).to(
        receive(:new).with(
          name: name,
          gender: 'male',
          family: family
        )
      )
      subject.send(:create_person, name, details.stringify_keys)
    end
  end

  describe '#add_relations' do
    let(:new_person) { double('person', name: 'new') }
    let(:mother) { double('mother', name: 'mom') }
    let(:father) { double('father', name: 'dad') }
    let(:spouse) { double('spouse', name: 'spouse') }
    let(:details) { {father: father.name, mother: mother.name, spouse: spouse.name} }

    before do
      expect(family).to(
        receive(:find_person_by_name).with(new_person.name)
      ).and_return(new_person)
      expect(family).to(
        receive(:find_person_by_name).with(mother.name)
      ).and_return(mother)
      expect(family).to(
        receive(:find_person_by_name).with(father.name)
      ).and_return(father)
      expect(family).to(
        receive(:find_person_by_name).with(spouse.name)
      ).and_return(spouse)
    end

    it 'adds family relations to the person' do
      expect(new_person).to receive(:father=).with(father)
      expect(new_person).to receive(:mother=).with(mother)
      expect(new_person).to receive(:spouse=).with(spouse)

      subject.send(:add_relations, new_person.name, details.stringify_keys)
    end
  end
end