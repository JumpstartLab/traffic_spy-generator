class UserAgent
  def self.generator
    @generator ||= WeightedGenerator.new
  end

  def self.define(user_agent,weight)
    generator.define(user_agent,weight)
  end

  def self.generate
    generator.generate
  end
end
