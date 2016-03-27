json.array!(@properties) do |property|
  json.extract! property, :id
  json.label "#{property.name}"
  json.value "#{property.name}"
end
