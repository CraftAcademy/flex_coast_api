class InquiryPolicy < ApplicationPolicy
  # class Scope < Scope
  #   def resolve
  #     scope
  #   end
  # end
  def update?
    @record.broker == @user
  end
end
