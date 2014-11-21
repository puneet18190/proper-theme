module StevesHelper


  def rel
    @rel = ENV["HEROKU_RELEASE_NAME"]
  end
end