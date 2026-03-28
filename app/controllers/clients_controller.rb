# ### app/controllers/clients_controller.rb
class ClientsController < ApplicationController
  layout 'default' # applies to all actions

  before_action :authenticate_user!

  def index
    @clients = policy_scope(Client).order(created_at: :desc)
    authorize Client
  end

  def new
    @client = current_user.clients.new
    authorize @client
  end

  def create
    @client = current_user.clients.new(client_params)
    authorize @client
    if @client.save
      redirect_to new_album_path, notice: 'Client ajouté avec succès.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def client_params
    params.require(:client).permit(:name, :tel)
  end
end
