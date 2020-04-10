class TimeSeries
  attr_reader :date,
              :stats

  def initialize(args={})
    @date = date
    @stats = stats
  end

  def self.from_ninja_response(response)
    timelines = response.map { |r| r[:timeline] }
    timelines.reduce({}) do |sums, stats|
      sums.merge(stats) do |_, prev_hsh, new_hsh|
        prev_hsh.merge(new_hsh) {|_, prev_val, new_val| prev_val + new_val }
      end
    end

    h = {}
    timelines.each do |timeline|
      timeline.each do |key, value|
        key
      end
      end
  end
end
