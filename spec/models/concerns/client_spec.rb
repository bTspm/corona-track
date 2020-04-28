require "rails_helper"

describe Api::Client do
  let(:client) { described_class.new }
  let(:stubs) do
    Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get(url) { |_env| [200, {}, response] }
    end
  end
  let(:test) do
    Faraday.new do |builder|
      builder.adapter :test, stubs
    end
  end

  before :each do
    allow(Faraday).to receive(:new).and_return(test)
  end

  describe "#get" do
    let(:url) { "example_url" }

    subject { client.get(url) }

    context "response as array" do
      let(:response) { [1, 2] }

      it "expect to parse response" do
        expect(subject).to eq [1, 2]
      end
    end

    context "response as hash" do
      let(:response) { { a: "b" } }

      it "expect to parse response" do
        expect(subject).to include(a: "b")
      end
    end

    context "response as string" do
      let(:response) { "test" }

      it "expect to parse response" do
        expect(subject).to eq "test"
      end
    end
  end
end
