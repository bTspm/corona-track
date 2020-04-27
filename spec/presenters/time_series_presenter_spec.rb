require "rails_helper"

describe TimeSeriesPresenter do
  describe ".scalar" do
    let(:active) { double(:active) }
    let(:confirmed) { double(:confirmed) }
    let(:deaths) { double(:deaths) }
    let(:locals) { {} }
    let(:mortality_rate) { double(:mortality_rate) }
    let(:object) { double(:object, stats: stats) }
    let(:presenter) { described_class::Scalar.new(object, view_context, locals) }
    let(:recovered) { double(:recovered) }
    let(:recovery_rate) { double(:recovery_rate) }
    let(:stats) { double(:stats) }
    let(:stats_chart_data) do
      {
        active: active,
        confirmed: confirmed,
        deaths: deaths,
        mortality_rate: mortality_rate,
        recovered: recovered,
        recovery_rate: recovery_rate
      }
    end
    let(:stats_presenter) { double(:stats_presenter) }

    before :each do
      allow(StatsPresenter).to receive(:present).with(stats, view_context) { stats_presenter }
      allow(stats_presenter).to receive(:chart_data) { stats_chart_data }
    end

    describe "#mortality_vs_recovery_chart_data" do
      subject { presenter.mortality_vs_recovery_chart_data }

      context "without stats" do
        let(:stats) { nil }
        it { is_expected.to be_nil }
      end

      context "with stats" do
        it "expect to return an array with mortality and recovery rate" do
          mortality_rate_details = {
            color: "#dc3545",
            data: mortality_rate,
            name: "Mortality Rate",
            tooltip: { valueSuffix: " %" },
            type: "column"
          }

          recovery_rate_details = {
            color: "#28a745",
            data: recovery_rate,
            name: "Recovery Rate",
            tooltip: { valueSuffix: " %" },
            type: "column"
          }

          expect(subject).to match_array [mortality_rate_details, recovery_rate_details]
        end
      end
    end

    describe "#time_series_chart_data" do
      subject { presenter.time_series_chart_data }

      context "without stats" do
        let(:stats) { nil }
        it { is_expected.to be_nil }
      end

      context "with stats" do
        it "expect to return an array with active, confirmed, deaths, recoveries" do
          active_details = { color: "#ffc107", data: active, name: "Active" }
          confirmed_details = { color: "#17a2b8", data: confirmed, name: "Confirmed" }
          deaths_details = { color: "#dc3545", data: deaths, name: "Deaths" }
          recovered_details = { color: "#28a745", data: recovered, name: "Recoveries" }

          expect(subject).to match_array [active_details, confirmed_details, deaths_details, recovered_details]
        end
      end
    end
  end
end
