class QuotesController < ApplicationController
  before_action :set_quote, only: [:show, :edit, :update, :destroy, :new_applicant, :create_applicant, 
    :new_driver, :create_driver, :new_insur_vehicle, :create_insur_vehicle, :new_incident, :create_incident]
  before_action :set_provinces, only: [:new, :new_applicant, :new_driver, :new_insur_vehicle, :new_incident, :edit, 
                    :create, :create_applicant, :create_driver, :create_insur_vehicle, :create_incident, :update]

  # GET /quotes
  # GET /quotes.json
  def index
    @quotes = Quote.all
  end

  # GET /quotes/1
  # GET /quotes/1.json
  def show
  end

  # GET /quotes/new
  def new
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
    @applicant = Applicant.new(applicant_params)
    @quote.applicant = @applicant
    # logger.debug @quote.inspect
    # logger.debug applicant_params.inspect
    # logger.debug @applicant.inspect

    respond_to do |format|
      if @quote.save
        format.html { redirect_to new_driver_quote_path(@quote), notice: 'Applicant was successfully created.' }
        format.json { render :show, status: :created, location: @quote }
      else
        format.html { render :new_applicant }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /quotes/:id/new_driver
  def new_driver
    @driver = Driver.new
  end

  # POST /quotes/:id/create_driver
  def create_driver
    @driver = Driver.new(driver_params)
    @quote.driver = @driver

    respond_to do |format|
      if @quote.save
        format.html { redirect_to new_insur_vehicle_quote_path(@quote), notice: 'Driver was successfully created.' }
        format.json { render :show, status: :created, location: @quote }
      else
        format.html { render :new_driver }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /quotes/:id/new_insur_vehicle
  def new_insur_vehicle
    @insur_vehicle = InsurVehicle.new
  end

  # POST /quotes/:id/create_insur_vehicle
  def create_insur_vehicle
    @insur_vehicle = InsurVehicle.new(insur_vehicle_params)
    @quote.insur_vehicle = @insur_vehicle

    respond_to do |format|
      if @quote.save
        format.html { redirect_to new_incident_quote_path(@quote), notice: 'Insured Vehicle was successfully created.' }
        format.json { render :show, status: :created, location: @quote }
      else
        format.html { render :new_insur_vehicle }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /quotes/:id/new_incident
  def new_incident
  end

  # POST /quotes/:id/create_incident
  def create_incident
    respond_to do |format|
    if @quote.update(quote_params)
        format.html { redirect_to :root, notice: 'Incident Reports was successfully created.' }
        format.json { render :show, status: :created, location: @quote }
      else
        format.html { render :new_incident }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
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
    # Callback to set the provinces required for many new/edit screens
    def set_provinces
      @provinces = Province.where(country: "USA")
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_quote
      @quote = Quote.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quote_params
      params.require(:quote).permit(:agent_code, :effective_date, :line, :state, :non_violence_duration, :prior_incident_forgiveness)
    end

    def applicant_params
      params.require(:applicant).permit(:appl_prefix, :appl_first, :appl_middle, :appl_last, :appl_suffix, :appl_ssn,
        :coappl_prefix, :coappl_first, :coappl_middle, :coappl_last, :coappl_suffix, :coappl_ssn,
        :agency_cust_id, :phone, :risk_addr_1, :risk_addr_2, :risk_city, :risk_state, :risk_zip, :risk_zip2,
        :residence_type, :years_at_residence, :companion_credit, :companion_policy, :life_policy_credit,
        :life_policy, :young_family_discount, :group_discount_option, :personal_account_bill, :star_pak,
        :star_pak_account, :parent_policy_number1, :parent_policy_number2)
    end

    def driver_params
      params.require(:driver).permit(:prefix, :first, :middle, :last, :suffix, :applicant_relation, :dob,
        :gender, :marital_status, :license_status, :license_state, :license_number, :license_date, :license_valid_till)
    end

    def insur_vehicle_params
      params.require(:insur_vehicle).permit(:vin, :type, :usage, :annual_mileage, :anti_theft, :vehicle_id)
    end
end
