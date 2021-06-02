module ResponseJSON do
  def response_json 
    JSON.parse(response.body)
  end
end