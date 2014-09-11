require "aws"
require "breadbox/client"

module Breadbox
  class S3Client < Client
    def bucket
      configuration.s3_bucket
    end

    def s3_bucket_object
      @bucket ||= AWS::S3.new.buckets[bucket]
    end

    def upload(path: nil, file: nil)
      filepath = filepath_from_paths_and_file(root_path, path, file)[1..-1]
      s3_bucket_object.objects[filepath].write(file)
    end

    protected

    def post_initialize
      validate_bucket
      validate_tokens
      setup_s3
    end

    def setup_s3
      AWS.config(
        access_key_id: configuration.s3_access_key_id,
        secret_access_key: configuration.s3_secret_access_key
      )
    end

    def validate_bucket
      if configuration.s3_bucket.to_s.empty?
        raise MissingS3Bucket,
              "You need to provide an AWS::S3 Bucket"
      end
    end

    def validate_tokens
      if configuration.s3_access_key_id.to_s.empty?
        raise MissingS3AccessKeyId,
              "You need to provide an AWS::S3 Access Key ID"
      end

      if configuration.s3_secret_access_key.to_s.empty?
        raise MissingS3SecretAccessKey,
              "You need to provide an AWS::S3 Secret Access Key"
      end
    end
  end
end

class MissingS3AccessKeyId < Exception; end
class MissingS3Bucket < Exception; end
class MissingS3SecretAccessKey < Exception; end
