require "spec_helper"
require "./lib/breadbox/client_builder"
require "./lib/breadbox/configuration"

module Breadbox
  describe ClientBuilder do
    let(:builder)       { ClientBuilder.new(configuration) }
    let(:configuration) { Breadbox::Configuration.new }

    it "initializes with a configuration object" do
      expect(builder.configuration).to eq configuration
    end

    describe "#build" do
      let(:configuration) { Breadbox::Configuration.new }

      context "for a dropbox client" do
        before { configuration.provider = :dropbox }

        it "will delegate to a Breadbox::DropBoxClient" do
          expect(Breadbox::DropboxClient).to receive(:new).with(configuration)
          builder.build
        end
      end

      context "for an s3 client" do
        before { configuration.provider = :s3 }

        it "will delegate to a Breadbox::AwsClient" do
          expect(Breadbox::S3Client).to receive(:new).with(configuration)
          builder.build
        end
      end

      context "configuration provider is not valid (nil, empty, etc)" do
        it "will raise a MissingBreadboxProvider error" do
          expect { builder.build }.to raise_error MissingBreadboxProvider
        end
      end

      context "without a configuration" do
        let(:configuration) { nil }

        it "will raise a MissingBreadboxProvider error" do
          expect { builder.build }.to raise_error MissingBreadboxProvider
        end
      end
    end

    describe "::build" do
      it "delegates to an instance of itself, and calls #build" do
        builder = instance_double(ClientBuilder)
        allow(ClientBuilder).to receive(:new).with(configuration)
                                             .and_return(builder)
        expect(builder).to receive(:build)

        ClientBuilder.build(configuration)
      end
    end
  end
end
