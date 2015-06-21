json.array!(@skills) do |skill|
  json.extract! skill, 
  json.url skill_url(skill, format: :json)
end