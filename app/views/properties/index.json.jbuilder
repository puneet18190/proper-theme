json.array!(@properties) do |property|
  json.extract! property, :id, :name, :address1, :address2, :address3, :postcode, :bath, :beds, :price, :category, :parking, :image1, :image2, :image3, :image4, :image5, :image6, :description, :date, :visibility, :let, :sold, :featured, :agent_id
  json.url property_url(property, format: :json)
end
