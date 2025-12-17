class PostMemosController < ApplicationController
  before_action :authenticate_user!

  def create
    post_memo = current_user.post_memos.new(post_memo_params)

    if post_memo.save
      redirect_to post_path(post_memo.post), notice: "メモを保存しました"
    else
      redirect_to post_path(post_memo.post), alert: "メモの保存に失敗しました"
    end
  end

  def update
    post_memo = current_user.post_memos.find(params[:id])

    if post_memo.update(post_memo_params)
      redirect_to post_path(post_memo.post), notice: "メモを更新しました"
    else
      redirect_to post_path(post_memo.post), alert: "メモの更新に失敗しました"
    end
  end

  private

  def post_memo_params
    params.require(:post_memo).permit(:memo, :post_id)
  end
end
