xml.instruct!
xml.YealinkIPPhoneDirectory do
  @data.each do |data|
    xml.DirectoryEntry do
      xml.Name data.Name
      xml.Telephone data.Telephone
    end
  end
  
end