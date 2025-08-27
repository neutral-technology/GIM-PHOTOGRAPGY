# ### app/controllers/clients_controller.rb
class ClientsController < ApplicationController
  layout 'default' # applies to all actions

  before_action :authenticate_user!

  def index
    @clients = current_user.clients.order(created_at: :desc)
  end

  def new
    @client = current_user.clients.new
  end

  def create
    @client = current_user.clients.new(client_params)
    if @client.save
      redirect_to new_album_path, notice: 'Client was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def client_params
    params.require(:client).permit(:name)
  end
end
