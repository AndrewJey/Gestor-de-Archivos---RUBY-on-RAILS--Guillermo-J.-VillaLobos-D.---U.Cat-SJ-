class Video < ActiveRecord::Base
  belongs_to :user
 # Paperclip delcaracion de adjuntos
  has_attached_file :video_file
  has_attached_file :mp4_file
  has_attached_file :webm_file
  has_attached_file :ogg_file
  # declaracion del estilo del video
  has_attached_file :thumbnail, styles: { medium_nr: "250x150!" }

  # paperclip requiere esto para validar los adjuntos
  validates_attachment_content_type :video_file, content_type: /\Avideo/
  validates_attachment_content_type :mp4_file, content_type: /.*/
  validates_attachment_content_type :webm_file, content_type: /.*/
  validates_attachment_content_type :ogg_file, content_type: /.*/

  # valida que sea un video y tenga nombre
  validates :name, presence: true
  validates_attachment_presence :video_file

  after_create :run_encoders

  # Publica el video y notifica en tiempo real si PubNub está configurado
  def publish!
    self.published = true
    save
    notify_pubnub("video.#{id}", event: :published)
    if user && user.respond_to?(:notification_channel)
      short_name = name.to_s[0, 20]
      notify_pubnub(
        user.notification_channel,
        event: :published,
        scope: :videos,
        id: id,
        name: short_name
      )
    end
  end

  # Incrementa contador de likes evitando nil
  def like!
    self.likes = (likes || 0) + 1
    save
    notify_pubnub("video.#{id}", event: :liked)
  end

  # Decrementa contador de likes sin bajar de 0
  def dislike!
    self.likes = [(likes || 0) - 1, 0].max
    save
    notify_pubnub("video.#{id}", event: :disliked)
  end

  # Revisa que se tengan los codificadores
  def all_formats_encoded?
    !!(webm_file && webm_file.path && mp4_file && mp4_file.path && ogg_file && ogg_file.path)
  end

  private

  def run_encoders
    ThumbnailCutter.perform_async(id) if defined?(ThumbnailCutter)
    Mp4VideoEncoder.perform_async(id) if defined?(Mp4VideoEncoder)
    OgvVideoEncoder.perform_async(id) if defined?(OgvVideoEncoder)
    WebmVideoEncoder.perform_async(id) if defined?(WebmVideoEncoder)
  end

  def notify_pubnub(channel, message)
    return unless defined?($pubnub) && $pubnub
    $pubnub.publish(channel: channel, message: message, http_sync: true)
  end
end
