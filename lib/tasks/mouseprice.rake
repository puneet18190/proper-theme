task :mouseprice => :environment do
  require "open-uri"
  require 'nokogiri'
  require 'zip'
  
  # Thread.new do
    puts "===============Upload Start========================="
    UserMailer.blm_status("BLM Upload on MousePrice Start").deliver
    @data = Property.where(:approval_status=>"approved", :mouse_price=>true, :portal_visibility => true)
    t = Tempfile.new("SP39545")
    Zip::OutputStream.open(t.path) do |z|
      @data.each_with_index do |item,i|
        sp = "SP39545_SP"+item.created_at.year.to_s.split(//).last(2).join()+item.created_at.month.to_s.rjust(2,'0')+item.id.to_s.rjust(4,'0')
        (0..9).each do |n|
          if !item.send("image#{n+1}").url.nil? && !item.send("image#{n+1}").path.nil?
            puts item.send("image#{n+1}").path
            z.put_next_entry(sp+"_IMG_"+n.to_s.rjust(2,'0')+"."+item.send("image#{n+1}").path.split(".").last.downcase)
            url1 = item.send("image#{n+1}").url(:large)
            url1_data = open(url1.gsub('https','http')).read
            z.print url1_data
          end
        end
        z.put_next_entry("#{sp}_DOC_00.pdf")
        z.print open("http://www.sealproperties.co.uk/brochure.pdf?id="+item.id.to_s).read
      end
      z.put_next_entry("coming_soon.jpg")
      z.print  File.open("#{Rails.root}/app/assets/images/default_images/no.jpg").read
      d=DateTime.now
      seq = "01"
      f_name = "39545_"+d.year.to_s+d.month.to_s.rjust(2,'0')+d.day.to_s+d.hour.to_s.rjust(2,'0')+d.minute.to_s.rjust(2,'0')
      z.put_next_entry("#{f_name}.blm")
      ac = ApplicationController.new()
      remote_data = ac.render_to_string "properties/download_blm1", :locals => {:@data => @data}, :layout=>false
      remote_data = remote_data.gsub("<pre>","")
      remote_data = remote_data.gsub("</pre>","")
      remote_data = remote_data.gsub("&lt;","<")
      remote_data = remote_data.gsub("&gt;",">")
      remote_data = remote_data.gsub("&quot;","'")
      z.print remote_data
    end
    require 'net/ftp'
    # Net::FTP.open('feeds.agentsmutual.co.uk', 'sealproperties', 'Pwx85N8zAK8wHC5') do |ftp|
    #   ftp.passive = true
    #   ftp.chdir("/live/upload")
    #   ftp.putbinaryfile(t.path,"39545.zip")
    # end
    d=DateTime.now
    f_name = "39545_"+d.year.to_s+d.month.to_s.rjust(2,'0')+d.day.to_s+d.hour.to_s.rjust(2,'0')+d.minute.to_s.rjust(2,'0')
    Net::FTP.open('mouseprice.net', 'SealProp', 'SealProp77') do |ftp|
      ftp.passive = true
      # ftp.chdir("/")
      ftp.putbinaryfile(t.path,"SP#{f_name}.zip")
    end
    t.close
    UserMailer.blm_status("BLM Uploaded Successfully on MousePrice.").deliver
    puts "===============Upload Complete========================="
  # end
end
