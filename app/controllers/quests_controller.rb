class QuestsController < ApplicationController
  before_action :set_quest, only: %i[ show edit update destroy toggle_done ]

  def index
    @quests = Quest.order(:done, created_at: :asc)
    @quest  = Quest.new
  end

  def show; end

  def new
    @quest = Quest.new
  end

  def edit; end

  def create
    @quest = Quest.new(quest_params)
    if @quest.save
      redirect_to quests_path, notice: "Quest was successfully created."
    else
      @quests = Quest.order(:done, created_at: :asc)
      render :index, status: :unprocessable_entity
    end
  end

  def update
    if @quest.update(quest_params)
      redirect_to quests_path, notice: "Quest was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def toggle_done
    @quest = Quest.find(params[:id])
    @quest.update(done: !@quest.done)
    respond_to do |format|
      format.turbo_stream # toggle_done.turbo_stream.erb
      format.html { redirect_to quests_path }
    end
  end

  def destroy
    @quest = Quest.find(params[:id])
    @quest.destroy
    respond_to do |format|
      format.turbo_stream # destroy.turbo_stream.erb
      format.html { redirect_to quests_path }
    end
  end

  private

  def set_quest
    @quest = Quest.find(params[:id])
  end

  def quest_params
    params.require(:quest).permit(:content, :done, :due_date)
  end
end
