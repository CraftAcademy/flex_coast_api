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
    answers = %w[size office_type email peers locations flexible start_date phone submit]
    answers_stats = answers.map do |answer_key|
      Hash[:name, answer_key, :value, Ahoy::Event.where_event('answer', question: answer_key).count]
    end
    answers_stats.unshift({ value: @statistics[:visits][:total],
                           name: 'total' })
    @statistics[:events] = {
      answers: answers_stats
    }
    @statistics[:events][:calls] = Ahoy::Event.where(name: 'phone_button').count
  end
end
