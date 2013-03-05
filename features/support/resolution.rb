class Resolution
  def self.generator
    @generator ||= WeightedGenerator.new
  end

  def self.define(resolution,weight)
    generator.define(resolution,weight)
  end

  def self.generate
    generator.generate
  end
end