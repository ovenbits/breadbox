require "spec_helper"
require "./lib/breadbox/configuration"

module Breadbox
  describe Configuration do
    let(:config) { Configuration.new }

    describe "#root_path" do
      it "defaults to /breadbox" do
        expect(config.root_path).to eq "/"
      end
    end

    describe "#root_path=" do
      it "assigns a root directory" do
        new_dir = "/my-favorite-directory"
        config.root_path = new_dir
        expect(config.root_path).to eq new_dir
      end
    end

    describe "#s3_bucket" do
      it "defaults to nil" do
        expect(config.s3_bucket).to be nil
      end
    end

    describe "#s3_access_key_id" do
      it "defaults to nil" do
        expect(config.s3_access_key_id).to be nil
      end
    end

    describe "#s3_access_key_id=" do
      it "assigns the bucket" do
        access_key_id = "my-access_key_id"
        config.s3_access_key_id = access_key_id
        expect(config.s3_access_key_id).to eq access_key_id
      end
    end

    describe "#s3_secret_access_key" do
      it "defaults to nil" do
        expect(config.s3_secret_access_key).to be nil
      end
    end

    describe "#s3_secret_access_key=" do
      it "assigns the bucket" do
        secret_access_key = "my-secret_access_key"
        config.s3_secret_access_key = secret_access_key
        expect(config.s3_secret_access_key).to eq secret_access_key
      end
    end

    describe "#s3_bucket=" do
      it "assigns the bucket" do
        bucket = "my-bucket"
        config.s3_bucket = bucket
        expect(config.s3_bucket).to eq bucket
      end
    end

    describe "#dropbox_access_token" do
      it "defaults to nil" do
        expect(config.dropbox_access_token).to eq nil
      end
    end

    describe "#dropbox_access_token=" do
      it "assigns the access token" do
        access_token = "12345"
        config.dropbox_access_token = access_token
        expect(config.dropbox_access_token).to eq access_token
      end
    end

    describe "#provider" do
      it "defaults to nil" do
        expect(config.provider).to eq nil
      end
    end

    describe "#provider=" do
      it "assigns the provider" do
        provider        = :dropbox
        config.provider = provider
        expect(config.provider).to eq provider
      end

      it "requires the provider to be in the available providers" do
        providers = [:aws, :dropbox]
        allow(config).to receive(:available_providers).and_return(providers)

        expect {
          config.provider = :not_in_the_list
        }.to raise_error InvalidBreadboxProvider
      end
    end
  end
end
