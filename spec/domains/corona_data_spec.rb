require 'rails_helper'

describe CoronaData do
  let(:args) { { region_data: region_data, stats: stats } }
  let(:region_data) { double(:region_data) }
  let(:stats) { double(:stats) }

  subject(:corona_data) { described_class.new(args) }

  describe "#initialize" do
    context "properties" do
      it { is_expected.to be_kind_of described_class }
      it { expect(corona_data.region_data).to eq region_data }
      it { expect(corona_data.stats).to eq stats }
    end
  end

  describe ".from_bing_global_response" do
    let(:code) { "us" }
    let(:state_response) { response[:areas].first[:areas].first.except(:areas).with_indifferent_access }
    let!(:response) { json_fixture("bing_data/global_response.json") }

    subject { described_class.from_bing_global_response(code: code, response: response) }

    it "is expected to create corona_data with state and stats data" do
      expect(
        RegionData
      ).to receive(:from_bing_state_response).with(code: code, response: state_response) { "State Data" }
      expect(Stat).to receive(:from_bing_response).with(state_response) { "Stats Data" }
      expect(
        described_class
      ).to receive(:new).with({ region_data: "State Data", stats: "Stats Data" }) { "State or Province Data" }

      expect(subject).to match_array ["State or Province Data"]
    end
  end

  describe ".from_ninja_countries_response" do
    let(:country) { double(:country) }
    let(:response) { [country] }

    subject { described_class.from_ninja_countries_response(response) }

    it "is expected to call from_ninja_country_response" do
      expect(described_class).to receive(:from_ninja_country_response).with(country) { "Country" }

      expect(subject).to match_array ["Country"]
    end
  end

  describe ".from_ninja_country_response" do
    let(:country) { double(:country) }
    let(:response) { country }

    subject { described_class.from_ninja_country_response(response) }

    it "is expected to call create corona_data with stats and country data" do
      expect(RegionData).to receive(:from_ninja_response).with(response) { "Region" }
      expect(Stat).to receive(:from_ninja_response).with(response) { "Stat" }
      expect(described_class).to receive(:new).with({ region_data: "Region", stats: "Stat" }) { "Corona Data" }

      expect(subject).to eq "Corona Data"
    end
  end

  describe ".from_ninja_global_response" do
    let(:global) { double(:global) }
    let(:response) { global }

    subject { described_class.from_ninja_global_response(response) }

    it "is expected to call create corona_data with stats and global data" do
      expect(RegionData).to receive(:global) { "Global" }
      expect(Stat).to receive(:from_ninja_response).with(response) { "Stat" }
      expect(described_class).to receive(:new).with({ region_data: "Global", stats: "Stat" }) { "Corona Data" }

      expect(subject).to eq "Corona Data"
    end
  end
end
