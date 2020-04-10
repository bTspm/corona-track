class TimeSeries
  attr_reader :counts,
              :type

  def initialize(args = {})
    @type = args[:type]
    @counts = args[:counts]
  end

  def confirmed?
    type == "cases"
  end

  def deaths?
    type == "deaths"
  end

  def recovered?
    type == "recovered"
  end

  def self.from_ninja_response(response)
    timelines = response.map { |r| r[:timeline] }
    types = timelines.reduce({}) do |sums, stats|
      sums.merge(stats) do |_, prev_hsh, new_hsh|
        prev_hsh.merge(new_hsh) { |_, prev_val, new_val| prev_val + new_val }
      end
    end

    types.map do |type, values|
      args = {
        counts: values.transform_keys { |key| DateTime.strptime(key, "%m/%d/%y") },
        type: type
      }

      new(args)
    end
  end
end
