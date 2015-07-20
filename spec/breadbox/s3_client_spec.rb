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

    describe "#s3_bucket_object" do
      it "returns a new bucket object from Aws::S3" do
        client = S3Client.new(configuration)
        bucket_object = client.s3_bucket_object
        expect(bucket_object).to be_kind_of Aws::S3::Bucket
      end
    end

    describe "#s3_client_object" do
      let(:credentials) { double(:credentials) }

      before do
        allow(Aws::Credentials).to receive(:new).with(
          configuration.s3_access_key_id,
          configuration.s3_secret_access_key,
        ).and_return(credentials)
      end

      it "initializes with the correct data" do
        expect(Aws::S3::Client).to receive(:new).with(
          region: configuration.s3_region,
          credentials: credentials
        )

        client = S3Client.new(configuration)
        client.s3_client_object
      end
    end

    describe "#upload" do
      before { FileUtils.touch("./tmp/new-file.jpg") }
      after  { File.delete("./tmp/new-file.jpg") }

      let(:client) { S3Client.new(configuration) }

      it "writes a file to an S3 Bucket Object" do
        file    = File.open("./tmp/new-file.jpg")
        options = { body: file, acl: :public_read, content_type: nil }
        expect_any_instance_of(Aws::S3::Object)
          .to receive(:put).with(options)

        client.upload(path: "/", file: file, public: true)
      end

      it "passes content-type parameter" do
        file    = File.open("./tmp/new-file.jpg")
        options = { body: file, acl: :private, content_type: "image/jpeg" }
        expect_any_instance_of(Aws::S3::Object)
          .to receive(:put).with(options)

        client.upload(path: "/", file: file, content_type: "image/jpeg")
      end

      it "defaults to private :acl" do
        file    = File.open("./tmp/new-file.jpg")
        options = { body: file, acl: :private, content_type: "image/jpeg" }
        expect_any_instance_of(Aws::S3::Object)
          .to receive(:put).with(options)

        client.upload(path: "/", file: file, public: nil, content_type: "image/jpeg")
      end

      it "passes path parameter" do
        file    = File.open("./tmp/new-file.jpg")
        bucket_object = client.s3_bucket_object.object("new-file.jpg")

        expect_any_instance_of(Aws::S3::Bucket).to receive(:object)
          .with("my-path/new-file.jpg").and_return(bucket_object)
        expect(bucket_object).to receive(:put)

        client.upload(path: "my-path", file: file, content_type: "image/jpeg")
      end

      it "passes filename parameter" do
        file    = File.open("./tmp/new-file.jpg")
        bucket_object = client.s3_bucket_object.object("my-cool-filename.jpg")

        expect_any_instance_of(Aws::S3::Bucket).to receive(:object)
          .with("my-cool-filename.jpg").and_return(bucket_object)
        expect(bucket_object).to receive(:put)

        client.upload(
          path: "/",
          file: file,
          filename: "my-cool-filename.jpg",
          content_type: "image/jpeg"
        )
      end
    end
  end
end
