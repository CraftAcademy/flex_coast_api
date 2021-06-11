class Notes::Serializer < ActiveModel::Serializer
  attributes :body, :id, :date

  def date
    object.created_at.strftime("%d %b %Y")
  end
end