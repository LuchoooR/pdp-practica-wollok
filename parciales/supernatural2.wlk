
class Monstruo{
    const property objetosParticulares = []
    
    method objetosPorEspecie() = []
    
    method objetosNecesarios() = self.objetosPorEspecie() + objetosParticulares

    method puedeSerAtrapadoPor(cazador) = self.objetosNecesarios().all({ o => cazador.tieneObjeto(o)})

    method atacar(cazador)

    method cantidadObjetos() = self.objetosNecesarios().size()


}

class Banshee inherits Monstruo{

    override method objetosPorEspecie() = ["hierro","sal"]    

    override method atacar(cazador){
        cazador.perderTodosObjetos()
    }

}

class Curupí inherits Monstruo{

    override method objetosPorEspecie() = ["hacha"]

    override method atacar(cazador){
        cazador.bajarDestrezaMitad()
    }

}
class LuzMala inherits Monstruo{

    override method atacar(cazador){
        cazador.modificarDestrezaEn(-(cazador.objetos().size()))
    }

}
class Djinn inherits Monstruo{

    override method atacar(cazador){
        if(not cazador.noCazoANinguno()){
            cazador.modificarDestrezaEn(1)
            cazador.liberarUltimoMonstruo()
        }
        
    }

}

class Cazador{
    const property monstruosCazados = []
    const property objetos = []
    var nivelDeDestreza

    method noCazoANinguno() = monstruosCazados.isEmpty()

    method tieneObjeto(objeto) = objetos.contains(objeto)

    method liberarUltimoMonstruo(){
        const ultimoMonstruo = monstruosCazados.last()
        monstruosCazados.remove(ultimoMonstruo)
    }

    method cazarMonstruo(monstruo){
        monstruosCazados.add(monstruo)
    }

    method bajarDestrezaMitad(){
        nivelDeDestreza = nivelDeDestreza/2
    }

    method modificarDestrezaEn(numero){
        nivelDeDestreza += numero
    }

    method perderTodosObjetos(){
        objetos.clear()
    }

    method perderObjeto(objeto){
        objetos.remove(objeto)
    }

    method agregarObjeto(objeto){
        objetos.add(objeto)
    }

    method ultimoObjetoEncontrado() = objetos.last()

    method cazar(monstruo){
        if(monstruo.puedeSerAtrapadoPor(self)){
            self.cazarMonstruo(monstruo)
        } else {
            monstruo.atacar(self)
        }
    } 

    method investigar(caso){
        caso.investigaEl(self)
    }

    method cantidadMonstruosCazados() = monstruosCazados.size()

    method monstruoMasJodidoObjetos() = monstruosCazados.max({m => m.cantidadObjetos()}).cantidadObjetos()

    method holgazan() = monstruosCazados.filter({m => m.cantidadObjetos() == 1}).size()
}


class Crimen{
    const objetoVulnerable

    method investigaEl(cazador){
        cazador.agregarObjeto(objetoVulnerable)
    }

}

class Trampa{

    method investigaEl(cazador){
        const objetoUltimo = cazador.ultimoObjetoEncontrado()
        cazador.perderObjeto(objetoUltimo)
    }

}

class Avistaje{
    const puntosExtra

    method investigaEl(cazador){
        cazador.modificarDestrezaEn(puntosExtra)
    }

}

class Concurso{
    const property cazadores = #{}
    var property tipo
    var property condicion

    method podioDeMas() = cazadores.sortedBy({cazador1, cazador2 => tipo.comparar(cazador1, cazador2)}).take(3)


    method registrar(cazador){
        if(condicion.cumpleConCondicion(cazador)){
            cazadores.add(cazador)
        } else {
            throw new Exception(message="no se pudo añadir")
        }
    }

}

class Condicion{

    method cumpleConCondicion(cazador) = true

}

object condicionRambo inherits Condicion{

    override method cumpleConCondicion(cazador) = cazador.monstruosCazados() >= 10

}

object masMonstruos{
    method comparar(cazador1, cazador2) = cazador1.cantidadMonstruosCazados() > cazador2.cantidadMonstruosCazados()
}

object monstruoMasJodido {
    method comparar(cazador1, cazador2) = cazador1.monstruoMasJodidoObjetos() > cazador2.monstruoMasJodidoObjetos()
}

object masHolgazan {
    method comparar(cazador1, cazador2) = cazador1.holgazan() > cazador2.holgazan()
}

class Kraken inherits Monstruo{
    override method puedeSerAtrapadoPor(cazador) = super(cazador) and cazador.destreza() > 1000
}