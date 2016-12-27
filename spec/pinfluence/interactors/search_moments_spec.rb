require 'spec_helper'

describe SearchMoments do
  after { database_clean }

  describe "#call" do
    let!(:person) { create :person, name: "PersonSearch" }
    let!(:moment_01) do
      create :moment, year_begin: 100, year_end: 150, person_id: person.id
    end
    let!(:moment_02) do
      create :moment, year_begin: 151, year_end: 180, person_id: person.id
    end

    context "when (person) :name param is given" do
      subject { described_class.new(name: person.name) }

      it "returns a list of found moments related to the found person" do
        results = subject.call
        expect(results.count).to eq 2
        expect(results.first.id).to eq moment_01.id
        expect(results.last.id).to eq moment_02.id
      end
    end

    context "when year param is given" do
      subject { described_class.new(year: "170") }

      it "returns a list of found moments happend in given year" do
        results = subject.call
        expect(results.count).to eq 1
        expect(results.first.id).to eq moment_02.id
      end
    end
  end
end