# Initialize PubNub client only when keys are configured
sub_key = Rails.application.secrets.pubnub_subscribe_key || ENV['PUBNUB_SUBSCRIBE_KEY']
pub_key = Rails.application.secrets.pubnub_publish_key || ENV['PUBNUB_PUBLISH_KEY']
sec_key = Rails.application.secrets.pubnub_secret_key || ENV['PUBNUB_SECRET_KEY']
auth_key = Rails.application.secrets.pubnub_auth_key || ENV['PUBNUB_AUTH_KEY']

if sub_key.present? && pub_key.present?
  $pubnub = Pubnub.new(
    subscribe_key: sub_key,
    publish_key: pub_key,
    secret_key: sec_key
  )

  # Grant read access on video.* and read/write on authorized channels
  $pubnub.grant(read: true, write: false, auth_key: nil, channel: 'video.*', http_sync: true, ttl: 0)
  if auth_key.present?
    $pubnub.grant(read: true, write: true, auth_key: auth_key, channel: 'video.*', http_sync: true, ttl: 0)
    $pubnub.grant(read: true, write: true, auth_key: auth_key, channel: 'notifications.*', http_sync: true, ttl: 0)
  end
else
  $pubnub = nil
end
