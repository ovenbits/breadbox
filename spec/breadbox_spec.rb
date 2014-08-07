require "spec_helper"

describe Breadbox do
  describe "::configure" do
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

  describe "::client" do
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

  describe "::upload" do
    let!(:filepath) { "./tmp/my-new-file.jpg" }
    let(:client)    { instance_double(Breadbox::Client) }

    before(:each) do
      FileUtils.touch(filepath)
      allow(Breadbox).to receive(:client).and_return(client)
    end

    after { File.delete(filepath) }

    it "tells the client the #upload" do
      file   = File.open(filepath)
      params = {
        path: "/my-folder",
        file: file,
      }

      allow(Breadbox).to receive(:client).and_return(client)
      expect(client).to receive(:upload).with(params)

      Breadbox.upload(params)
    end

    it "calls cleanup after upload" do
      file   = File.open(filepath)

      allow(Breadbox).to receive(:client).and_return(client)
      allow(client).to receive(:upload).and_return(true)
      expect(Breadbox).to receive(:cleanup).with(file: file, cleanup: true)

      Breadbox.upload(file: file, cleanup: true)
    end
  end

  describe "::cleanup" do
    let!(:filepath) { "./tmp/my-new-file.jpg" }

    before(:each) do
      FileUtils.touch(filepath)
    end

    after { File.delete(filepath) if File.exists?(filepath) }

    context "with cleanup flag as false" do
      it "doesn't delete the file" do
        file = File.open(filepath)
        expect(File.exists?(filepath)).to be true
        Breadbox.cleanup(file: file, cleanup: false)

        expect(File.exists?(filepath)).to be true
      end
    end

    context "with cleanup as true" do
      it "deletes the file" do
        file = File.open(filepath)
        expect(File.exists?(filepath)).to be true
        Breadbox.cleanup(file: file, cleanup: true)

        expect(File.exists?(filepath)).to be false
      end
    end
  end
end
