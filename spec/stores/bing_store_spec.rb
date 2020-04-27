require "rails_helper"

describe BingStore do
  let!(:bing_client) { double(:bing_client) }
  let!(:response) { double(:response, body: response_body) }
  let!(:response_body) { double(:response_body) }
  let!(:store) { described_class.new }

  before :each do
    allow(Api::BingClient).to receive(:new) { bing_client }
  end

  describe "#latest_country_stats_by_country_code" do
    let(:code) { double(:code) }

    subject { store.latest_state_stats_by_country_code(code) }

    it "expect to return latest_country_stats_by_country_code" do
      expect(bing_client).to receive(:country_stats) { response }
      expect(
        CoronaData
      ).to receive(:from_bing_global_response).with(code: code, response: response_body) { "Latest Country Stats" }

      expect(subject).to eq "Latest Country Stats"
    end
  end
end
