require "spec_helper"
require "./lib/breadbox/configuration"
require "./lib/breadbox/dropbox_client"

module Breadbox
  describe DropboxClient do
    let(:configuration) { Breadbox::Configuration.new }

    before { configuration.dropbox_access_token = "12345" }

    it "is a Breadbox::Client" do
      expect(DropboxClient).to be < Breadbox::Client
    end

    describe "without valid configuration settings" do
      it "raises a MissingDropboxAccessToken error without a token" do
        configuration.dropbox_access_token = nil
        expect {
          DropboxClient.new(configuration)
        }.to raise_error MissingDropboxAccessToken
      end

      it "raises a MissingDropboxAccessToken if configuration is nil" do
        expect {
          DropboxClient.new(nil)
        }.to raise_error MissingDropboxAccessToken
      end

      it "raises a MissingDropboxAccessToken if not given a configuration" do
        expect {
          DropboxClient.new
        }.to raise_error MissingDropboxAccessToken
      end
    end

    describe "#client" do
      it "is a ::DropboxClient (from the Dropbox SDK) client" do
        client = DropboxClient.new(configuration).client
        expect(client).to be_kind_of ::DropboxClient
      end
    end

    describe "#update" do
      before { FileUtils.touch("./tmp/new-file.jpg") }
      after  { File.delete("./tmp/new-file.jpg") }

      let(:access_token)  { "12345" }
      let(:configuration) {
        config = Breadbox::Configuration.new
        config.provider = :dropbox
        config.dropbox_access_token = access_token
        config.root_path = "/"
        config
      }

      it "tells the client to put_file from a full_filepath and file" do
        file           = File.open("./tmp/new-file.jpg")
        client         = DropboxClient.new(configuration)
        dropbox_client = instance_double(::DropboxClient)
        allow(client).to receive(:client).and_return(dropbox_client)
        expect(dropbox_client).to receive(:put_file)
                                  .with("/new-file.jpg", file, false)

        client.upload(path: "/", file: file)
      end

      it "allows for a filename to be passed as an option" do
        file           = File.open("./tmp/new-file.jpg")
        client         = DropboxClient.new(configuration)
        dropbox_client = instance_double(::DropboxClient)
        allow(client).to receive(:client).and_return(dropbox_client)
        expect(dropbox_client).to receive(:put_file)
                                  .with("/my-cool-file.jpg", file, false)

        client.upload(path: "/", file: file, filename: "my-cool-file.jpg")
      end
    end
  end
end
