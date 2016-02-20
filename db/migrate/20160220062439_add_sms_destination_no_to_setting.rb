class AddSmsDestinationNoToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :sms_destination_no, :string
    add_column :settings, :send_sms_on_signup, :boolean, default: false
    add_column :settings, :send_sms_on_msg, :boolean, default: false
  end
end
