ActiveAdmin.register Phone do
  permit_params :callerid, :call_action, :dataname, :local, :remote
end
