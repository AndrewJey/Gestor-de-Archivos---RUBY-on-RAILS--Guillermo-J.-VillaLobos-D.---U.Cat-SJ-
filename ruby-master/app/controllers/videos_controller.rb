class VideosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_video, only: [:show, :edit, :update, :destroy, :like, :dislike]
  before_action :authorize_owner!, only: [:edit, :update, :destroy]

  # All published videos
  def index
    @videos = Video.where(published: true)
  end

  def show
  end

  def new
    @video = current_user.videos.build
  end

  def edit
  end

  def create
    @video = current_user.videos.build(video_params)

    respond_to do |format|
      if @video.save
        format.html { redirect_to @video, notice: 'Video was successfully created.' }
        format.json { render :show, status: :created, location: @video }
      else
        format.html { render :new }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to @video, notice: 'Video was successfully updated.' }
        format.json { render :show, status: :ok, location: @video }
      else
        format.html { render :edit }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @video.destroy
    respond_to do |format|
      format.html { redirect_to videos_url, notice: 'Video was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  # Likes video, increment likes count
  def like
    @video.like!
    respond_to do |format|
      format.html { redirect_to @video, notice: 'Like registrado.' }
      format.json { render json: { id: @video.id, likes: @video.likes }, status: :ok }
    end
  end

  # Dislikes video, decrement likes count (min 0)
  def dislike
    @video.dislike!
    respond_to do |format|
      format.html { redirect_to @video, notice: 'Dislike registrado.' }
      format.json { render json: { id: @video.id, likes: @video.likes }, status: :ok }
    end
  end

  private

  def set_video
    @video = Video.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to videos_url, alert: 'Video no encontrado.' }
      format.json { render json: { error: 'Video no encontrado.' }, status: :not_found }
    end
  end

  def authorize_owner!
    return if @video && @video.user_id == current_user.id
    respond_to do |format|
      format.html { redirect_to videos_url, alert: 'No autorizado para modificar este video.' }
      format.json { render json: { error: 'Forbidden' }, status: :forbidden }
    end
  end

  def video_params
    params.require(:video).permit(:video_file, :name)
  end
end
