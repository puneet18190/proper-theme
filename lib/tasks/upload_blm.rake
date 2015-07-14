task :upload_blm => :environment do
  require "open-uri"
  require 'nokogiri'
  require 'zip'
  
  Thread.new do
    puts "===============Upload Start========================="
    @data = Property.where(:visibility=>true,:approve=>true)
    t = Tempfile.new("39545")
    Zip::OutputStream.open(t.path) do |z|
      @data.each_with_index do |item,i|
        sp = "39545_SP"+item.created_at.year.to_s.split(//).last(2).join()+item.created_at.month.to_s.rjust(2,'0')+item.id.to_s.rjust(4,'0')
        (0..9).each do |n|
          if !item.send("image#{n+1}").url.nil? && !item.send("image#{n+1}").path.nil?
            puts item.send("image#{n+1}").path
            z.put_next_entry(sp+"_IMG_"+n.to_s.rjust(2,'0')+"."+item.send("image#{n+1}").path.split(".").last.downcase)
            url1 = item.send("image#{n+1}").url(:large)
            url1_data = open(url1.gsub('https','http')).read
            z.print url1_data
          end
        end
      end
      z.put_next_entry("coming_soon.jpg")
      z.print  File.open("#{Rails.root}/app/assets/images/default_images/no.jpg").read
      d=DateTime.now
      seq = "01"
      f_name = "39545_"+d.year.to_s+d.month.to_s.rjust(2,'0')+d.day.to_s+seq
      z.put_next_entry("#{f_name}.blm")
      remote_data = render_to_string "download_blm", :layout => false
      remote_data = remote_data.gsub("<pre>","")
      remote_data = remote_data.gsub("</pre>","")
      remote_data = remote_data.gsub("&lt;","<")
      remote_data = remote_data.gsub("&gt;",">")
      remote_data = remote_data.gsub("&quot;","'")
      z.print remote_data
    end
    require 'net/ftp'
    Net::FTP.open('feeds.agentsmutual.co.uk', 'sealproperties', 'Pwx85N8zAK8wHC5') do |ftp|
      ftp.passive = true
      ftp.chdir("/live/upload")
      ftp.putbinaryfile(t.path,"39545.zip")
    end
    t.close
    puts "===============Upload Complete========================="
  end
end