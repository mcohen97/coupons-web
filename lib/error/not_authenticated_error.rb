class NotAuthenticatedError < StandardError
  def initialize(msg = 'Error while requesting info from promotion')
    super
  end
end