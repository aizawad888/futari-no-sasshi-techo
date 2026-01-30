class PushNotificationService
  def self.send_notification(user, title:, body:, url: nil)
    new(user).send_notification(title: title, body: body, url: url)
  end

  def initialize(user)
    @user = user
  end

  def send_notification(title:, body:, url: nil)
    # そのユーザーの全購読情報を取得
    subscriptions = @user.push_subscriptions

    return if subscriptions.empty?

    # 通知のペイロード（内容）を作成
    payload = {
      title: title,
      body: body,
      url: url || Rails.application.routes.url_helpers.notifications_url,
      icon: '/icon.png',  # アイコン画像のパス
      badge: '/badge.png' # バッジ画像のパス
    }.to_json

    # 各購読情報に対して通知を送信
    subscriptions.each do |subscription|
      send_push(subscription, payload)
    end
  end

  private

  def send_push(subscription, payload)
    WebPush.payload_send(
      message: payload,
      endpoint: subscription.endpoint,
      p256dh: subscription.p256dh,
      auth: subscription.auth,
      vapid: {
        public_key: ENV['VAPID_PUBLIC_KEY'],
        private_key: ENV['VAPID_PRIVATE_KEY']
      }
    )
  rescue WebPush::ExpiredSubscription, WebPush::InvalidSubscription => e
    # 購読が無効になった場合は削除
    Rails.logger.info "購読が無効になりました: #{e.message}"
    subscription.destroy
  rescue StandardError => e
    Rails.logger.error "プッシュ通知送信エラー: #{e.message}"
  end
end