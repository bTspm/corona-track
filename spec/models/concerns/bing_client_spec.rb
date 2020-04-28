require "rails_helper"

describe Api::BingClient do
  let!(:client) { described_class.new }
  let!(:faraday_object) { double(:faraday_object) }

  before :each do
    allow(Faraday).to receive(:new) { faraday_object }
  end

  describe "#country_stats" do
    subject { client.country_stats }

    it "expect to get country stats" do
      expect(client).to receive(:fetch_cached).with("Api::BingClient/country_stats").and_call_original
      allow(client).to receive(:get).with("https://bing.com/covid/data") { "Country Stats" }

      expect(subject).to eq "Country Stats"
    end
  end
end
