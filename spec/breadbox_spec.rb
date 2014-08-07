require "spec_helper"

describe Breadbox do
  describe "#configure" do
    before do
      Breadbox.configure do |config|
        config.dropbox_access_token = "12345"
        config.root_path            = "/my-new-root"
      end
    end

    after { Breadbox.reset }

    it "returns the newly assigned token" do
      expect(Breadbox.configuration.dropbox_access_token).to eq "12345"
    end

    it "returns the newly assigned root" do
      expect(Breadbox.configuration.root_path).to eq "/my-new-root"
    end
  end

  describe "#client" do
    before do
      Breadbox.configure do |config|
        config.dropbox_access_token = "12345"
      end
    end

    after { Breadbox.reset }

    it "assigns the token to a new Client" do
      client = Breadbox.client
      expect(client).to be_kind_of Breadbox::Client
    end
  end

  describe "#upload" do
    let!(:filepath) { "./tmp/my-new-file.jpg" }

    before do
      FileUtils.touch(filepath)
    end

    it "tells the client the #upload" do
      file   = File.open(filepath)
      client = instance_double(Breadbox::Client)
      params = {
        path: "/my-folder",
        file: file,
      }

      allow(Breadbox::Client).to receive(:new).and_return(client)
      expect(client).to receive(:upload).with(params)

      Breadbox.upload(params)
    end
  end
end
