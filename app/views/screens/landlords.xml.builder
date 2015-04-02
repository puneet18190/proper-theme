xml.instruct!
xml.YealinkIPPhoneDirectory do
  @data.each do |data|
    xml.DirectoryEntry do
      xml.Name data.username
      xml.Telephone data.phone
    end
  end
  
end