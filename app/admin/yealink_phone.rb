ActiveAdmin.register YealinkPhone do
  permit_params :name, :callerid, :department, :status, :call_duration, :callid, :mac, :callaction
end
