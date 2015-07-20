require "aws-sdk"
require "breadbox/client"

module Breadbox
  class S3Client < Client
    def bucket
      configuration.s3_bucket
    end

    def s3_bucket_object
      @bucket ||= Aws::S3::Resource.new(client: s3_client_object).bucket(bucket)
    end

    def upload(options = {})
      path          = options[:path]
      file          = options[:file]
      filename      = options[:filename] || File.basename(file)
      acl           = options[:public] ? :public_read : :private
      content_type  = options[:content_type]
      filepath      = filepath_from_paths_and_filename(root_path, path, filename)[1..-1]
      s3_object     = s3_bucket_object.object(filepath)

      result = s3_object.put(body: file, acl: acl, content_type: content_type)

      if result && result.successful?
        s3_object.public_url.to_s
      end
    end

    def s3_client_object
      @client ||= Aws::S3::Client.new(
        region: configuration.s3_region,
        credentials: Aws::Credentials.new(
          configuration.s3_access_key_id,
          configuration.s3_secret_access_key,
        )
      )
    end

    protected

    def post_initialize
      validate_bucket
      validate_tokens
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
