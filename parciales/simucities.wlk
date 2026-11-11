class Bloque{
    const vecinos

    method estaCeloso() = vecinos.all({ vecino => vecino.estaMejorQue(self)})

    method estaMejorQue(otroBloque) = self.tieneMejorEconomia(otroBloque) or self.tieneMasPlazas(otroBloque)

    method tieneMejorEconomia(otroBloque) = self.economia() > otroBloque.economia()

    method tieneMasPlazas(otroBloque) = self.cantidadPlazas() > otroBloque.cantidadPlazas()

    method tienePlazas() = self.cantidadPlazas() > 0

    method esFeliz() = self.tienePlazas() and self.menosPoblacionQueVecinos() and not self.estaCeloso()

    method menosPoblacionQueVecinos() = self.poblacionTotalVecinos() > self.cantidadHabitantes()

    method poblacionTotalVecinos() = vecinos.sum({ v => v.cantidadHabitantes()})

    method cantidadPlazas()
    method parquizar()
    method economia()
    method cantidadHabitantes()
    method modificarPoblacionUn(numero)

}

class BloqueResidencial inherits Bloque{
    const comercios = []
    var property cantidadHabitantes
    var property cantidadPlazas = 0
        

    override method parquizar(){
        cantidadPlazas += vecinos/10000
    }

    override method economia() = comercios.sum({ c => c.pdepines()})
    override method modificarPoblacionUn(numero){
        cantidadHabitantes += cantidadHabitantes*numero/100
    }

    method reorganizarEn(ciudad) {
        cantidadHabitantes = cantidadHabitantes / 2
        ciudad.nuevoBloqueResidencial(cantidadHabitantes)
    }
    
}

class BloqueIndustrial inherits Bloque{
    var produccion

    override method economia() = produccion*1000


}

class comercio{
    const property pdepines
}

class Ciudad{
    const property bloques = []
    var trimestres = []

    method poblacionTotal() = bloques.sum{ b => b.cantidadHabitantes() }

    method esVerde() = bloques.all({bloque => bloque.tienePlazas()})

    method parquizar() = bloques.forEach({bloque => bloque.parquizar()})

    method pbi() = bloques.sum({b => b.economia()})

    method pbiPerCapita() =  self.pbi() / self.poblacionTotal()

    method economiaEstaBien(){
        const ultimosTrimestres = self.ultimosTrimestres(2)
        return ultimosTrimestres.last().pbiPerCapita() > ultimosTrimestres.first().pbiPerCapita() and ultimosTrimestres.last().pbi() < self.pbiPerCapita() 
    }

    method registrarPBI() {
        const trimestre = new Trimestre(pbiPerCapita = self.pbiPerCapita())
        trimestres.add(trimestre)

    }

    method modificarPoblacion(numero){
        bloques.forEach({b => b.modificarPoblacionUn(numero)})
        self.bloquesSobrepoblados().forEach{ b => b.reorganizarEn(self) }
    }

    method bloquesSobrepoblados() = bloques.filter{ b => b.estaSobrepoblado() }

    method ultimosTrimestres(cantidad) = trimestres.reverse().take(cantidad).reverse()
    
    method nuevoBloqueResidencial(cantidadHabitantes) {
        const nuevoBloque = new BloqueResidencial(
          cantidadHabitantes=cantidadHabitantes, 
          vecinos = bloques.reverse().take(3))
        bloques.add(nuevoBloque)
    }

    method postTrimestre()

    method pasaEvento(evento){
        evento.aplicarEventoA(self) 

        self.postTrimestre()
    }
}

class Trimestre{
    const property pbiPerCapita
}

object cambioDePoblacion{
    method aplicarEventoA(ciudad){
        if(not ciudad.economiaEstaBien()){
            ciudad.modificarPoblacion(-1)
        } else {
            ciudad.modicarPoblacion(5)
        }
    }   

}

class CrecimientoEconomico{
    method aplicarEventoA(ciudad){
        if(ciudad.pbiPerCapita() > 600 && ciudad.economiaEstaBien()){
            
        }
    }
}
