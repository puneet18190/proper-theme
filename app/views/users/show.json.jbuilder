json.array!(@user) do |user|
  json.extract! user, :id
  json.label "#{user.first_name} #{user.last_name}"
  json.value "#{user.first_name} #{user.last_name}"
end
