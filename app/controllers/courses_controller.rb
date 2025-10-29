class CoursesController < ApplicationController
  before_action :authenticate_user!

  def show
    @course = Course.find(params[:id])
  end

end
