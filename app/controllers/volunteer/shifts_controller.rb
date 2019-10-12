module Volunteer
  class ShiftsController < BaseController
    include ShiftsHelper
    include Calendaring

    def index
      load_upcoming_events
      @attendee = Attendee.new(session[:email], session[:name])
    end

    def new
      result = google_calendar.fetch_event(params[:event_id])
      if result.success?
        @event = result.value
      else
        redirect_to volunteer_shifts_url, error: "That event was not found"
      end
    end

    def create
      if signed_in_via_google?
        event_signup(params[:event_id])
      else
        # store requested event id for later reference
        session[:event_id] = params[:event_id]
        redirect_to "/auth/google_oauth2"
      end
    end
  end
end