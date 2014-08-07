require "spec_helper"

module Breadbox
  describe Configuration do
    describe "#root_path" do
      it "defaults to /breadbox" do
        config = Configuration.new
        expect(config.root_path).to eq "/"
      end
    end

    describe "#root_path=" do
      it "assigns a root directory" do
        config  = Configuration.new
        new_dir = "/my-favorite-directory"
        config.root_path = new_dir
        expect(config.root_path).to eq new_dir
      end
    end

    describe "#dropbox_access_token" do
      it "defaults to nil" do
        config = Configuration.new
        expect(config.dropbox_access_token).to eq nil
      end
    end

    describe "#dropbox_access_token=" do
      it "assigns the access token" do
        config = Configuration.new
        access_token = "12345"
        config.dropbox_access_token = access_token
        expect(config.dropbox_access_token).to eq access_token
      end
    end
  end
end
