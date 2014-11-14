json.array!(@admins) do |admin|
  json.extract! admin, :id, :name, :price, :bath, :beds, :pools, :category, :image
  json.url admin_url(admin, format: :json)
end
