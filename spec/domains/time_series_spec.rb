require "rails_helper"

describe TimeSeries do
  describe "#initialize" do
    let(:args) { { stats: stats } }
    let(:stats) { double(:stats) }

    subject(:time_series) { described_class.new(args) }

    context "properties" do
      it { is_expected.to be_kind_of described_class }
      it { expect(time_series.stats).to eq stats }
    end
  end

  describe ".from_country_ninja_response" do
    let(:date) { "4/16/20" }
    let!(:response) { json_fixture("ninja_data/historical_country_response.json") }
    let(:stat_args) { { cases: 100, datetime: "DateTime Converted", deaths: 200, recovered: 300 } }
    let(:stat_data) { "Stat Data" }
    let(:time_series_args) { {stats: [stat_data]} }

    subject { described_class.from_country_ninja_response(response) }

    it "is expected to create time_series object with stats data" do
      expect(DateTime).to receive(:strptime).with(date, "%m/%d/%y") { "DateTime Converted" }
      expect(Stat).to receive(:from_ninja_timeseries_response).with(stat_args) { stat_data }
      expect(described_class).to receive(:new).with(time_series_args) { "Time Series" }

      expect(subject).to eq "Time Series"
    end
  end

  describe ".from_global_ninja_response" do
    let(:date) { "4/16/20" }
    let!(:response) { json_fixture("ninja_data/historical_global_response.json") }
    let(:stat_args) { { cases: 1100, datetime: "DateTime Converted", deaths: 2200, recovered: 3300 } }
    let(:stat_data) { "Stat Data" }
    let(:time_series_args) { {stats: [stat_data]} }

    subject { described_class.from_global_ninja_response(response) }

    it "is expected to create time_series object with stats data" do
      expect(DateTime).to receive(:strptime).with(date, "%m/%d/%y") { "DateTime Converted" }
      expect(Stat).to receive(:from_ninja_timeseries_response).with(stat_args) { stat_data }
      expect(described_class).to receive(:new).with(time_series_args) { "Time Series" }

      expect(subject).to eq "Time Series"
    end
  end
end
