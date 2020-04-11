class TimeSeries
  ATTRIBUTES = %i[region statistics].freeze

  attr_reader *ATTRIBUTES

  def initialize(args = {})
    args = args.with_indifferent_access
    ATTRIBUTES.each do |attribute|
      instance_variable_set(:"@#{attribute}", args.dig(attribute))
    end
  end

  def self.from_global_ninja_response(response)
    timelines = response.map { |r| r[:timeline] }
    types = _types_with_sum(timelines)
    args = {
      region: RegionData.global,
      statistics: _stats_grouped_by_dates(types)
    }

    new(args)
  end

  def self._get_all_dates(timelines)
    case timelines
    when Hash
      timelines.keys + timelines.values.flat_map { |v| _get_all_dates(v) }
    when Array
      timelines.flat_map { |i| _get_all_dates(i) }
    else
      []
    end
  end

  def self._stats_grouped_by_dates(types)
    _get_all_dates(types.values).uniq.map do |date|
      args = { datetime: DateTime.strptime(date, "%m/%d/%y") }
      types.keys.each do |key|
        args.merge!({ "#{key}": types.dig(key, date) })
      end
      Stat.from_ninja_timeseries_response(args)
    end
  end

  def self._types_with_sum(timelines)
    timelines.reduce({}) do |sums, stats|
      sums.merge(stats) do |_, prev_hsh, new_hsh|
        prev_hsh.merge(new_hsh) { |_, prev_val, new_val| prev_val + new_val }
      end
    end
  end

  private_class_method :_get_all_dates,
                       :_stats_grouped_by_dates,
                       :_types_with_sum
end
