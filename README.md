#TADP - 2015 Metaprogramacion

[Link al dashboard de Waffle](https://waffle.io/TAdP-Grupo3/Tp1-Metaprogramacion/join)

[Enunciado](https://docs.google.com/document/d/1eF2wDjBPDy2XH4Wc4V6PzIfVyj2Vz2DCRO99lt-q-GY/edit)

--------

Framework de AOP (Aspect Oriented Programming) para Ruby

1 . Origenes
2 . Condiciones
3 . Transformaciones

1 . Origenes
Llamaremos "Origen" a uno o m�s objetos, m�dulos o clases sobre cuyos m�todos nos interesa realizar transformaciones.

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
# ArgumentError: origen vac�o

Aspects.on /NombreDeClaseQueNoExiste/, /NombreDeClaseQueS�Existe/ do
  # ...
end
# Exito!


2 . Condiciones

Permite filtrar los m�todos de un Origen en donde realizar una transformaci�n.
Para eso deben implementarse una serie de Condiciones que permitan filtrar los m�todos sobre los cuales actuar.

Implementa un mensaje where, accesible desde dentro del contexto de los Or�genes, que recibe un conjunto de condiciones por par�metro.
Los m�todos retornados no solo ser�n aquellos definidos en la clase o m�dulo inmediato, sino todos los de su jerarqu�a.

Aspects.on MiClase, miObjeto do
  where <<Condicion1>>, <<Condicion2>>, ..., <<CondicionN>>
  # Retorna los m�todos que entienden miObjeto y las instancias de MiClase
  # que cumplen con todas las condiciones pedidas
end

Las Condiciones que deben ser soportadas se listan a continuaci�n
(Aunque esta lista podr�a crecer en el futuro).

2.1 . Selector
Esta condici�n se cumple cuando el selector del m�todo respeta una cierta regex.

class MiClase
  def foo
  end

  def bar
  end
end

Aspects.on MiClase do
  where name(/fo{2}/)
  # array con el m�todo foo (bar no matchea)

  where name(/fo{2}/), name(/foo/)
  # array con el m�todo foo (foo matchea ambas regex)

  where name(/^fi+/)
  # array vac�o (ni bar ni foo matchean)

  where name(/foo/), name(/bar/)
  # array vac�o (ni foo ni bar matchean ambas regex)
end

2.2 . Visibilidad
Se cumple si el m�todo es privado o p�blico.

class MiClase
  def foo
  end

  private

  def bar
  end
end

Aspects.on MiClase do
  where name(/bar/), is_private
  # array con el m�todo bar

  where name(/bar/), is_public
  # array vac�o
end

2.3 . Cantidad de Par�metros
Debe poder establecerse una condici�n que se cumpla si el m�todo tiene exactamente N par�metros obligatorios, opcionales o ambos.

class MiClase
 def foo(p1, p2, p3, p4='a', p5='b', p6='c')
 end
 def bar(p1, p2='a', p3='b', p4='c')
 end
end

Aspects.on MiClase do
  where has_parameters(3, mandatory)
  # array con el m�todo foo

  where has_parameters(6)
  # array con el m�todo foo

  where has_parameters(3, optional)
  # array con los m�todos foo y bar
end

2.4 . Nombre de Par�metros
Esta condici�n se cumple si el m�todo tiene exactamente N par�metros cuyo nombre cumple cierta regex.

class MiClase
  def foo(param1, param2)
  end

  def bar(param1)
  end
end

Aspects.on MiClase do
  where has_parameters(1, /param.*/)
  # array con los el m�todo bar

  where has_parameters(2, /param.*/)
  # array con el m�todo foo

  where has_parameters(3, /param.*/)
  # array vac�o
end

2.5 . Negaci�n
Esta condici�n recibe otras condiciones por par�metro y se cumple cuando ninguna de ellas se cumple.

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
  # array con los m�todos foo2 y foo3
end

Nota: Usamos �neg� como nombre de la condici�n en vez de �not� porque el �not� de Ruby toma precedencia.


3 . Transformaciones

Se pueden aplicar transformaciones sobre los m�todos que matchean todas las condiciones.

Aspects.on MiClase, miObjeto do
  transform(where <<Condicion1>>, <<Condicion2>>, ..,<<CondicionN>>) do
    <<Transformaci�n1>>
    <<Transformaci�n2>>
    ...
  end
end

Las Transformaciones soportadas se listan a continuaci�n
(Aunque esta lista podr�a crecer en el futuro)

Se pueden aplicar m�ltiples transformaciones (sucesivas o no) para las mismas Condiciones u Origen.

3.1 . Inyecci�n de par�metro
Esta Transformaci�n recibe un hash que representa nuevos valores para los par�metros del m�todo.
Al momento de ser invocado, los par�metros con nombres definidos en el hash deben ser sustituidos por los valores presentes en el mismo.

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
, pasando como par�metros al objeto receptor del mensaje, el selector del m�todo y el par�metro original.


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


3.2 . Redirecci�n
Esta transformaci�n recibe un objeto sustituto por par�metro.
Al momento de ser invocado el m�todo, en lugar de ser ejecutado sobre el receptor original, debe ejecutarse sobre el sustituto.

class A
  def saludar(x)
    "Hola, " + x
  end
end

class B
  def saludar(x)
    "Adios�n, " + x
  end
end

Aspects.on A do
  transform(where name(/saludar/)) do
    redirect_to(B.new)
  end
end

A.new.saludar("Mundo")
# "Adios�n, Mundo"


3.3 . Inyecci�n de l�gica
Esta transformaci�n recibe un bloque con una extensi�n al c�digo del m�todo original.
Cuando el m�todo en cuesti�n sea invocado, el bloque recibido debe ejecutarse:
 Antes, Despu�s o En Lugar De el c�digo original del m�todo.

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


Nota: Es posible aplicar m�ltiples transformaciones (sucesivas o no) para las mismas Condiciones u Origen.

class A
  def saludar(x)
    "Hola, " + x
  end
end

class B
  def saludar(x)
    "Adios�n, " + x
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