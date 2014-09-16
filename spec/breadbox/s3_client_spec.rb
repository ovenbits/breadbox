require "spec_helper"
require "./lib/breadbox/s3_client"
require "./lib/breadbox/configuration"

module Breadbox
  describe S3Client do
    let(:configuration) { Breadbox::Configuration.new }

    before {
      configuration.s3_bucket            = "my-bucket"
      configuration.s3_access_key_id     = "12345"
      configuration.s3_secret_access_key = "abc123"
    }

    it "is a Breadbox::Client" do
      expect(S3Client).to be < Breadbox::Client
    end

    describe "without valid configuration settings" do
      it "raises a MissingS3Bucket error without a bucket" do
        configuration.s3_bucket = nil
        expect {
          S3Client.new(configuration)
        }.to raise_error MissingS3Bucket
      end

      it "raises a MissingS3AccessKeyId error without a bucket" do
        configuration.s3_access_key_id = nil
        expect {
          S3Client.new(configuration)
        }.to raise_error MissingS3AccessKeyId
      end

      it "raises a MissingS3SecretAccessKey error without a bucket" do
        configuration.s3_secret_access_key = nil
        expect {
          S3Client.new(configuration)
        }.to raise_error MissingS3SecretAccessKey
      end

      it "raises a MissingS3Bucket if configuration is nil" do
        expect {
          S3Client.new(nil)
        }.to raise_error MissingS3Bucket
      end

      it "raises a MissingS3Bucket if no configuration" do
        expect {
          S3Client.new
        }.to raise_error MissingS3Bucket
      end
    end

    describe "with valid configuration settings" do
      it "assigns the AccessKeyId and SecretAccessKey to AWS::S3" do
        options = {
          access_key_id: configuration.s3_access_key_id,
          secret_access_key: configuration.s3_secret_access_key,
        }
        expect(AWS).to receive(:config).with(options)
        S3Client.new(configuration)
      end
    end

    describe "#s3_bucket_object" do
      it "returns a new bucket object from AWS::S3" do
        client = S3Client.new(configuration)
        bucket_object = client.s3_bucket_object
        expect(bucket_object).to be_kind_of AWS::S3::Bucket
      end
    end

    describe "#upload" do
      before { FileUtils.touch("./tmp/new-file.jpg") }
      after  { File.delete("./tmp/new-file.jpg") }

      let(:client) { S3Client.new(configuration) }

      it "writes a file to an S3 Bucket Object" do
        file    = File.open("./tmp/new-file.jpg")
        options = { acl: :public_read }
        expect_any_instance_of(AWS::S3::S3Object).to receive(:write)
                                                     .with(file, options)
        client.upload(path: "/", file: file, public: true)
      end
    end
  end
end
