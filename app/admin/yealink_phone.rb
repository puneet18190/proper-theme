ActiveAdmin.register YealinkPhone do
  permit_params :name, :caller_id, :department, :status, :call_duration, :callid, :mac
end
