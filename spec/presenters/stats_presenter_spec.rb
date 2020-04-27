require "rails_helper"

describe StatsPresenter do
  describe ".scalar" do
    let(:active) { 100_000 }
    let(:confirmed) { 200_000 }
    let(:critical) { 500_000 }
    let(:datetime) { DateTime.new(2020, 0o1, 0o1) }
    let(:deaths) { 300_000 }
    let(:locals) { {} }
    let(:mortality_rate) { 150.000 }
    let(:new_confirmed) { 600_000 }
    let(:new_deaths) { 700_000 }
    let(:object) do
      double(
        :object,
        active: active,
        confirmed: confirmed,
        critical: critical,
        datetime: datetime,
        deaths: deaths,
        mortality_rate: mortality_rate,
        new_confirmed: new_confirmed,
        new_deaths: new_deaths,
        recovered: recovered,
        recovery_rate: recovery_rate,
        tests: tests
      )
    end
    let(:presenter) { described_class::Scalar.new(object, view_context, locals) }
    let(:recovered) { 400_000 }
    let(:recovery_rate) { 25.00 }
    let(:stats) { double(:stats) }
    let(:stats_presenter) { double(:stats_presenter) }
    let(:tests) { 800_000 }

    before :each do
      allow(StatsPresenter).to receive(:present).with(stats, view_context) { stats_presenter }
      allow(stats_presenter).to receive(:chart_data) { stats_chart_data }
    end

    describe "#chart_formatted_date" do
      subject { presenter.chart_formatted_date }
      it { is_expected.to eq 1_577_836_800_000 }
    end

    describe "formatted_last_updated" do
      subject { presenter.formatted_last_updated }

      context "without date" do
        let(:datetime) { nil }

        it { is_expected.to eq "" }
      end

      context "with date" do
        let(:datetime) { DateTime.now - 1.day }

        it { is_expected.to eq "Last Updated: 1 day ago" }
      end
    end

    describe "#map_data" do
      subject { presenter.map_data }

      it "expect to return a hash with map_data" do
        result = subject
        expect(result).to include(active: "100,000")
        expect(result).to include(confirmed: "200,000")
        expect(result).to include(deaths: "300,000")
        expect(result).to include(recovered: "400,000")
        expect(result).to include(value: confirmed)
      end
    end

    describe "#map_data_for_state" do
      subject { presenter.map_data_for_state }

      it "expect to return a hash with map_data_for_state" do
        result = subject
        expect(result).to include(confirmed: "200,000")
        expect(result).to include(deaths: "300,000")
        expect(result).to include(recovered: "400,000")
        expect(result).to include(value: confirmed)
      end
    end

    describe "readable_confirmed" do
      subject { presenter.readable_confirmed }

      context "without confirmed" do
        let(:confirmed) { nil }

        it { is_expected.to eq "" }
      end

      context "with confirmed" do
        it { is_expected.to eq "200,000" }
      end
    end

    describe "readable_critical" do
      subject { presenter.readable_critical }

      context "without critical" do
        let(:critical) { nil }

        it { is_expected.to eq "" }
      end

      context "with critical" do
        it { is_expected.to eq "500,000" }
      end
    end

    describe "readable_deaths" do
      subject { presenter.readable_deaths }

      context "without deaths" do
        let(:deaths) { nil }

        it { is_expected.to eq "" }
      end

      context "with deaths" do
        it { is_expected.to eq "300,000" }
      end
    end

    describe "readable_mortality_rate" do
      subject { presenter.readable_mortality_rate }

      context "without mortality_rate" do
        let(:mortality_rate) { nil }

        it { is_expected.to eq "" }
      end

      context "with mortality_rate" do
        it { is_expected.to eq "150.00%" }
      end
    end

    describe "#readable_new_confirmed" do
      subject { presenter.readable_new_confirmed }

      context "without new_confirmed" do
        let(:new_confirmed) { nil }

        it { is_expected.to eq "" }
      end

      context "with new_confirmed" do
        it { is_expected.to eq "+600,000" }
      end
    end

    describe "#readable_new_deaths" do
      subject { presenter.readable_new_deaths }

      context "without new_deaths" do
        let(:new_deaths) { nil }

        it { is_expected.to eq "" }
      end

      context "with new_deaths" do
        it { is_expected.to eq "+700,000" }
      end
    end

    describe "readable_recovered" do
      subject { presenter.readable_recovered }

      context "without recovered" do
        let(:recovered) { nil }

        it { is_expected.to eq "" }
      end

      context "with recovered" do
        it { is_expected.to eq "400,000" }
      end
    end

    describe "readable_tests" do
      subject { presenter.readable_tests }

      context "without tests" do
        let(:tests) { nil }

        it { is_expected.to eq "" }
      end

      context "with tests" do
        it { is_expected.to eq "800,000" }
      end
    end

    describe "#pie_chart_data" do
      subject { presenter.pie_chart_data.first }

      it "expect to return array with data" do
        active_details = { color: "#ffc107", name: "Active", y: active }
        deaths_details = { color: "#dc3545", name: "Deaths", y: deaths }
        recovered_details = { color: "#28a745", name: "Recovered", y: recovered }

        result = subject

        expect(result).to include(name: "Cases")
        expect(result).to include(colorByPoint: true)
        expect(result).to include(data: [active_details, deaths_details, recovered_details])
      end
    end

    describe "#time_series_chart_data" do
      subject { presenter.time_series_chart_data }

      it "expect to return array with data" do
        expect(presenter).to receive(:chart_formatted_date).exactly(6).times.and_call_original

        result = [
          [1577836800000, 200000],
          [1577836800000, 400000],
          [1577836800000, 300000],
          [1577836800000, 100000],
          [1577836800000, 150.0],
          [1577836800000, 25.0]
        ]
        expect(subject).to eq result
      end
    end
  end

  describe ".enum" do
    let(:object_abc) { double(:object_abc) }
    let(:object_xyz) { double(:object_xyz) }
    let(:object_for_enum) { [object_abc, object_xyz] }
    let(:object_presenter_abc) { double(:object_presenter_abc) }
    let(:object_presenter_xyz) { double(:object_presenter_xyz) }
    let(:locals) { {} }
    let(:presenter) { described_class::Enum.new(object_for_enum, view_context, locals) }

    before :each do
      allow(described_class).to receive(:present).with(object_abc, anything, anything) { object_presenter_abc }
      allow(described_class).to receive(:present).with(object_xyz, anything, anything) { object_presenter_xyz }
    end

    describe "#chart_data" do
      let(:time_series_chart_data_abc) do
        %w[
          confirmed_abc
          recovered_abc
          deaths_abc
          active_abc
          mortality_rate_abc
          recovery_rate_abc
        ]
      end
      let(:time_series_chart_data_xyz) do
        %w[
          confirmed_xyz
          recovered_xyz
          deaths_xyz
          active_xyz
          mortality_rate_xyz
          recovery_rate_xyz
        ]
      end
      subject { presenter.chart_data }

      it "expect to return chart data" do
        expect(object_presenter_abc).to receive(:time_series_chart_data) { time_series_chart_data_abc }
        expect(object_presenter_xyz).to receive(:time_series_chart_data) { time_series_chart_data_xyz }

        result = subject
        expect(result).to include(confirmed: %w[confirmed_abc confirmed_xyz])
        expect(result).to include(recovered: %w[recovered_abc recovered_xyz])
        expect(result).to include(deaths: %w[deaths_abc deaths_xyz])
        expect(result).to include(active: %w[active_abc active_xyz])
        expect(result).to include(mortality_rate: %w[mortality_rate_abc mortality_rate_xyz])
        expect(result).to include(recovery_rate: %w[recovery_rate_abc recovery_rate_xyz])
      end
    end
  end
end
