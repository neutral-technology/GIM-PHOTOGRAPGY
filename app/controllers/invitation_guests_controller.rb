class InvitationGuestsController < ApplicationController
  layout 'default'
  skip_after_action :verify_authorized
  before_action :set_brochure

  def create
    @guest = @brochure.invitation_guests.create!(
      guest_params
    )
    redirect_to album_gallery_path(@brochure.client.album),
                notice: "Invité ajouté"
  end

  def mark_sent
    guest = @brochure.invitation_guests.find(params[:id])
    guest.mark_as_sent!

    render json:{
      success:true
    }
  end

  def destroy
    guest = @brochure.invitation_guests.find(params[:id])
    guest.destroy

    redirect_to album_gallery_path(@brochure.client.album),
            notice: "Invité Suprimé"
  end

  private

  def set_brochure
    @brochure = Brochure.find(params[:brochure_id])
  end

  def guest_params
    params.require(:invitation_guest)
      .permit(
        :name,
        :phone,
        :table
      )
  end
end
