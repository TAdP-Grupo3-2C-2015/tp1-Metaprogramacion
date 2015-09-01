[![Stories in Ready](https://badge.waffle.io/TAdP-Grupo3/Tp1-Metaprogramacion.png?label=ready&title=Ready)](https://waffle.io/TAdP-Grupo3/Tp1-Metaprogramacion)
#TADP - 2015 Metaprogramacion

[Link al dashboard de Waffle](https://waffle.io/TAdP-Grupo3/Tp1-Metaprogramacion/join)

[Enunciado](https://docs.google.com/document/d/1eF2wDjBPDy2XH4Wc4V6PzIfVyj2Vz2DCRO99lt-q-GY/edit)

--------

Framework de AOP (Aspect Oriented Programming) para Ruby

1 . Origenes
2 . Condiciones
3 . Transformaciones

1 . Origenes
Llamaremos "Origen" a uno o más objetos, módulos o clases sobre cuyos métodos nos interesa realizar transformaciones.

Aspects.on unObjeto do
    #Definicion de aspectos
    end

Aspects.on unModulo,unaClase,otroObjeto do
    #Definicion de aspectos
    #Define el aspecto en todos los elementos
    end

Ademas, deben poderse seleccionar clases o modulos basandose en expresiones regulares.
(Formato a definir, pudiendo usar la nomenclatura de Ruby o el standard POSIX(incluido en las regExp de Ruby))
[Referencia](http://ruby-doc.org/core-2.1.1/Regexp.html)

Aspects.on unObjeto,/^Foo.*/ do
    #Definicion de aspectos
    #en unObjeto, y todas las clases o modulos que empiezen con Foo.
    end

Debe fallar ante Origenes vacios o si ningna de las expresiones matchea a un Origen valido.

Aspects.on do
  # ...
end
# ArgumentError: wrong number of arguments (0 for +1)

Aspects.on /NombreDeClaseQueNoExiste/ do
  # ...
end
# ArgumentError: origen vacío

Aspects.on /NombreDeClaseQueNoExiste/, /NombreDeClaseQueSíExiste/ do
  # ...
end
# Exito!


2 . Condiciones

Permite filtrar los métodos de un Origen en donde realizar una transformación.
Para eso deben implementarse una serie de Condiciones que permitan filtrar los métodos sobre los cuales actuar.

Implementa un mensaje where, accesible desde dentro del contexto de los Orígenes, que recibe un conjunto de condiciones por parámetro.
Los métodos retornados no solo serán aquellos definidos en la clase o módulo inmediato, sino todos los de su jerarquía.

Aspects.on MiClase, miObjeto do
  where <<Condicion1>>, <<Condicion2>>, ..., <<CondicionN>>
  # Retorna los métodos que entienden miObjeto y las instancias de MiClase
  # que cumplen con todas las condiciones pedidas
end

Las Condiciones que deben ser soportadas se listan a continuación
(Aunque esta lista podría crecer en el futuro).

2.1 . Selector
Esta condición se cumple cuando el selector del método respeta una cierta regex.

class MiClase
  def foo
  end

  def bar
  end
end

Aspects.on MiClase do
  where name(/fo{2}/)
  # array con el método foo (bar no matchea)

  where name(/fo{2}/), name(/foo/)
  # array con el método foo (foo matchea ambas regex)

  where name(/^fi+/)
  # array vacío (ni bar ni foo matchean)

  where name(/foo/), name(/bar/)
  # array vacío (ni foo ni bar matchean ambas regex)
end

2.2 . Visibilidad
Se cumple si el método es privado o público.

class MiClase
  def foo
  end

  private

  def bar
  end
end

Aspects.on MiClase do
  where name(/bar/), is_private
  # array con el método bar

  where name(/bar/), is_public
  # array vacío
end

2.3 . Cantidad de Parámetros
Debe poder establecerse una condición que se cumpla si el método tiene exactamente N parámetros obligatorios, opcionales o ambos.

class MiClase
 def foo(p1, p2, p3, p4='a', p5='b', p6='c')
 end
 def bar(p1, p2='a', p3='b', p4='c')
 end
end

Aspects.on MiClase do
  where has_parameters(3, mandatory)
  # array con el método foo

  where has_parameters(6)
  # array con el método foo

  where has_parameters(3, optional)
  # array con los métodos foo y bar
end

2.4 . Nombre de Parámetros
Esta condición se cumple si el método tiene exactamente N parámetros cuyo nombre cumple cierta regex.

class MiClase
  def foo(param1, param2)
  end

  def bar(param1)
  end
end

Aspects.on MiClase do
  where has_parameters(1, /param.*/)
  # array con los el método bar

  where has_parameters(2, /param.*/)
  # array con el método foo

  where has_parameters(3, /param.*/)
  # array vacío
end

2.5 . Negación
Esta condición recibe otras condiciones por parámetro y se cumple cuando ninguna de ellas se cumple.

class MiClase
  def foo1(p1)
  end
  def foo2(p1, p2)
  end
  def foo3(p1, p2, p3)
  end
end

Aspects.on MiClase do
  where name(/foo\d/), neg(has_parameters(1))
  # array con los métodos foo2 y foo3
end

Nota: Usamos “neg” como nombre de la condición en vez de “not” porque el “not” de Ruby toma precedencia.


3 . Transformaciones

Se pueden aplicar transformaciones sobre los métodos que matchean todas las condiciones.

Aspects.on MiClase, miObjeto do
  transform(where <<Condicion1>>, <<Condicion2>>, ..,<<CondicionN>>) do
    <<Transformación1>>
    <<Transformación2>>
    ...
  end
end

Las Transformaciones soportadas se listan a continuación
(Aunque esta lista podría crecer en el futuro)

Se pueden aplicar múltiples transformaciones (sucesivas o no) para las mismas Condiciones u Origen.

3.1 . Inyección de parámetro
Esta Transformación recibe un hash que representa nuevos valores para los parámetros del método.
Al momento de ser invocado, los parámetros con nombres definidos en el hash deben ser sustituidos por los valores presentes en el mismo.

class MiClase
  def hace_algo(p1, p2)
    p1 + '-' + p2
  end
  def hace_otra_cosa(p2, ppp)
    p2 + ':' + ppp
  end
end

Aspects.on MiClase do
  transform(where has_parameters(1, /p2/)) do
    inject(p2: 'bar')
  end
end

instancia = MiClase.new
instancia.hace_algo("foo")
# "foo-bar"

instancia.hace_algo("foo", "foo")
# "foo-bar"

instancia.hace_otra_cosa("foo", "foo")
# "bar:foo"


Si el valor a inyectar es un Proc, no se debe inyectar el Proc, sino el resultado de ejecutarlo
, pasando como parámetros al objeto receptor del mensaje, el selector del método y el parámetro original.


class MiClase
  def hace_algo(p1, p2)
    p1 + "-" + p2
  end
end

Aspects.on MiClase do
  transform(where has_parameters(1, /p2/)) do
    inject(p2: proc{ |receptor, mensaje, arg_anterior|
      "bar(#{mensaje}->#{arg_anterior})"
    })
  end
end

MiClase.new.hace_algo('foo', 'foo')
# 'foo-bar(hace_algo->foo)'


3.2 . Redirección
Esta transformación recibe un objeto sustituto por parámetro.
Al momento de ser invocado el método, en lugar de ser ejecutado sobre el receptor original, debe ejecutarse sobre el sustituto.

class A
  def saludar(x)
    "Hola, " + x
  end
end

class B
  def saludar(x)
    "Adiosín, " + x
  end
end

Aspects.on A do
  transform(where name(/saludar/)) do
    redirect_to(B.new)
  end
end

A.new.saludar("Mundo")
# "Adiosín, Mundo"


3.3 . Inyección de lógica
Esta transformación recibe un bloque con una extensión al código del método original.
Cuando el método en cuestión sea invocado, el bloque recibido debe ejecutarse:
 Antes, Después o En Lugar De el código original del método.

class MiClase
  attr_accessor :x
  def m1(x, y)
   x + y
  end
  def m2(x)
   @x = x
  end
  def m3(x)
   @x = x
  end
end

Aspects.on MiClase do
transform(where name(/m1/)) do
 before do |instance, cont, *args|
   @x = 10
   new_args = args.map{ |arg| arg * 10 }
   cont.call(self, nil, *new_args)
 end
end

transform(where name(/m2/)) do
 after do |instance, *args|
   if @x > 100
     2 * @x
   else
     @x
   end
 end
end

transform(where name(/m3/)) do
 instead_of do |instance, *args|
   @x = 123
 end
end

end

instancia = MiClase.new
instancia.m1(1, 2)
# 30
instancia.x
# 10

instancia = MiClase.new
instancia.m2(10)
# 10
instancia.m2(200)
# 400

instancia = MiClase.new
instancia.m3(10)
instancia.x
# 123


Nota: Es posible aplicar múltiples transformaciones (sucesivas o no) para las mismas Condiciones u Origen.

class A
  def saludar(x)
    "Hola, " + x
  end
end

class B
  def saludar(x)
    "Adiosín, " + x
  end
end

Aspects.on B do
  transform(where name(/saludar/)) do
    inject(x: "Tarola")
    redirect_to(A.new)
  end
end

B.new.saludar("Mundo")
# "Hola, Tarola"

-----------------------------------------------------------------

Devs:
 - Fernando Petryszyn
 - Julieta Luzzi
 - Erwin Debusschere
 - Martin Loguancio