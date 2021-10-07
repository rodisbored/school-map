module CollegeScorecardConnection
  extend ActiveSupport::Concern

  def self.initialize(path: '')
    Faraday.new(url: "https://#{CONFIG[:college_scorecard_url]}/#{CONFIG[:college_scorecard_api_version]}/#{path}") do |faraday|
      faraday.headers['Content-Type'] = 'application/json'
      faraday.adapter Faraday.default_adapter
    end
  end

  def self.schools(search: nil, flush_cache: false)
    if search
      retrieve_schools(search_term: search)
    else
      Rails.cache.fetch('schools', expires_in: 24.hours, skip_nil: true, force: flush_cache) do
        retrieve_schools
      end
    end
  end

  class << self
    private

    def retrieve_schools(search_term: nil)
      request_params = {
        api_key: Rails.application.credentials.college_scorecard[:api_key],
        fields: get_fields.html_safe,
        per_page: 100
      }
      request_params.merge!('school.name': search_term) if search_term

      schools = []
      page = 0

      loop do
        response = initialize(path: 'schools').get do |req|
          req.params = request_params.merge(page: page)
        end
        body = JSON.parse(response.body).with_indifferent_access
        schools.concat(body[:results])
        page += 1
        Rails.logger.debug("Current page #{body[:metadata][:page]}")

        break if (body[:metadata][:page] + 1) * body[:metadata][:per_page] >= body[:metadata][:total]
      end

      schools
    end

    def get_fields
      %w(id school.name location).join(',')
    end
  end
end
