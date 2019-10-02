class ParsingError < StandardError
  def initialize(msg="Error while parsing")
    super
  end
end
