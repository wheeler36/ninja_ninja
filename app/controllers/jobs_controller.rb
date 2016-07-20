class JobsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorized_user, only: [:edit, :update, :destroy]
  before_action :find_job, only: [:show, :edit, :update, :destroy]

  def index
    @jobs = Job.all.order("created_at DESC")
  end

  def show
  end

  def new
    @job = current_user.jobs.build
  end

  def create
    @job = current_user.jobs.build(job_params)
    if @job.save
      redirect_to @job
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @job.update(job_params)
      redirect_to @job
    else
      render 'edit'
    end
  end

  def destroy
    @job.destroy
    redirect_to root_path
  end

  private

  def find_job
    @job = Job.find(params[:id])
  end

  def authorized_user
    @job = current_user.jobs.find_by(id: params[:id])
    redirect_to root_path, notice: "Not authorized to modify this job" if @job.nil?
  end

  def job_params
    params.require(:job).permit(:title, :description, :company, :url)
  end
end
