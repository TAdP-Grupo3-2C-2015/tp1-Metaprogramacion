class Aspects


  def self.regex_search(regex)
    matching_classes = []
    get_classes.select { |a_symbol| regex =~ a_symbol }.each do |a_matching_symbol|
      matching_classes << (Object.const_get(a_matching_symbol))
    end
    return matching_classes
  end


  #Fernando tenía razón y están en Object como symbols las clases
  def self.get_classes
    Object.constants

  end

end