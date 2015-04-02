xml.instruct!
xml.YealinkIPPhoneDirectory do
  @data.each do |data|
    xml.DirectoryEntry do
      xml.Name data.name
      xml.Telephone data.telephone
    end
  end
  
end