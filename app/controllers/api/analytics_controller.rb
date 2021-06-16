class Api::AnalyticsController < ApplicationController
  before_action :get_statistics

  def index 
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
      answers: [
        {
          value: @statistics[:visits][:total],
          name: 'total'
        },
        {
          value: Ahoy::Event.where_event("answer", question: 'size').count,
          name: 'size'
        },
        {
          value: Ahoy::Event.where_event("answer", question: 'office_type').count,
          name: 'office_type'
        },
        {
          value: Ahoy::Event.where_event("answer", question: 'email').count,
          name: 'email'
        },
        {
          value: Ahoy::Event.where_event("answer", question: 'peers').count,
          name: 'peers'
        },
        {
          value: Ahoy::Event.where_event("answer", question: 'locations').count,
          name: 'locations'
        },
        {
          value: Ahoy::Event.where_event("answer", question: 'flexible').count,
          name: 'flexible'
        },
        {
          value: Ahoy::Event.where_event("answer", question: 'start_date').count,
          name: 'start_date'
        },
        {
          value: Ahoy::Event.where_event("answer", question: 'phone').count,
          name: 'phone'
        },
        {
          value: Ahoy::Event.where_event("answer", question: 'submit').count,
          name: 'submit'
        },
      ]
    }
    @statistics[:events][:calls] = Ahoy::Event.where(name: 'phone_button').count
  end
end
