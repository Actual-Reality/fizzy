class ProjectsController < ApplicationController
  include FilterScoped
  include ExcerptHelper

  before_action :set_project, only: %i[ show edit update destroy report ]

  def index
    @projects = Current.account.projects.order(:name)
  end

  def show
    @open_cards_count = @project.cards.open.count
    @closed_cards_count = @project.cards.closed.count
    @total_duration = @project.time_entries.sum(:duration)
    set_page_and_extract_portion_from @project.cards.latest.preloaded
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
    entries = @project.time_entries.includes(:user, card: [:board, :rich_text_description]).order(:user_id, :started_at)
    csv_data = "\uFEFF" + generate_csv(entries)
    send_data csv_data,
      filename: "#{@project.name.parameterize}-time-report-#{Time.zone.today}.csv",
      type: "text/csv; charset=utf-8"
  end

  private
    def generate_csv(entries)
      # Build CSV manually to avoid require issues
      csv_rows = []
      
      # Header row
      csv_rows << csv_row("User", "Date", "Card ID", "Card Title", "Card Description", "Board", "Duration (Minutes)", "Duration (Formatted)")

      # Data rows
      entries.each do |entry|
        card = entry.card
        card_description = if card&.description.present?
          format_excerpt(card.description, length: 200)
        else
          ""
        end

        csv_rows << csv_row(
          entry.user&.name || "Unknown",
          entry.started_at&.to_date,
          card&.number,
          card&.title || "Unknown Card",
          card_description,
          card&.board&.name || "Unknown Board",
          entry.duration,
          TimeEntry.format_duration(entry.duration)
        )
      end
      
      csv_rows.join
    end
    
    # Helper method to build a CSV row with proper escaping
    def csv_row(*values)
      values.map { |v| csv_escape(v) }.join(",") + "\n"
    end
    
    # Helper method to escape CSV values
    def csv_escape(value)
      return "" if value.nil?
      string = value.to_s
      if string.include?(",") || string.include?('"') || string.include?("\n")
        '"' + string.gsub('"', '""') + '"'
      else
        string
      end
    end

    def set_project
      @project = Current.account.projects.find(params[:id])
    end

    def project_params
      params.expect(project: [ :name, :description ])
    end
end
