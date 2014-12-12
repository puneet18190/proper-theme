module StevesHelper
  require 'json'
  require 'pat'

  def rel
    @rel = ENV["HEROKU_RELEASE_NAME"]
  end
end

  def infopostcode
    @postcode = Pat.get("NE8 1XN")
    @infopostcode = JSON.parse(@postcode.body)

  end