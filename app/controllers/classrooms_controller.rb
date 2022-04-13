class ClassroomsController < ApplicationController
  before_action :set_classroom, only: %i[show edit update destroy]

  # GET /classrooms or /classrooms.json
  def index
    @classrooms = Classroom.all
  end

  # GET /classrooms/1 or /classrooms/1.json
  def show; end

  # GET /classrooms/new
  def new
    @classroom = Classroom.new
  end

  # GET /classrooms/1/edit
  def edit; end

  # POST /classrooms or /classrooms.json
  def create
    @classroom = Classroom.new(classroom_params)

    respond_to do |format|
      if @classroom.save
        format.html do
          redirect_to classroom_url(@classroom), notice: 'Classroom was successfully created.'
        end
        format.json { render :show, status: :created, location: @classroom }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @classroom.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /classrooms/1 or /classrooms/1.json
  def update
    respond_to do |format|
      if @classroom.update(classroom_params)
        format.html do
          redirect_to classroom_url(@classroom), notice: 'Classroom was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @classroom }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @classroom.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /classrooms/1 or /classrooms/1.json
  def destroy
    if @classroom.destroy
      redirect_to classrooms_url, notice: 'Classroom was successfully destroyed.'
    else
      redirect_to classrooms_url, alert: 'Classroom has courses, cannot be deleted!'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_classroom
    @classroom = Classroom.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def classroom_params
    params.require(:classroom).permit(:name)
  end
end
