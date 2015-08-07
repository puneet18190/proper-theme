xml.instruct!
xml.YealinkIPPhoneDirectory do
  @data.each do |data|
    xml.DirectoryEntry do
      xml.Name data.first_name
      xml.Telephone data.phone
    end
  end
  
end