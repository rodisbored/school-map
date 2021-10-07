namespace :schools do
  desc 'Populates redis db with full collection of schools from College Scorecard'
  task populate: :environment do
    # TODO: Run a cron job to update this on a regular interval. This data rarely changes, so we
    # can set long intervals to repopulate the cache.
    CollegeScorecardConnection.schools(flush_cache: true)
  end
end
