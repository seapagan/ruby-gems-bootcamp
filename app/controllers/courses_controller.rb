class CoursesController < ApplicationController
  before_action :set_course, only: %i[show edit update destroy generate_lessons]

  # GET /courses or /courses.json
  def index
    @courses = Course.all
  end

  def generate_lessons
    # delete future lessons to regenerate them
    @course.lessons.where('start > ?', Time.now).destroy_all

    # regenerates future lessons
    # @course.schedule.occurrences(Time.now + 1.month).each do |occurrence|
    @course.schedule.next_occurrences(8).each do |occurrence|
      @course.lessons.find_or_create_by(start: occurrence.to_datetime, user: @course.user,
                                        classroom: @course.classroom)
    end

    # generate attendances for future lessons
    @course.lessons.where('start > ?', Time.now).each do |lesson|
      @course.enrollments.each do |enrollment|
        lesson.attendances.find_or_create_by(status: 'planned', user: enrollment.user)
      end
    end

    redirect_to @course, notice: 'Generate Lessons : OK'
  end

  # GET /courses/1 or /courses/1.json
  def show
    @lessons = @course.lessons
    @enrollments = @course.enrollments.all
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit; end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)

    if @course.save
      redirect_to course_url(@course), notice: 'Course was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    if @course.update(course_params)
      redirect_to course_url(@course), notice: 'Course was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    if @course.destroy
      redirect_to courses_url, notice: 'Course was successfully destroyed.'
    else
      redirect_to courses_url, alert: 'Course has lessons, cannot be deleted!'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def course_params
    params.require(:course).permit(:user_id, :classroom_id, :service_id, :start_time,
                                   *Course::DAYS_OF_WEEK,
                                   enrollments_attributes: [:id, :user_id, :_destroy])
  end
end
