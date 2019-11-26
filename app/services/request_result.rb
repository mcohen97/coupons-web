class RequestResult

  attr_accessor :success, :data

  def initialize(success, data)
    @success = success
    @data = data
  end
end