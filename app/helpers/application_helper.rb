module ApplicationHelper
  include Pagy::Frontend

  # Return the full title on a per-page basis.
  def full_tile page_title
    base_title = t "ruby_on_rails_tutorial_sample_app"
    page_title.blank? ? base_title : "#{page_title} | #{base_title}"
  end
end
