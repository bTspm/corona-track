class RegionsPresenter
  include Btspm::Presenters::Presentable

  class Scalar < Btspm::Presenters::ScalarPresenter
    def formatted_chart_name
      name.gsub(/'/, "")
    end

    def formatted_name
      name.truncate_words(5)
    end

    def formatted_unofficial_names
      unofficial_names&.join(", ")
    end

    def global_map_data
      { code3: alpha3, code: alpha2, name: formatted_chart_name }
    end
  end

  class Enum < Btspm::Presenters::EnumPresenter
  end
end
