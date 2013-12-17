class VotesController < ApplicationController
  prepend_before_filter :cas_filter, except: [:index, :show]

  # GET /votes
  # GET /votes.json
  def index
    @votes = Vote.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @votes }
    end
  end

  # GET /votes/1
  # GET /votes/1.json
  def show
    @vote = Vote.find(params[:id])
    @vote.read

    @comment = Comment.new
    @subcomment = SubComment.new

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vote }
    end
  end

  # GET /votes/new
  # GET /votes/new.json
  def new
    @vote = Vote.new
    3.times { @vote.options.build }

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vote }
    end
  end

  # GET /votes/1/edit
  def edit
    @vote = Vote.find(params[:id])
    flash.now[:notice] = "提醒：修改已有投票可能导致数据错误，请谨慎操作。"
  end

  # POST /votes
  # POST /votes.json
  def create
    @vote = Vote.new(params[:vote])

    respond_to do |format|
      if @vote.save
        format.html { redirect_to @vote, flash: { success: '投票创建成功。' } }
        format.json { render json: @vote, status: :created, location: @vote }
      else
        format.html { render action: "new" }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /votes/1
  # PUT /votes/1.json
  def update
    @vote = Vote.find(params[:id])

    respond_to do |format|
      if @vote.update_attributes(params[:vote])
        format.html { redirect_to @vote, flash: { success: '投票更新成功。' } }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /votes/1
  # DELETE /votes/1.json
  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy

    respond_to do |format|
      format.html { redirect_to votes_url }
      format.json { head :no_content }
    end
  end

  def vote_for
    redirect_to :back and return unless params[:options].present?

    @vote = Vote.find(params[:vote_id])
    @options = @vote.options.find(params[:options].to(@vote.max_vote - 1))

    if @vote.voters.include? current_user
      redirect_to :back, flash: { error: "您已经投过票了" }
      return 
    end

    @options.each do |option|
      option.update_attributes(count: option.count + 1)
    end
    @vote.voters << current_user
    redirect_to :back, flash: { success: "投票成功" }
  end
end
