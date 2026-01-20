class BoardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @pair = current_user.active_pair
    return redirect_to(root_path, alert: "ペアが存在しません") unless @pair

    @board = @pair.board || @pair.create_board
    @anniversaries = @pair.anniversaries.order(:date)
  end

end
