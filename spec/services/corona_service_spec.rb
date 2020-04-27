require "rails_helper"

describe CoronaService do
  let!(:bing_store) { double(:bing_store) }
  let!(:ninja_store) { double(:ninja_store) }
  let!(:service) { described_class.new }

  before :each do
    allow(BingStore).to receive(:new) { bing_store }
    allow(NinjaStore).to receive(:new) { ninja_store }
  end

  describe "#countries_list" do
    let(:not_country) { double(:not_country, country?: false) }
    let(:countries) { [country, not_country] }
    let(:country) { double(:country, country?: true) }

    subject { service.countries_list }

    it "expect to return all countries" do
      expect(ninja_store).to receive(:countries_list) { countries }

      expect(subject).to match_array [country]
    end
  end

  describe "#country_time_series_by_country_code" do
    let(:code) { double(:code) }

    subject { service.country_time_series_by_country_code(code) }

    it "expect to return time series for a country" do
      expect(ninja_store).to receive(:country_time_series_by_country_code).with(code) { "Time Series" }

      expect(subject).to eq "Time Series"
    end
  end

  describe "#global_time_series" do
    subject { service.global_time_series }

    it "expect to return global_time_series" do
      expect(ninja_store).to receive(:global_time_series) { "Global Time Series" }

      expect(subject).to eq "Global Time Series"
    end
  end

  describe "#latest_countries_stats" do
    subject { service.latest_countries_stats }

    it "expect to return latest_countries_stats" do
      expect(ninja_store).to receive(:latest_countries_stats) { "Latest Countries Stats" }

      expect(subject).to eq "Latest Countries Stats"
    end
  end

  describe "#latest_country_stats_by_country_code" do
    let(:code) { double(:code) }

    subject { service.latest_country_stats_by_country_code(code) }

    it "expect to return latest_country_stats_by_country_code" do
      expect(ninja_store).to receive(:latest_country_stats_by_country_code).with(code) { "Latest Country Stats" }

      expect(subject).to eq "Latest Country Stats"
    end
  end

  describe "#latest_global_stats" do
    subject { service.latest_global_stats }

    it "expect to return latest_countries_stats" do
      expect(ninja_store).to receive(:latest_global_stats) { "Latest Global Stats" }

      expect(subject).to eq "Latest Global Stats"
    end
  end

  describe "#latest_state_stats_by_country_code" do
    let(:code) { double(:code) }

    subject { service.latest_state_stats_by_country_code(code) }

    it "expect to return latest_country_stats_by_country_code" do
      expect(bing_store).to receive(:latest_state_stats_by_country_code).with(code) { "State Stats by Country" }

      expect(subject).to eq "State Stats by Country"
    end
  end
end
