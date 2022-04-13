class Courses::LessonsController < ApplicationController
  before_action :set_course
  before_action :set_lesson, only: %i[show edit update destroy]

  # GET /lessons/new
  def new
    @lesson = Lesson.new(classroom_id: @course.classroom_id, user_id: @course.user_id)
    @lesson.attendances.build(@course.enrollments.as_json(only: [:user_id]))
  end

  # GET /lessons/1/edit
  def edit; end

  # POST /lessons or /lessons.json
  def create
    @lesson = Lesson.new(lesson_params)
    @lesson.course = @course

    if @lesson.save
      redirect_to @course, notice: 'Lesson was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /lessons/1 or /lessons/1.json
  def update
    if @lesson.update(lesson_params)
      redirect_to @course, notice: 'Lesson was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /lessons/1 or /lessons/1.json
  def destroy
    @lesson.destroy
    redirect_to @course, notice: 'Lesson was successfully destroyed.'
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_lesson
    @lesson = Lesson.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def lesson_params
    params.require(:lesson).permit(:user_id, :classroom_id, :course_id,
                                   :status, :start,
                                   attendances_attributes: [:id, :user_id, :status, :_destroy])
  end
end
