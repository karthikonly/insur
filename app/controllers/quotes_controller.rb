class QuotesController < ApplicationController
  before_action :set_quote, only: [:show, :edit, :update, :destroy, :new_applicant, :create_applicant]

  # GET /quotes
  # GET /quotes.json
  def index
    @quotes = Quote.all
  end

  # GET /quotes/1
  # GET /quotes/1.json
  def show
    # TODO: update the quote with application information
  end

  # GET /quotes/new
  def new
    @provinces = Province.where(country: "USA")
    @quote = Quote.new
  end

  # POST /quotes
  # POST /quotes.json
  def create
    @quote = Quote.new(quote_params)
    @quote.effective_date ||= Date.today
    @quote.user = current_user

    respond_to do |format|
      if @quote.save
        format.html { redirect_to new_applicant_quote_path(@quote), notice: 'Quote was successfully created.' }
        format.json { render :show, status: :created, location: @quote }
      else
        format.html { render :new }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /quotes/:id/new_applicant
  def new_applicant
    @applicant = Applicant.new
  end

  # POST /quotes/:id/create_applicant
  def create_applicant
    # TODO: retrieve the quote from the system and attach applicant to the quote
  end

  # GET /quotes/1/edit
  def edit
  end

  # PATCH/PUT /quotes/1
  # PATCH/PUT /quotes/1.json
  def update
    respond_to do |format|
      if @quote.update(quote_params)
        format.html { redirect_to @quote, notice: 'Quote was successfully updated.' }
        format.json { render :show, status: :ok, location: @quote }
      else
        format.html { render :edit }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotes/1
  # DELETE /quotes/1.json
  def destroy
    @quote.destroy
    respond_to do |format|
      format.html { redirect_to quotes_url, notice: 'Quote was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quote
      @quote = Quote.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quote_params
      params.require(:quote).permit(:agent_code, :effective_date, :line, :state)
    end
end
