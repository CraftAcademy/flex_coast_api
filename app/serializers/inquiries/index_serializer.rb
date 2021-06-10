class Inquiries::IndexSerializer < ActiveModel::Serializer
  attributes :id, :company, :size, :email, :phone, :office_type, :inquiry_status, :peers, :flexible, :locations, :start_date, :inquiry_date, :broker

  def inquiry_date
    object.created_at.strftime("%d %b %Y")
  end

  def broker
    return nil unless object.broker
    Users::Serializer.new(object.broker)
  end 
end
