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

  @property.each do |property|
    xml.url do
      xml.loc "#{request.protocol}#{request.host_with_port}/properties_detail/#{property.slug}"
      xml.lastmod property.updated_at.strftime("%F")
      xml.changefreq("monthly")
      (1..10).each do |n|
        unless property.send("image#{n}").url.nil?
          xml.image :image do
            xml.image :loc, property.send("image#{n}").url
          end
        end  
      end
    end
  end
end