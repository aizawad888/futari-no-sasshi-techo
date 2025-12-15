class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.pair = Pair.find_by("user_id1 = ? OR user_id2 = ?", current_user.id, current_user.id)
    if @post.save
      redirect_to main_path
    else
      render :new
    end
  end

  private

  def post_params
    params.require(:post).permit(
      :title,
      :category_id,
      :sense_level,
      :reveal_at
    )
  end
end
