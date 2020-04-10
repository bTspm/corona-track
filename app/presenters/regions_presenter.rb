class RegionsPresenter
  include Btspm::Presenters::Presentable

  class Scalar < Btspm::Presenters::ScalarPresenter
  end

  class Enum < Btspm::Presenters::EnumPresenter
  end
end
