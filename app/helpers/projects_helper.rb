module ProjectsHelper
  def link_to_edit_project(project)
    link_to edit_project_path(project), class: "btn",
      data: { controller: "hotkey tooltip", action: "keydown.e@document->hotkey#click", turbo_frame: "_top", bridge__overflow_menu_target: "item", bridge_title: "Project settings" } do
      icon_tag("settings") + tag.span("Settings for #{project.name}", class: "for-screen-reader")
    end
  end

  def link_to_download_project_csv(project)
    link_to report_project_path(project, format: :csv), class: "btn",
      data: { controller: "tooltip", bridge__overflow_menu_target: "item", bridge_title: "Download Time Report (CSV)" } do
      icon_tag("clipboard") + tag.span("Download CSV for #{project.name}", class: "for-screen-reader")
    end
  end
end
