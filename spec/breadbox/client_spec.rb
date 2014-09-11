require "spec_helper"
require "./lib/breadbox/client"

module Breadbox
  describe Client do
    let(:configuration) { double }

    describe "#initialize" do
      it "initializes with a configuration" do
        client = Client.new(configuration)
        expect(client.configuration).to eq configuration
      end

      it "configuration defaults to a NullConfiguration" do
        client = Client.new
        expect(client.configuration).to be_kind_of NullConfiguration
      end
    end

    describe "#client" do
      it "is not defined on this class" do
        client = Client.new
        expect { client.client }.to raise_error NotImplementedError
      end
    end

    describe "#upload" do
      it "is not defined on this class" do
        client = Client.new
        expect { client.upload }.to raise_error NotImplementedError
      end
    end
  end
end
