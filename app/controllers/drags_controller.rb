class DragsController < ApplicationController
  before_action :set_drag, only: [:edit, :update, :destroy]

  # GET /drags/new
  def new
    @drag = Drag.create
    redirect_to edit_drag_path(@drag), notice: 'New Screen successfully created.'
  end

  # GET /drags/1/edit
  def edit
  end

  # POST /drags
  # POST /drags.json
  def create
    @drag = Drag.new(drag_params)

    respond_to do |format|
      if @drag.save
        format.html { redirect_to @drag, notice: 'Drag was successfully created.' }
        format.json { render :show, status: :created, location: @drag }
      else
        format.html { render :new }
        format.json { render json: @drag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /drags/1/save_and_preview
  # PATCH/PUT /drags/1/save_and_preview.json
  def save_and_preview
    respond_to do |format|
      if @drag.update(drag_params)
        format.html { redirect_to @drag, notice: 'Drag was successfully updated.' }
        format.json { render :show, status: :ok, location: @drag }
      else
        format.html { render :edit }
        format.json { render json: @drag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /drags/1
  # PATCH/PUT /drags/1.json
  def update
    respond_to do |format|
      if @drag.update(drag_params)
        format.html { redirect_to @drag, notice: 'Drag was successfully updated.' }
        format.json { render :show, status: :ok, location: @drag }
      else
        format.html { render :edit }
        format.json { render json: @drag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drags/1
  # DELETE /drags/1.json
  def destroy
    @drag.destroy
    respond_to do |format|
      format.html { redirect_to drags_url, notice: 'Screen was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_drag
      @drag = Drag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def drag_params
      params.require(:drag).tap do |whitelisted|
        whitelisted[:content] = params[:drag][:content]
      end
    end
end
