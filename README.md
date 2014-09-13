# Breadbox

A simple wrapper interface for uploading files to Dropbox or Amazon S3

## Disclaimer

- This is a simple and fast implementation - Issues and PRs welcome.
- Currently tested on Ruby 2.1.2

## Installation

Add this line to your application's Gemfile:

    gem 'breadbox'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install breadbox

---
## Setup for Dropbox

### 1. Get a [Dropbox Access Token](https://www.dropbox.com/developers/blog/94/generate-an-access-token-for-your-own-account)
### 2. Add to your initializers:

```ruby
# config/initializers/breadbox.rb

Breadbox.configure do |config|
  config.dropbox_access_token = xxxxxxx # THIS IS REQUIRED
  config.provider = :dropbox            # THIS IS REQUIRED
end
```

--
## Setup for S3

### 1. Get your [AWS Credentials](http://infinitewp.com/knowledge-base/where-are-my-amazon-s3-credentials/)
### 2. [Create or find a bucket](http://docs.aws.amazon.com/AmazonS3/latest/gsg/CreatingABucket.html)
### 3. Add to your initializers

```ruby
# config/initializers/breadbox.rb

Breadbox.configure do |config|
  config.s3_bucket = "name of the bucket" # THIS IS REQUIRED
  config.s3_secret_access_key = xxxxxx    # THIS IS REQUIRED
  config.s3_access_key_id = xxxxxxx       # THIS IS REQUIRED
  config.provider = :s3                   # THIS IS REQUIRED
end
```

### (Optional) Configure your root directory for uploading files

> By default - the root path will be the root directory of your [DropBox folder or S3 Bucket].
You can, however, change the root path to be anything you want.

**Note: You have to prefix the folder you want with a `/`, ex: `/uploads/my-files`**

```ruby
# config/initializers/breadbox.rb

Breadbox.configure do |config|
  config.root_path = "/uploads/my-files"

  # ... more configurations ...
end
```

## Usage

### Parameters:

- `path`: defaults to `nil`, but this is where you put a custom folder if you so wish (in relation
  to your `root_path`, which if you didn't configure in your initializer, will be your root Dropbox
  folder `/`.
- `file`: The file object that you are uploading, ex: `file = File.open('./path-to-local-file').
- `cleanup`: defaults to `false`, but if you pass `true` - it will remove the local file after uploading
  to DropBox

```ruby
# to upload a file to [Dropbox Folder or S3 Bucket]/uploads/my-cool-file.jpg
# and remove it after upload

file = File.open("./tmp/my-cool-file.jpg")
Breadbox.upload(path: "uploads", file: file, cleanup: true)
```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/breadbox/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
