class InvitationsController < ApplicationController
  layout 'default'
  skip_after_action :verify_authorized
  before_action :find_guest

  def show
    @brochure = @guest.brochure
        render "brochures/show"
  end

  def update
    if params[:status] == "accepted"
      @guest.accept!
    else
      @guest.declined!
    end
    redirect_to invitation_path(@guest.token)
  end

  def open
    @brochure = @guest.brochure

    render "brochures/show",
      locals: {
        guest: @guest
      }
  end

  private

  def find_guest
    @guest =
      InvitationGuest.find_by!(
        token: params[:token]
      )
  end
end
