class MainController < ApplicationController
  before_action :authenticate_user!
  before_action :check_demo_mode

  def index
    # 既読処理 @last_viewed_at は New バッジ判定用
    @last_viewed_at = current_user.last_viewed_at
    current_user.update_column(:last_viewed_at, Time.current)

    # ログイン中ユーザーの「有効ペア」を取得
    @pair = Pair.where(active: true)
                .where("user_id1 = ? OR user_id2 = ?", current_user.id, current_user.id)
                .first

    # ペア未設定・無効ペアの場合
    if @pair.nil?
      @partner = nil
      @posts = []
      return
    end

    # 相手ユーザーを取得
    @partner = @pair.user1 == current_user ? @pair.user2 : @pair.user1

    # 投稿取得
    posts = Post.where(pair_id: @pair.id).includes(:category, :user)

    # アーカイブ
    @posts = case params[:archived]
            when "true" then posts.archived
            else posts.active
            end

    # 投稿者
    @posts = case params[:my_posts]
            when "self" then @posts.where(user_id: current_user.id)
            when "partner" then @posts.where.not(user_id: current_user.id)
            else @posts
            end

    # 答え合わせ
    @posts = case params[:revealed]
            when "before" then @posts.where("reveal_at > ?", Time.current)
            when "after"  then @posts.where("reveal_at <= ?", Time.current)
            else @posts
            end


    # 検索フィルター
    if params[:q].present?
      @posts = @posts.where("title LIKE ?", "%#{params[:q]}%")
    end

    # カテゴリ絞り込み
    if params[:category].present? && params[:category] != "all"
      @posts = @posts.joins(:category).where(categories: { name: params[:category] })
    end

    # 並び替え
    @posts = case params[:sort]
            when "priority"
              @posts.order(sense_level: :desc, created_at: :desc)
            when "reveal"
              @posts.order(Arel.sql("CASE WHEN reveal_at <= NOW() THEN 1 ELSE 0 END ASC, reveal_at ASC"))
            else
              @posts.order(created_at: :desc)
            end

    # 新着通知作成
    @posts.each do |post|
      if post.just_unlocked?(@last_viewed_at)
        post.create_post_unlocked_notification!
      end
    end
    
    # ページネーション（1ページ10件）
    @posts = @posts.page(params[:page]).per(10)
  end

  private

  def check_demo_mode
    if current_user&.email == DemoUserService::DEMO_USER1_EMAIL
      @show_demo_modal = session.delete(:show_demo_modal)  # nilなら表示されない
    end
  end
end
