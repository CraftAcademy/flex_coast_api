class InquiriesIndexSerializer < ActiveModel::Serializer
  attributes :id, :company, :size, :email, :phone, :office_type, :inquiry_status, :peers, :flexible, :locations, :start_date, :inquiry_date

  def inquiry_date
    object.created_at.strftime("%d %b %Y")
  end
end
