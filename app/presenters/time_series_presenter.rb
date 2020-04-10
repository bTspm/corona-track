class RegionsPresenter
  include Btspm::Presenters::Presentable

  class Scalar < Btspm::Presenters::ScalarPresenter
    def stats
      StatsPresenter.present(data_object.stats, h)
    end
  end
end
