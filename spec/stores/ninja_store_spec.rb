require "rails_helper"

describe NinjaStore do
  let!(:ninja_client) { double(:ninja_client) }
  let!(:response) { double(:response) }
  let!(:store) { described_class.new }

  before :each do
    allow(Api::NinjaClient).to receive(:new) { ninja_client }
  end

  describe "#countries_list" do
    subject { store.countries_list }

    it "expect to return all countries" do
      expect(ninja_client).to receive(:latest_countries_stats) { response }
      expect(RegionData).to receive(:from_countries_ninja_response).with(response) { "Region" }

      expect(subject).to eq "Region"
    end
  end

  describe "#country_time_series_by_country_code" do
    let(:code) { double(:code) }

    subject { store.country_time_series_by_country_code(code) }

    it "expect to return time series for a country" do
      expect(ninja_client).to receive(:country_time_series_by_country_code).with(code) { response }
      expect(TimeSeries).to receive(:from_country_ninja_response).with(response) { "Country Time Series" }

      expect(subject).to eq "Country Time Series"
    end
  end

  describe "#global_time_series" do
    subject { store.global_time_series }

    it "expect to return global_time_series" do
      expect(ninja_client).to receive(:global_time_series) { response }
      expect(TimeSeries).to receive(:from_global_ninja_response).with(response) { "Global Time Series" }

      expect(subject).to eq "Global Time Series"
    end
  end

  describe "#latest_countries_stats" do
    subject { store.latest_countries_stats }

    it "expect to return latest_countries_stats" do
      expect(ninja_client).to receive(:latest_countries_stats) { response }
      expect(CoronaData).to receive(:from_ninja_countries_response).with(response) { "Latest Countries Stats" }

      expect(subject).to eq "Latest Countries Stats"
    end
  end

  describe "#latest_country_stats_by_country_code" do
    let(:code) { double(:code) }

    subject { store.latest_country_stats_by_country_code(code) }

    it "expect to return latest_country_stats_by_country_code" do
      expect(ninja_client).to receive(:latest_country_stats_by_country_code).with(code) { response }
      expect(CoronaData).to receive(:from_ninja_country_response).with(response) { "Latest Country Stats" }

      expect(subject).to eq "Latest Country Stats"
    end
  end

  describe "#latest_global_stats" do
    subject { store.latest_global_stats }

    it "expect to return latest_countries_stats" do
      expect(ninja_client).to receive(:latest_global_stats) { response }
      expect(CoronaData).to receive(:from_ninja_global_response).with(response) { "Latest Global Stats" }

      expect(subject).to eq "Latest Global Stats"
    end
  end
end
