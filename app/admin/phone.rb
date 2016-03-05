ActiveAdmin.register Phone do
  permit_params :callerid, :call_action, :dataname, :local, :remote, :display_local, :display_remote
end
