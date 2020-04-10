class RegionData
  attr_reader :is_country,
              :is_state_or_province,
              :name

  def initialize(args = {})
    @is_country = args[:is_country]
    @is_state_or_province = args[:is_state_or_province]
    @name = args[:name]
  end

  def self.global
    args = { name: "Global" }
    new(args)
  end
end
