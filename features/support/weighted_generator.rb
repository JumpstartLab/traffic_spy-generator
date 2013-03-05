class WeightedGenerator
  def initialize
    @total_weight = 0
  end

  attr_reader :total_weight

  def resources
    @resources ||= {}
  end

  def define(resource,weight)
    start_weight = (total_weight > 0 ? total_weight + 1 : 0)
    @total_weight += weight

    range = (start_weight..total_weight)
    resources[range] = resource
  end

  def generate
    resources[weighted_key]
  end

  private

  def weighted_key
    result = rand(total_weight)
    key = resources.keys.find {|key| key.cover? result }
  end
end
