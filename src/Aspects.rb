class Aspects

  #Se usa Aspects.on elemento1,elemento2,elemento3 do .... end
  def on(*elements, &aspects_to_add)

    elements each do |element|
      __on__(element, &aspects_to_add)
    end

  end

  #Private ?? (?)

  def __on__(element, &aspects_to_add)

    if (element.class) == Regexp
      on_parseable_object(element,&aspects_to_add)
    else
      on_object(element, &aspects_to_add)
    end

  end

  def on_parseable_object(expression, &aspects_to_add)

    found_objects = parse_and_search_for(expression)
    #Por ahi aca se podria llamar una recursividad al metodo "on" pelado en lugar del each, pero no se si conviene
    #Haria un chequeo de nuevo al pedo para ver si son regExp.
    found_objects each do |object|
      on_object(object,&aspects_to_add)
    end

  end

  def on_object(object, &aspects_to_add)
    #TO_DO
    #Agrega los aspectos, que vienen en un bloque
  end

  def parse_and_search_for(expression)
    #TO_DO
    #Devuelve una coleccion de objetos a los que hay que agregarle los aspectos
  end

end