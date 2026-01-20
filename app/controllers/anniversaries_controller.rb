class AnniversariesController < ApplicationController
  before_action :authenticate_user!

  def index
    @anniversaries = current_user.pair.anniversaries.order(:date)
  end

  def new
    @anniversary = Anniversary.new
  end

  def create
    @anniversary = current_user.pair.anniversaries.build(anniversary_params)
    if @anniversary.save
      redirect_to anniversaries_path, notice: "記念日を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def anniversary_params
    params.require(:anniversary).permit(:title, :date, :repeat_type)
  end
end
