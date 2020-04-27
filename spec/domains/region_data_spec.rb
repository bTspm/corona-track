require "rails_helper"

describe RegionData do
  let(:args) do
    {
      alpha2: alpha2,
      alpha3: alpha3,
      name: name,
      parent: parent,
      unofficial_names: unofficial_names
    }
  end
  let(:alpha2) { double(:alpha2) }
  let(:alpha3) { double(:alpha3) }
  let(:hex_alpha2) { double(:hex_alpha2) }
  let(:hex_alpha3) { double(:hex_alpha3) }
  let(:hex_name) { double(:hex_name) }
  let(:hex_unofficial_names) { double(:hex_unofficial_names) }
  let(:hex_country) { double(:country, hex_args) }
  let(:hex_args) do
    {
      alpha2: hex_alpha2,
      alpha3: hex_alpha3,
      name: hex_name,
      unofficial_names: hex_unofficial_names
    }
  end
  let(:name) { double(:name) }
  let(:parent) { double(:parent) }
  let(:unofficial_names) { double(:unofficial_names) }

  before :each do
    allow(described_class).to receive(:_country_by_name_or_code) { hex_country }
  end

  subject(:region) { described_class.new(args) }

  describe "#initialize" do
    context "properties" do
      it { is_expected.to be_kind_of described_class }
      it { expect(region.alpha2).to eq alpha2 }
      it { expect(region.alpha3).to eq alpha3 }
      it { expect(region.name).to eq name }
      it { expect(region.parent).to eq parent }
      it { expect(region.unofficial_names).to eq unofficial_names }
    end
  end

  describe "#country?" do
    subject { region.country? }
    context "with alpha3" do
      it { is_expected.to be_truthy }
    end

    context "alpha 3 as nil" do
      let(:alpha3) { nil }
      it { is_expected.to be_falsey }
    end
  end

  describe "#global?" do
    subject { region.global? }
    context "not global" do
      it { is_expected.to be_falsey }
    end

    context "name is global" do
      let(:name) { "Global" }
      it { is_expected.to be_truthy }
    end
  end

  describe "#state_stats?" do
    let(:country_flag) { true }
    before :each do
      expect(region).to receive(:country?) { country_flag }
    end

    subject { region.state_stats? }

    context "not a country" do
      let(:country_flag) { false }
      it { is_expected.to be_falsey }
    end

    context "without alpha2" do
      let(:alpha2) { nil }
      let(:country_flag) { false }

      it { is_expected.to be_falsey }
    end

    context "is a country and with alpha2" do
      let(:alpha2) { "US" }
      let(:country_flag) { true }

      it { is_expected.to be_truthy }
    end
  end

  describe "#india?" do
    subject { region.india? }

    context "not India code" do
      let(:alpha3) { "ABC" }
      it { is_expected.to be_falsey }
    end

    context "with India code" do
      let(:alpha3) { "IND" }
      it { is_expected.to be_truthy }
    end
  end

  describe "#south_korea?" do
    subject { region.south_korea? }

    context "not South Korea code" do
      let(:alpha3) { "ABC" }
      it { is_expected.to be_falsey }
    end

    context "with South Korea code" do
      let(:alpha3) { "KOR" }
      it { is_expected.to be_truthy }
    end
  end

  describe ".from_bing_state_response" do
    let(:code) { alpha2 }
    let(:parent_country) { double(:parent_country) }
    let(:response) { { displayName: state_name } }
    let(:south_korea_flag) { false }
    let(:state_code) { double(:state_code) }
    let(:state_info) { double(:state_info, name: state_info_name) }
    let(:state_info_name) { state_name }
    let(:state_name) { "ABCDEF" }

    subject { described_class.from_bing_state_response(code: code, response: response) }

    before :each do
      expect(described_class).to receive(:from_hex_country).with(hex_country) { parent_country }
      expect(described_class).to receive(:_state_from_country_by_name).with(
        hex_country: hex_country,
        state_name: state_name
      ) { [state_code, state_info] }
      expect(parent_country).to receive(:south_korea?) { south_korea_flag }
      expect(described_class).to receive(:new).with(input_args) { "State Region" }
    end

    context "South Korea" do
      let(:input_args) { { alpha2: state_code, name: state_name, parent: parent_country } }
      let(:south_korea_flag) { true }

      it { is_expected.to eq "State Region" }
    end

    context "No state info" do
      let(:input_args) { { alpha2: state_code, name: state_name, parent: parent_country } }
      let(:state_info) { nil }

      it { is_expected.to eq "State Region" }
    end

    context "state matched" do
      context "with regex match" do
        let(:input_args) { { alpha2: state_code, name: "ABC", parent: parent_country } }
        let(:state_name) { "ABC (US)" }
        it { is_expected.to eq "State Region" }
      end

      context "regex not matched" do
        let(:input_args) { { alpha2: state_code, name: state_name, parent: parent_country } }
        it { is_expected.to eq "State Region" }
      end
    end
  end

  describe ".from_countries_ninja_response" do
    let(:country_response) { double(:country_response) }
    let(:response) { [country_response] }
    subject { described_class.from_countries_ninja_response(response) }

    it "expect to call from_ninja_response" do
      expect(described_class).to receive(:from_ninja_response).with(country_response) { "Country Response" }

      expect(subject).to match_array ["Country Response"]
    end
  end

  describe "#from_hex_country" do
    subject { described_class.from_hex_country(hex_country) }
    it "expect to create region with country args" do
      expect(described_class).to receive(:new).with(hex_args) { "Region" }

      expect(subject).to eq "Region"
    end
  end

  describe ".from_ninja_response" do
    let(:response) do
      {
        countryInfo: {
          iso2: alpha2,
          iso3: alpha3
        },
        country: name
      }.with_indifferent_access
    end

    subject { described_class.from_ninja_response(response) }

    context "with hex_country" do
      it "expect to create region with country args" do
        expect(described_class).to receive(:new).with(hex_args) { "Region" }

        expect(subject).to eq "Region"
      end
    end

    context "without hex_country" do
      let(:hex_country) { nil }
      let(:input_args) do
        {
          alpha2: alpha2,
          alpha3: alpha3,
          name: name,
          unofficial_names: nil
        }
      end
      it "expect to create region with country args" do
        expect(described_class).to receive(:new).with(input_args) { "Region" }

        expect(subject).to eq "Region"
      end
    end
  end

  describe ".global" do
    subject { described_class.global }
    it "is expected to create region as global" do
      expect(described_class).to receive(:new).with({ name: "Global" }) { "Global region" }

      expect(subject).to eq "Global region"
    end
  end
end
