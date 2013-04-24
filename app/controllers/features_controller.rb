class FeaturesController < ApplicationController
  prepend_before_filter :cas_filter, except: [:show, :index]
  append_before_filter :require_admin, except: [:show, :index]

  def index
    @features = Feature.all
  end

  # GET /features/1
  # GET /features/1.json
  def show
    @feature = params[:id] ? Feature.find(params[:id]) : Feature.first

    if @feature == nil
      redirect_to new_feature_path, notice: "请至少创建一个专题。"
      return 
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feature }
    end
  end

  # GET /features/new
  # GET /features/new.json
  def new
    @feature = Feature.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feature }
    end
  end

  # GET /features/1/edit
  def edit
    @feature = Feature.find(params[:id])
  end

  # POST /features
  # POST /features.json
  def create
    @feature = Feature.new(params[:feature])

    respond_to do |format|
      if @feature.save
        format.html { redirect_to @feature, flash: { success: '创建专题成功。' } }
        format.json { render json: @feature, status: :created, location: @feature }
      else
        format.html { render action: "new" }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /features/1
  # PUT /features/1.json
  def update
    @feature = Feature.find(params[:id])

    respond_to do |format|
      if @feature.update_attributes(params[:feature])
        format.html { redirect_to @feature, flash: { success: '专题更新成功。' } }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /features/1
  # DELETE /features/1.json
  def destroy
    @feature = Feature.find(params[:id])
    @feature.destroy

    respond_to do |format|
      format.html { redirect_to features_url, flash: { success: '专题删除成功。' } }
      format.json { head :no_content }
    end
  end
end
