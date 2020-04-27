require "rails_helper"

describe RegionsPresenter do

  describe ".scalar" do
    let(:alpha2) { "Alpha2 Test" }
    let(:alpha3) { "Alpha3 Test" }
    let(:country_flag) { true }
    let(:object) do
      double(
        :object,
        alpha2: alpha2,
        alpha3: alpha3,
        name: name,
        unofficial_names: unofficial_names
      )
    end
    let(:locals) { {} }
    let(:name) { "Name" }
    let(:presenter) { described_class::Scalar.new(object, view_context, locals) }
    let(:unofficial_names) { ["U Name1, U Name2"] }

    before :each do
      allow(object).to receive(:country?) { country_flag }
    end

    describe "#dropdown_country_data" do
      subject { presenter.dropdown_country_data }

      context "not country" do
        let(:country_flag) { false }
        it { is_expected.to be_nil }
      end

      context "country" do
        it "expect to return country related information" do
          array = [
            "Name",
            "Alpha3 Test",
            {
              "data-lookup": "Alpha2 Test, Alpha3 Test, U Name1, U Name2",
              "data-alpha2": "Alpha2 Test"
            }
          ]
          expect(subject).to match_array array
        end
      end
    end

    describe "#formatted_chart_name" do
      let(:name) { "ABC'D" }

      subject { presenter.formatted_chart_name }

      it { is_expected.to eq "ABCD" }
    end

    describe "#formatted_country_name_with_link" do
      subject { presenter.formatted_country_name_with_link }

      before :each do
        expect(presenter).to receive(:formatted_name) { "formatted_name" }
      end

      context "not country" do
        let(:country_flag) { false }
        it "expect to return formatted_name" do
          expect(subject).to eq "formatted_name"
        end
      end

      context "is a country" do
        it "expect to return a link" do
          expect(view_context).to receive(:corona_country_path).with(code: alpha3) { "link" }
          expect(view_context).to receive(:link_to).with("formatted_name", "link") { "link_with_name" }

          expect(subject).to eq "link_with_name"
        end
      end
    end

    describe "#formatted_name" do
      let(:name) { "1 2 3 4 5 6" }

      subject { presenter.formatted_name }

      it "expect to return truncated name" do
        expect(subject).to eq "1 2 3 4 5..."
      end
    end

    describe "#formatted_unofficial_names" do
      subject { presenter.formatted_unofficial_names }

      context "without unoffical names" do
        let(:unofficial_names) { nil }

        it { is_expected.to be_nil }
      end

      context "with unofficial_names" do
        it { is_expected.to eq "U Name1, U Name2" }
      end
    end

    describe "map_data_for_country" do
      subject { presenter.map_data_for_country }

      context "not a country" do
        let(:country_flag) { false }

        it { is_expected.to be_nil }
      end

      context "country" do
        it "expect to return map related data" do
          expect(presenter).to receive(:formatted_chart_name) { "formatted_chart_name" }

          result = subject
          expect(result).to include(alpha3: "Alpha3 Test")
          expect(result).to include(code: "Alpha2 Test")
          expect(result).to include(name: "formatted_chart_name")
        end
      end
    end

    describe "#map_data_for_state" do
      subject { presenter.map_data_for_state }

      it { is_expected.to include(name: name) }
    end
  end

  describe ".enum" do
    let(:country_data_abc) { double(:country_data_abc) }
    let(:country_data_xyz) { double(:country_data_xyz) }
    let(:object_abc) { double(:object_abc) }
    let(:object_xyz) { double(:object_xyz) }
    let(:object_for_enum) { [object_xyz, object_abc] }
    let(:object_presenter_abc) { double(:object_presenter_abc, name: "ABC") }
    let(:object_presenter_xyz) { double(:object_presenter_xyz, name: "XYZ") }
    let(:locals) { {} }
    let(:presenter) { described_class::Enum.new(object_for_enum, view_context, locals) }

    before :each do
      allow(described_class).to receive(:present).with(object_xyz, anything, anything) { object_presenter_xyz }
      allow(described_class).to receive(:present).with(object_abc, anything, anything) { object_presenter_abc }
    end

    describe "#for_select" do
      let(:map_data) { double(:map_data) }

      subject { presenter.for_select }
      it "expect to return for_select data" do
        expect(object_presenter_xyz).to receive(:dropdown_country_data) { country_data_xyz }
        expect(object_presenter_abc).to receive(:dropdown_country_data) { country_data_abc }

        expect(subject).to match_array [country_data_abc, country_data_xyz]
      end
    end
  end
end
