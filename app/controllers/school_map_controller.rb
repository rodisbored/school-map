class SchoolMapController < ApplicationController
  MIN_SEARCH_LENGTH = 3

  def index
    locations =
      if params[:search].present?
        # TODO: Need to sanitize search params or rescue for bad search.
        # A `,` currently breaks the search if added to a valid string
        if params[:search].length < MIN_SEARCH_LENGTH
          # TODO: Hook up flash error so it actually appears
          flash[:error] = "Minimum length of string must be #{MIN_SEARCH_LENGTH} or greater"
          []
        else
          CollegeScorecardConnection.schools(search: params[:search].strip)
        end
      else
        CollegeScorecardConnection.schools
      end

    render locals: { locations: locations }
  end
end
