class OriginArgumentException < RuntimeError

  def initialize()
    super('Wrong number of arguments (0 for +1)')
  end

end