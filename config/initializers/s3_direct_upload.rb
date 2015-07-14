S3DirectUpload.config do |c|
  c.access_key_id = "AKIAJH6OPC5MWSQX6VLQ"       # your access key id
  c.secret_access_key = "wjVDX3t+wK1Ws5m33sd/MUUtsT8M1TFFsELGCPPr"   # your secret access key
  c.bucket = "sealpropertiesus"             # your bucket name
  c.region = nil             # region prefix of your bucket url. This is _required_ for the non-default AWS region, eg. "s3-eu-west-1"
  c.url = "https://sealpropertiesus.s3.amazonaws.com"               # S3 API endpoint (optional), eg. "https://#{c.bucket}.s3.amazonaws.com/"
end

