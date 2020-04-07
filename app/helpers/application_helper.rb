module ApplicationHelper
  def flag(country_code)
    return if country_code.blank?

    content_tag(
      :span,
      nil,
      class: "flag-icon flag-icon-#{country_code.downcase}"
    )
  end
end
