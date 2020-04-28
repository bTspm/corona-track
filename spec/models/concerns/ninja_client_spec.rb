require "rails_helper"

describe Api::NinjaClient do
  let!(:client) { described_class.new }
  let!(:faraday_object) { double(:faraday_object) }

  before :each do
    allow(Faraday).to receive(:new) { faraday_object }
    expect(client).to receive(:fetch_cached).with(cache_key).and_call_original
  end

  describe "#country_time_series_by_country_code" do
    let(:cache_key) { "Api::NinjaClient/country_time_series_by_country_code/ABC" }
    let(:code) { "ABC" }

    subject { client.country_time_series_by_country_code(code) }

    it "expect to get Country Time Series" do
      expect(client).to receive(:get).with(
        "https://corona.lmao.ninja/v2/historical/ABC?lastdays=all"
      ) { "Country Time Series" }

      expect(subject).to eq "Country Time Series"
    end
  end

  describe "#global_time_series" do
    let(:cache_key) { "Api::NinjaClient/global_time_series" }

    subject { client.global_time_series }

    it "expect to get Global Time Series" do
      expect(client).to receive(:get).with(
        "https://corona.lmao.ninja/v2/historical?lastdays=all"
      ) { "Global Time Series" }

      expect(subject).to eq "Global Time Series"
    end
  end

  describe "#latest_countries_stats" do
    let(:cache_key) { "Api::NinjaClient/latest_countries_stats" }

    subject { client.latest_countries_stats }

    it "expect to get Latest Countries Stats" do
      expect(client).to receive(:get).with(
        "https://corona.lmao.ninja/v2/countries?sort=cases"
      ) { "Latest Countries Stats" }

      expect(subject).to eq "Latest Countries Stats"
    end
  end

  describe "#latest_country_stats_by_country_code" do
    let(:cache_key) { "Api::NinjaClient/latest_country_stats_by_country_code/ABC" }
    let(:code) { "ABC" }

    subject { client.latest_country_stats_by_country_code(code) }

    it "expect to get Latest Country Stats by country code" do
      expect(client).to receive(:get).with(
        "https://corona.lmao.ninja/v2/countries/ABC?strict=false"
      ) { "Latest Country Stats" }

      expect(subject).to eq "Latest Country Stats"
    end
  end

  describe "#latest_global_stats" do
    let(:cache_key) { "Api::NinjaClient/latest_global_stats" }

    subject { client.latest_global_stats }

    it "expect to get Global Time Series" do
      expect(client).to receive(:get).with("https://corona.lmao.ninja/v2/all") { "Latest Global Stats" }

      expect(subject).to eq "Latest Global Stats"
    end
  end
end
