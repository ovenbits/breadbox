require "spec_helper"

module Breadbox
  describe Client do
    it "should be a Dropbox client" do
      client = Client.new(token: "12345").client
      expect(client).to be_kind_of DropboxClient
    end

    it "should raise an exception if token is missing" do
      expect{ Client.new }.to raise_exception(MissingAccessToken)
    end

    it "should raise an exception if the token is empty" do
      expect{ Client.new(token: "") }.to raise_exception(MissingAccessToken)
    end

    describe "#upload" do
      before { FileUtils.touch("./tmp/new-file.jpg") }
      after  { File.delete("./tmp/new-file.jpg") }

      it "tells the client to put_file from a full_filepath and file" do
        file           = File.open("./tmp/new-file.jpg")
        client         = Client.new(token: "12345", root_path: "/")
        dropbox_client = instance_double(DropboxClient)
        allow(client).to receive(:client).and_return(dropbox_client)
        expect(dropbox_client).to receive(:put_file).with("/new-file.jpg", file)

        client.upload(path: "/", file: file)
      end

      it "tells the client to put_file from a full_filepath and file" do
        file           = File.open("./tmp/new-file.jpg")
        client         = Client.new(token: "12345", root_path: "/")
        dropbox_client = instance_double(DropboxClient)
        allow(client).to receive(:client).and_return(dropbox_client)
        expect(dropbox_client).to receive(:put_file).with("/images/new-file.jpg", file)

        client.upload(path: "images", file: file)
      end
    end
  end
end
