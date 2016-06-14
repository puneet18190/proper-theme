task :remove_phone_rec => :environment do
  Phone.where(["created_at < ?", 6.days.ago]).delete_all
end
