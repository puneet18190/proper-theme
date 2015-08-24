ActiveAdmin.register ContactAgent do
  permit_params :name, :email, :message, :agent_id, :page_link
end
