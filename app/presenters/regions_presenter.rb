class RegionsPresenter
  include Btspm::Presenters::Presentable

  class Scalar < Btspm::Presenters::ScalarPresenter
    def formatted_unofficial_names
      return "" if unofficial_names.blank?

      unofficial_names.join(", ")
    end

    def formatted_name
      name.truncate_words(5)
    end
  end

  class Enum < Btspm::Presenters::EnumPresenter
  end
end
