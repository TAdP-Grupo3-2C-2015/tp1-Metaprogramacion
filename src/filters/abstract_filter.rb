class AbstractFilter

  def parse_symbols(symbols, origin)
    symbols.map { |symbol| origin.instance_method(symbol) }

  end

end