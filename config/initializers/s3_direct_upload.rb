S3DirectUpload.config do |c|
  c.access_key_id = "AKIAI42ZRYRPLOREEEDQ"       # your access key id
  c.secret_access_key = "LBhT9lD3MF2r3VYjg5zLlh4mM6ImKukuxjb+YT3t"   # your secret access key
  c.bucket = "sealpropertiesus"             # your bucket name
  c.region = nil             # region prefix of your bucket url. This is _required_ for the non-default AWS region, eg. "s3-eu-west-1"
  c.url = "https://sealpropertiesus.s3.amazonaws.com"               # S3 API endpoint (optional), eg. "https://#{c.bucket}.s3.amazonaws.com/"
end

