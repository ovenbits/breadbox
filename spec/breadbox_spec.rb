require "spec_helper"

describe Breadbox do
  describe "#configure" do
    before do
      Breadbox.configure do |config|
        config.dropbox_access_token = "12345"
        config.root_directory       = "/my-new-root"
      end
    end

    after { Breadbox.reset }

    it "returns the newly assigned token" do
      expect(Breadbox.configuration.dropbox_access_token).to eq "12345"
    end

    it "returns the newly assigned root" do
      expect(Breadbox.configuration.root_directory).to eq "/my-new-root"
    end
  end

  describe "#client" do
    before do
      Breadbox.configure do |config|
        config.dropbox_access_token = "12345"
      end
    end

    after { Breadbox.reset }

    it "assigns the token to a DropboxClient" do
      client = Breadbox.client
      expect(client).to be_kind_of DropboxClient
    end
  end
end
