class SignQuery
  attr_reader :signs

  # Class method to return the single instance
  def self.instance
    @instance ||= new
  end

  def initialize
    @signs = Sign.all
  end


  private_class_method :new
end
