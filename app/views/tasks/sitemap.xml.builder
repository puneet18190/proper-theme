xml.instruct!
xml.urlset(
  'xmlns'.to_sym => "http://www.sitemaps.org/schemas/sitemap/0.9",
  'xmlns:image'.to_sym => "http://www.google.com/schemas/sitemap-image/1.1"
) do
  @static_pages.each do |page|
    xml.url do
      xml.loc "#{page}"
      xml.changefreq("monthly")
    end
  end
  # @users.each do |user|
  #   xml.url do
  #     xml.loc "#{user_url(user)}"
  #     xml.changefreq("monthly")
  #   end
  # end
  @property.each do |property|
    xml.url do
      xml.loc '/properties_detail/'+property.slug
      xml.lastmod property.updated_at.strftime("%F")
      xml.changefreq("monthly")
      # if post.photo?
      #   xml.image :image do
      #     xml.image :loc, "#{request.protocol}#{request.host_with_port}#{post.photo(:medium)}"
      #   end
      # end
    end
  end
end