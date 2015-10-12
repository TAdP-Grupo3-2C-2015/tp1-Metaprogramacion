
#Tecnicamente, para que funcione... necesito que sea una lambda el bloque que recibe before y hacer unas modificaciones mas.. pero casi que anda jaja
Aspects.on(Aspects.singleton_class) do
  transform where(has_name(/asOrigin/)) do
    before do |args|
      if args.is_a? Array
        if args.any? {|mod| mod.is_a? Class}
          klass = args.bsearch {|mod| mod.is_a? Class}
          modules = args.select {|mod| !mod.is_a? Class}
          if (modules - klass.ancestors).empty?
            return klass
          else
            return []
          end
        else
          return Object.constants.map {|sym| Object.const_get(sym)}.select{|const| (const.is_a? Class) && !args.include?(const)}.select {|constant| (args - constant.ancestors).empty? }
        end
      end
    end
  end
end

#Sino, abriendo Aspects y modificando asOrigin de la misma forma que esta en el bloque o similar.
#Fuera de eso, tuve un por menor en que no filtraba que las ocnstantes fueran clases o modulos, y que no estuviera incluido en lo que recibo
