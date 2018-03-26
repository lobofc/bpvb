module Admin
  # CalculatorsController
  class CalculatorsController < AdminController
    before_action :set_calculator, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    # GET /calculators
    def index
      @q = Calculator.ransack(params[:q])
      calculators = @q.result(distinct: true)
      @objects = calculators.page(@current_page)
      @total = calculators.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to calculators_path(page: @current_page.to_i.pred, search: @query)
      end
      @calculators = Calculator.all
      respond_to do |format|
        format.html
        format.xls { send_data(@calculators.to_xls) }
      end
    end

    # GET /calculators/1
    def show
    end

    # GET /calculators/new
    def new
      @calculator = Calculator.new
    end

    # GET /calculators/1/edit
    def edit
    end

    # POST /calculators
    def create
      @calculator = Calculator.new(calculator_params)

      if @calculator.save
        redirect(@calculator, params)
      else
        render :new
      end
    end

    # PATCH/PUT /calculators/1
    def update
      if @calculator.update(calculator_params)
        redirect_to admin_calculators_path, notice: "Actualizado #{calculator_params[:name]}"
      else
        render :edit
      end
    end

    def clone
      @calculator = Calculator.clone_record params[:calculator_id]

      if @calculator.save
        redirect_to admin_calculators_path
      else
        render :new
      end
    end

    # DELETE /calculators/1
    def destroy
      @calculator.destroy
      redirect_to admin_calculators_path, notice: actions_messages(@calculator)
    end

    def destroy_multiple
      Calculator.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_calculators_path(page: @current_page, search: @query),
        notice: actions_messages(Calculator.new)
      )
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_calculator
      @calculator = Calculator.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def calculator_params
      params.require(:calculator).permit(:name, :value)
    end

    def show_history
      get_history(Calculator)
    end
  end
end
