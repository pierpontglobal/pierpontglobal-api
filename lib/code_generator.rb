module CodeGenerator
  def self.generate
    (SecureRandom.rand * 1_000_000).to_i
  end
end