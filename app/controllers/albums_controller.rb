class AlbumsController < ApplicationController
  layout 'default'
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_album, only: %i[show edit update destroy generate_password]

  def index
    # @albums = policy_scope(Album).order(created_at: :desc)
    @albums = policy_scope(Album).where(public: true).order(created_at: :desc)
  end

  def show
    authorize @album

    if user_signed_in?
      @image = @album.images.new
      @images = @album.images.with_attached_photo.order(created_at: :desc)
      @client = @album.client
    else
      # Optional: allow public albums without login
      unless @album.public?
        redirect_to new_user_session_path, notice: 'Connectez-vous pour accéder'
      end
    end
  end

  def new
    @album = current_user.albums.new
    authorize @album

    @clients = current_user.clients.where.missing(:album)
  end

  def edit
    authorize @album
    @clients = current_user.clients
  end

  def create
    @album = current_user.albums.new(album_params)
    authorize @album

    generated_password = album_params[:password].presence ||
      SecureRandom.random_number(10**6).to_s.rjust(6, '0')

    @album.password = generated_password

    if @album.save
      redirect_to @album, notice: 'Album créée.'
    else
      @clients = current_user.clients.where.missing(:album)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @album

    if @album.update(album_params)
      redirect_to @album, notice: 'Album mise à jour.'
    else
      @clients = current_user.clients
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @album
    @album.destroy
    redirect_to albums_url, notice: 'Album effacé'
  end

  def generate_password
    authorize @album

    generated_password = SecureRandom.random_number(10**6).to_s.rjust(6, '0')

    if @album.update(password: generated_password)
      flash[:generated_password] = generated_password
      redirect_to @album, notice: 'Nouveau mot de passe établi'
    else
      redirect_to @album, alert: 'Erreur'
    end
  end

  private

  def set_album
    @album = Album.friendly.find(params[:id])
  end

  def album_params
    params.require(:album).permit(:name, :password, :client_id, :cover_photo, :public)
  end
end