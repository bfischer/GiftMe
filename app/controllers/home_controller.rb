require 'time'
require 'uri'
require 'openssl'
require 'base64'

class HomeController < ApplicationController

# Your AWS Access Key ID, as taken from the AWS Your Account page
AWS_ACCESS_KEY_ID = "AKIAIIZ7OB22ZB3TA2FA"

# Your AWS Secret Key corresponding to the above ID, as taken from the AWS Your Account page
AWS_SECRET_KEY = "q7ntL+bVRuTtJXjz4sAqLvVtVlZzoLtQM3/C8CBr"

# The region you are interested in
ENDPOINT = "webservices.amazon.com"

REQUEST_URI = "/onca/xml"

params = {
  "Service" => "AWSECommerceService",
  "Operation" => "ItemSearch",
  "AWSAccessKeyId" => "AKIAIIZ7OB22ZB3TA2FA",
  "AssociateTag" => "trailbackp-20",
  "SearchIndex" => "SportingGoods",
  "Keywords" => "backpack",
  "ResponseGroup" => "Images,ItemAttributes,Offers",
  "Sort" => "price"
}

# Set current timestamp if not set
params["Timestamp"] = Time.now.gmtime.iso8601 if !params.key?("Timestamp")

# Generate the canonical query
canonical_query_string = params.sort.collect do |key, value|
  [URI.escape(key.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")), URI.escape(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))].join('=')
end.join('&')

# Generate the string to be signed
string_to_sign = "GET\n#{ENDPOINT}\n#{REQUEST_URI}\n#{canonical_query_string}"

# Generate the signature required by the Product Advertising API
signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), AWS_SECRET_KEY, string_to_sign)).strip()

# Generate the signed URL
request_url = "http://#{ENDPOINT}#{REQUEST_URI}?#{canonical_query_string}&Signature=#{URI.escape(signature, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}"

puts "Signed URL: \"#{request_url}\""


	layout "application"
  def index
  end

  def search
    @inputData = "blah blah blah"

    Aws.config.update({
      region: 'us-west-2',
      credentials: Aws::Credentials.new('akid', 'secret'),
    })

    params = {
  "Service" => "AWSECommerceService",
  "Operation" => "ItemSearch",
  "AWSAccessKeyId" => "AKIAIIZ7OB22ZB3TA2FA",
  "AssociateTag" => "trailbackp-20",
  "SearchIndex" => "SportingGoods",
  "Keywords" => "backpack",
  "ResponseGroup" => "Images,ItemAttributes,Offers",
  "Sort" => "price"
}

# Set current timestamp if not set
params["Timestamp"] = Time.now.gmtime.iso8601 if !params.key?("Timestamp")

# Generate the canonical query
canonical_query_string = params.sort.collect do |key, value|
  [URI.escape(key.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")), URI.escape(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))].join('=')
end.join('&')

# Generate the string to be signed
string_to_sign = "GET\n#{ENDPOINT}\n#{REQUEST_URI}\n#{canonical_query_string}"

# Generate the signature required by the Product Advertising API
signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), AWS_SECRET_KEY, string_to_sign)).strip()

# Generate the signed URL
request_url = "http://#{ENDPOINT}#{REQUEST_URI}?#{canonical_query_string}&Signature=#{URI.escape(signature, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}"

    puts "Signed URL: \"#{request_url}\""

@inputData = request_url

request = Vacuum.new
request.configure(
  aws_access_key_id: AWS_ACCESS_KEY_ID,
  aws_secret_access_key: AWS_SECRET_KEY,
  associate_tag: 'trailbackp-20'
  )

response = request.item_search(
  query: {
    'Keywords' => 'Architecture',
    'SearchIndex' => 'Books'
  }
)
@inputData = response.to_h
  end

end
