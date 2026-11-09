/**/

// 1)
class Monstruo {
    const property objetosParticulares = []

    method objetosPorEspecie() = []
    
    method objetosNecesarios() = self.objetosPorEspecie() + objetosParticulares

    method serAtrapado(cazador) = self.objetosNecesarios().all({ obj => cazador.objetos().contains(obj) }) 
    
    method atacar(cazador){}

}

class Banshee inherits Monstruo {
    override method objetosPorEspecie() = ["hierro", "sal"]

    override method atacar(cazador){
        cazador.perderTodosLosObjetos()
    }
}

class Curupi inherits Monstruo {

    override method objetosPorEspecie() = ["hacha"]

    override method atacar(cazador){
        cazador.bajarDestrezaMitad()
    }
}

class LuzMala inherits Monstruo {
    override method atacar(cazador){
        cazador.reducirDestrezaSegunObjetos()
    
    }
}

class Djinn inherits Monstruo {
    override method atacar(cazador){
        if(cazador.haCazadoMonstruos()){
            cazador.modificarDestreza(1)
            cazador.liberarUltimoMonstruo()
        }
            
    }
}

class Vampiro inherits Monstruo{
    override method objetosPorEspecie() = ["estaca"]
}


class Cazador{
    var property destreza
    const property objetos = []
    const property monstruosAtrapados = []

    method atrapar(monstruo){

        if(monstruo.serAtrapado(self)){
            self.sumarMonstruoAtrapado(monstruo)
        } else {
            monstruo.atacar(self)
        }

    }

    method reducirDestrezaSegunObjetos(){
        self.modificarDestreza(-(objetos.size()))
    }

    method sumarMonstruoAtrapado(monstruo){
        monstruosAtrapados.add(monstruo)
    }

    method perderTodosLosObjetos(){
        objetos.clear()
    }

    method bajarDestrezaMitad(){
        destreza = destreza/2
    }

    method modificarDestreza(cantidad){
        destreza = (destreza + cantidad).max(0)
    }

    method haCazadoMonstruos() = !monstruosAtrapados.isEmpty()

    method liberarUltimoMonstruo(){
        monstruosAtrapados.remove(monstruosAtrapados.last())
    }

    method liberarUltimoObjeto(){
        objetos.remove(objetos.last())
    }

    method obtenerObjeto(objeto){
        objetos.add(objeto)
    }

    method irACaso(caso){
        caso.visitar(self)
    }

    method cantidadDeMonstruosAtrapados() = monstruosAtrapados.size()

    method monstruoMásJodido() = monstruosAtrapados.max({a => a.objetosNecesarios().size()}).objetosNecesarios().size()

    method monstruosQueSoloNecesitanUnObjeto() = monstruosAtrapados.filter({a => a.objetosNecesarios().size() == 1}).size()


}
// 2)
class Caso{
    const property monstruoInvolucrado 
}
class Crimen inherits Caso {

    method objetoUtil() = monstruoInvolucrado.objetosNecesarios().anyOne() // no se como conectarlo, diganme como

    method visitar(cazador){
        cazador.obtenerObjeto(self.objetoUtil())
    }

}

class Trampa inherits Caso{
    method visitar(cazador){
        cazador.liberarUltimoObjeto()
    }
}

class Avistaje inherits Caso{
    const puntosExtra

    method visitar(cazador){
        cazador.modificarDestreza(+puntosExtra)
    }

}

// 3)

class ConcursoCazadores{
    const cazadoresParticipantes = []
    const condicionDeInscripcion

    method saberTop3(criterio) = cazadoresParticipantes.sortBy({a, b => criterio.puntaje(a) > criterio.puntaje(b) }).take(3)

    method inscribir(cazador){
        if(condicionDeInscripcion.cumpleCondicion(cazador)){ 
            cazadoresParticipantes.add(cazador)
        }
    }


}

class CondicionACumplir {
    const monstruos

    method cumpleCondicion(cazador) = cazador.cantidadDeMonstruosAtrapados() > monstruos
}

object masMontruos{
    method puntaje(cazador1) {
        return cazador1.cantidadDeMonstruosAtrapados()
    }
}

object masJodido {
    method puntaje(cazador1) {  
        return cazador1.monstruoMásJodido() 
    }
}

object masHolgazan {
    method puntaje(cazador1) {
        return cazador1.monstruosQueSoloNecesitanUnObjeto()
    }
}

// 5)
class Kraken inherits Monstruo{
    override method serAtrapado(cazador) = super(cazador) and cazador.destreza() > 1000
}


// 5) no hay q hacer ningun cambio, solamente hacer un override al metodo de como ser atrapado y listo gracias al poliformismo y l ahrerencia y el uso del super.