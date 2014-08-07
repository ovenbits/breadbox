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
  end
end
