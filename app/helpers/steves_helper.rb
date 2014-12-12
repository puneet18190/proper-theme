module StevesHelper
  require 'json'
  require 'pat'

  def rel
    @rel = ENV["HEROKU_RELEASE_NAME"]
  end
end

  def infopostcode
    @postcode = Pat.get("N1 1AA")
    @infopostcode = JSON.parse(@postcode.body)

  end