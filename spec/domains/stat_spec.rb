require "rails_helper"

describe Stat do
  let(:args) do
    {
      confirmed: confirmed,
      critical: critical,
      datetime: datetime,
      deaths: deaths,
      new_confirmed: new_confirmed,
      new_deaths: new_deaths,
      recovered: recovered,
      tests: tests
    }
  end
  let(:confirmed) { double("confirmed") }
  let(:critical) { double("critical") }
  let(:datetime) { double("datetime") }
  let(:deaths) { double("deaths") }
  let(:new_confirmed) { double("new_confirmed") }
  let(:new_deaths) { double("new_deaths") }
  let(:recovered) { double("recovered") }
  let(:tests) { double("tests") }

  subject(:stat) { described_class.new(args) }

  describe "#initialize" do
    context "properties" do
      it { is_expected.to be_kind_of described_class }
      it { expect(stat.confirmed).to eq confirmed }
      it { expect(stat.critical).to eq critical }
      it { expect(stat.datetime).to eq datetime }
      it { expect(stat.deaths).to eq deaths }
      it { expect(stat.new_confirmed).to eq new_confirmed }
      it { expect(stat.new_deaths).to eq new_deaths }
      it { expect(stat.recovered).to eq recovered }
      it { expect(stat.tests).to eq tests }
    end
  end

  describe "#active" do
    let(:confirmed) { 100 }
    let(:deaths) { 30 }
    let(:recovered) { 20 }

    subject { stat.active }
    context "all present" do
      it { is_expected.to eq 50 }
    end

    context "confirmed - blank" do
      let(:confirmed) { nil }
      it { is_expected.to be_nil }
    end

    context "deaths - blank" do
      let(:deaths) { nil }
      it { is_expected.to be_nil }
    end

    context "recovered - blank" do
      let(:recovered) { nil }
      it { is_expected.to be_nil }
    end
  end

  describe "#mortality_rate" do
    let(:confirmed) { 100 }
    let(:deaths) { 30 }

    subject { stat.mortality_rate }
    context "all present" do
      it { is_expected.to eq 30.0 }
    end

    context "confirmed - blank" do
      let(:confirmed) { nil }
      it { is_expected.to eq 0 }
    end

    context "deaths - blank" do
      let(:deaths) { nil }
      it { is_expected.to eq 0 }
    end

    context "confirmed - zero" do
      let(:confirmed) { 0 }
      it { is_expected.to eq 0 }
    end

    context "deaths - zero" do
      let(:deaths) { 0 }
      it { is_expected.to eq 0 }
    end
  end

  describe "#recovery_rate" do
    let(:confirmed) { 100 }
    let(:recovered) { 30 }

    subject { stat.recovery_rate }
    context "all present" do
      it { is_expected.to eq 30.0 }
    end

    context "confirmed - blank" do
      let(:confirmed) { nil }
      it { is_expected.to eq 0 }
    end

    context "recovered - blank" do
      let(:recovered) { nil }
      it { is_expected.to eq 0 }
    end

    context "confirmed - zero" do
      let(:confirmed) { 0 }
      it { is_expected.to eq 0 }
    end

    context "recovered - zero" do
      let(:recovered) { 0 }
      it { is_expected.to eq 0 }
    end
  end

  describe ".from_bing_response" do
    let(:args) do
      {
        confirmed: 200,
        deaths: 400,
        new_confirmed: 100,
        new_deaths: 300,
        recovered: 500
      }
    end
    let(:response) do
      {
        totalConfirmedDelta: 100,
        totalConfirmed: 200,
        totalDeathsDelta: 300,
        totalDeaths: 400,
        totalRecovered: 500
      }
    end

    subject { described_class.from_bing_response(response) }

    it "is expected to create stat with args" do
      expect(described_class).to receive(:new).with(args) { "Stat Data" }

      expect(subject).to eq "Stat Data"
    end
  end

  describe ".from_ninja_response" do
    let(:args) do
      {
        cases: 100,
        test: "Test Property for merge",
        todayCases: 200,
        todayDeaths: 300,
        updated: "Updated Time",
        confirmed: 100,
        datetime: "DateTime Converted",
        new_confirmed: 200,
        new_deaths: 300
      }
    end
    let(:response) do
      {
        cases: 100,
        test: "Test Property for merge",
        todayCases: 200,
        todayDeaths: 300,
        updated: updated
      }
    end
    let(:updated) { "Updated Time" }

    subject { described_class.from_ninja_response(response) }

    it "is expected to create stat with args" do
      expect(DateTime).to receive(:strptime).with(updated, "%Q") { "DateTime Converted" }
      expect(described_class).to receive(:new).with(args) { "Stat Data" }

      expect(subject).to eq "Stat Data"
    end
  end

  describe ".from_ninja_timeseries_response" do
    let(:args) { { cases: 100, confirmed: 100, test: "Test Property for merge"} }
    let(:response) { { cases: 100, test: "Test Property for merge" } }

    subject { described_class.from_ninja_timeseries_response(response) }

    it "is expected to create stat with args" do
      expect(described_class).to receive(:new).with(args) { "Stat Data" }

      expect(subject).to eq "Stat Data"
    end
  end
end
