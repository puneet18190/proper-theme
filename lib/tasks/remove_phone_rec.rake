task :remove_phone_rec => :environment do
  Phone.where(["created_at < ?", 30.days.ago]).delete_all
end
