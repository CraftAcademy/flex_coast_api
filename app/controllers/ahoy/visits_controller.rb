class Ahoy::VisitsController < Ahoy::BaseController
  def create
    binding.pry
    ahoy.track_visit
    binding.pry
    render json: {
      visit_token: ahoy.visit_token,
      visitor_token: ahoy.visitor_token,
      # legacy
      visit_id: ahoy.visit_token,
      visitor_id: ahoy.visitor_token
    }
  end
end
