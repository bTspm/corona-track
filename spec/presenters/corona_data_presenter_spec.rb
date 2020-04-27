require "rails_helper"

describe CoronaDataPresenter do

  describe ".scalar" do
    let(:object) { double(:object, region_data: region_data, stats: stats) }
    let(:locals) { {} }
    let(:presenter) { described_class::Scalar.new(object, view_context, locals) }
    let(:region_data) { double(:region_data) }
    let(:region_presenter) { double(:region_presenter) }
    let(:region_map_data) { { region: "Region" } }
    let(:stats) { double(:stats) }
    let(:stats_presenter) { double(:stats_presenter) }
    let(:stats_map_data) { { stats: "Test" } }

    before :each do
      allow(RegionsPresenter).to receive(:present).with(region_data, anything) { region_presenter }
      allow(StatsPresenter).to receive(:present).with(stats, anything) { stats_presenter }
    end

    describe "#map_data_for_state" do
      subject { presenter.map_data_for_state }
      it "expect to call region map data and stats map data" do
        expect(region_presenter).to receive(:map_data_for_state) { region_map_data }
        expect(stats_presenter).to receive(:map_data_for_state) { stats_map_data }

        expect(subject).to include(region_map_data, stats_map_data)
      end
    end

    describe "#map_data" do
      let(:country_flag) { true }

      subject { presenter.map_data }

      before :each do
        expect(region_presenter).to receive(:country?) { country_flag }
      end

      context "not country" do
        let(:country_flag) { false }
        it { is_expected.to be_nil }
      end

      context "is a country" do
        it "expect to return region map data for country and stats map data" do
          expect(region_presenter).to receive(:map_data_for_country) { region_map_data }
          expect(stats_presenter).to receive(:map_data) { stats_map_data }

          expect(subject).to include(region_map_data, stats_map_data)
        end
      end
    end

    describe "#region_data" do
      subject { presenter.region_data }

      it { is_expected.to eq region_presenter }
    end

    describe "#stats" do
      subject { presenter.stats }

      it { is_expected.to eq stats_presenter }
    end
  end

  describe ".enum" do
    let(:object) { double(:object, map_data_for_state: state_data) }
    let(:object_for_enum) { [object] }
    let(:object_presenter) { double(:object_presenter) }
    let(:locals) { {} }
    let(:presenter) { described_class::Enum.new(object_for_enum, view_context, locals) }
    let(:state_data) { double(:state_data) }

    before :each do
      allow(described_class).to receive(:present).with(object, anything, anything) { object_presenter }
    end

    describe "#map_data_for_state" do
      let(:alpha2) { "AB" }
      let(:india_flag) { false }
      let(:parent_country) { double(:parent_country, alpha2: alpha2) }

      subject { presenter.map_data_for_state }

      before :each do
        expect(parent_country).to receive(:india?) { india_flag }
        expect(object_presenter).to receive(:map_data_for_state) { state_data }
        expect(object_presenter).to receive_message_chain(:region_data, :parent) { parent_country }
      end

      context "country - India" do
        let(:india_flag) { true }
        it "expect to return map data for state" do
          result = subject
          expect(result[:map_name]).to include "countries/in/custom/in-all-disputed"
          expect(result[:data]).to match_array [state_data]
        end
      end

      context "country - Not India" do
        it "expect to return map data for state" do
          result = subject
          expect(result[:map_name]).to include "countries/ab/ab-all"
          expect(result[:data]).to match_array [state_data]
        end
      end
    end

    describe "#map_data" do
      let(:map_data) { double(:map_data) }

      subject { presenter.map_data }
      it "expect to return map data" do
        expect(object_presenter).to receive(:map_data) { map_data }

        expect(subject).to match_array [map_data]
      end
    end
  end
end
