class AlbumsController < ApplicationController
  layout 'default' # applies to all actions
  before_action :authenticate_user!, except: %i[index]
  before_action :set_album, only: %i[show edit update destroy generate_password]

  def index
    @albums = current_user.albums.order(created_at: :desc)
  end

  def show
    if user_signed_in?
      @image = @album.images.new # Used for the upload form
      @images = @album.images.with_attached_photo.order(created_at: :desc)
      @client = @album.client
    else
      redirect_to new_user_session_path, notice: 'reservé à GIM, connectez-vous pour y acceder'
    end
  end

  def new
    @album = current_user.albums.new
    @clients = current_user.clients.where.missing(:album)
  end

  def edit
    @clients = current_user.clients
  end

  def create
    @album = current_user.albums.new(album_params)

    # Automatically generate a password if one wasn't provided
    generated_password = album_params[:password].presence || SecureRandom.random_number(10**6).to_s.rjust(6, '0')
    @album.password = generated_password

    if @album.save
      redirect_to @album, notice: 'Album créée.'
      # redirect_to users_profile_path, notice: 'Album créée.'
    else
      # @clients = current_user.clients
      @clients = current_user.clients.where.missing(:album)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @album.update(album_params)
      redirect_to @album, notice: 'Album mise à jour.'
    else
      @clients = current_user.clients
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @album.destroy
    redirect_to albums_url, notice: 'Album éfacé'
  end

  def generate_password
    generated_password = SecureRandom.random_number(10**6).to_s.rjust(6, '0')
    if @album.update(password: generated_password)
      flash[:generated_password] = generated_password
      redirect_to @album, notice: 'nouveau mot de passe établit'
    else
      redirect_to @album, alert: 'Failed to generate a new password.'
    end
  end

  private

  def set_album
    @album = Album.friendly.find(params[:id])
  end

  def album_params
    params.require(:album).permit(:name, :password, :client_id, :cover_photo)
  end
end
