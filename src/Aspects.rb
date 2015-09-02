class Aspects


  def self.regex_search(regex)
    matching_classes = []
    context_classes.select { |class_symbol| regex =~ class_symbol }.each do |matching_class_symbol|
      matching_classes << (Object.const_get(matching_class_symbol))
    end
    return matching_classes
  end


  #Fernando ten�a raz�n y est�n en Object como symbols las clases
  def self.context_classes
    Object.constants

  end

end