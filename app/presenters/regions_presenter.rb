class RegionsPresenter
  include Btspm::Presenters::Presentable

  class Scalar < Btspm::Presenters::ScalarPresenter
    def formatted_chart_name
      name.gsub(/'/, "")
    end

    def formatted_name
      name.truncate_words(5)
    end

    def formatted_country_name_with_link
      return formatted_name if !country? || alpha2.blank?

      h.link_to(formatted_name, h.corona_country_path(code: alpha2))
    end

    def formatted_unofficial_names
      unofficial_names&.join(", ")
    end

    def map_data_for_country
      { alpha3: alpha3, code: alpha2, name: formatted_chart_name }
    end

    def map_data_for_state_or_province
      { name: name }
    end

    def dropdown_country_data
      [name, alpha2, { "data-lookup": _country_lookup }]
    end

    private

    def _country_lookup
      [alpha2, alpha3, unofficial_names].compact.join(', ')
    end

    def _parent
      return if parent.blank?

      @_parent ||= RegionsPresenter.present(parent, h)
    end
  end

  class Enum < Btspm::Presenters::EnumPresenter
    def for_select
      sort_by(&:name).map(&:dropdown_country_data)
    end
  end
end
