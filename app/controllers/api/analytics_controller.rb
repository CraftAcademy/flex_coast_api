class Api::AnalyticsController < ApplicationController
  before_action :get_statistics

  def index 
    binding.pry
    render json: { statistics: @statistics }
  end

  private

  def get_statistics
    @statistics = {}
    visits_stats
    events_stats
  end

  def visits_stats
   
    @statistics[:visits] = {
      total: Ahoy::Visit.count
    }
  end

  def events_stats
    @statistics[:events] = {
      answer: Ahoy::Event.all.where(name: 'answer')
    }
  end
end
