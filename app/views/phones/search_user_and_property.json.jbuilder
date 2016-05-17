json.array!(@user) do |user|
  json.extract! user, :id
  json.label "#{user.first_name} #{user.last_name}"
  json.value "#{user.first_name} #{user.last_name}"
  json.type "user"
end

json.array!(@property) do |property|
  json.extract! property, :id
  json.label "#{property.name}"
  json.value "#{property.name}"
  json.type "property"
end
