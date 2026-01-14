class ProjectsController < ApplicationController
  include FilterScoped

  before_action :set_project, only: %i[ show edit update destroy report ]

  def index
    @projects = Current.account.projects.order(:name)
  end

  def show
    @open_cards_count = @project.cards.open.count
    @closed_cards_count = @project.cards.closed.count
    @total_duration = @project.time_entries.sum(:duration)
  end

  def new
    @project = Current.account.projects.new
  end

  def create
    @project = Current.account.projects.new(project_params)

    if @project.save
      redirect_to projects_path, notice: "Project was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to projects_path, notice: "Project was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: "Project was successfully destroyed."
  end

  def report
    @entries_by_user = @project.time_entries.includes(:user, :card).group_by(&:user)
    @total_duration = @project.time_entries.sum(:duration)

    respond_to do |format|
      format.html
      format.csv do
        csv_data = "\uFEFF" + generate_csv(@project.time_entries.includes(:user, card: :board).order(started_at: :desc))
        send_data csv_data,
          filename: "#{@project.name.parameterize}-time-report-#{Time.zone.today}.csv"
      end
    end
  end

  private
    def generate_csv(entries)
      require "csv"

      CSV.generate(headers: true) do |csv|
        csv << [ "Date", "User", "Card ID", "Card Title", "Board", "Description", "Duration (Minutes)", "Duration (Formatted)" ]

        entries.each do |entry|
          csv << [
            entry.started_at&.to_date,
            entry.user&.name,
            entry.card&.number,
            entry.card&.title,
            entry.card&.board&.name,
            entry.description,
            entry.duration,
            TimeEntry.format_duration(entry.duration)
          ]
        end
      end
    end

    def set_project
      @project = Current.account.projects.find(params[:id])
    end

    def project_params
      params.expect(project: [ :name, :description ])
    end
end
