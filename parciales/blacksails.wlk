class Embarcacion{
    var property capitan
    var property contramaestre
    const tripulacionGeneral = []
    const property caniones = []
    var property ubicacion
    var property botin

    method tripulacionTotal() = tripulacionGeneral + [capitan, contramaestre]

    method poderDeDanio() = self.totalDeCoraje() + self.totalDePoderDeCaniones()

    method totalDeCoraje() = self.tripulacionTotal().sum({p => p.coraje()})

    method totalDePoderDeCaniones() = caniones.sum({c => c.danio()})
 
    method elMasCorajudo() = tripulacionGeneral.max({t => t.coraje()})
    method masCorajudos(cantidad) = self.ordenarPorCoraje().take(cantidad)

    method puedeEntrarEnConflictoCon(otraEmbarcacion) = ubicacion.estaEnElMismoMarQue(otraEmbarcacion.ubicacion()) && ubicacion.estaCercaDe(otraEmbarcacion.ubicacion())

    method reemplazarCapitan(pirata){
        capitan = pirata
    }

    method aumentarCoraje(numero){  
        self.tripulacionTotal().forEach({p => p.aumentarCorajeBase(numero)})
    }

    method eliminarCobardes(numero){
        const tripulantesAMorir = self.ordenarPorCoraje().reverse().take(numero)
        tripulacionGeneral.removeAll(tripulantesAMorir)
    }

    
    method ascenderAContramaestre(){
        contramaestre = self.elMasCorajudo()
        tripulacionGeneral.remove(contramaestre)

    }

    method eliminarPiratas(piratas){
        tripulacionGeneral.removeAll(piratas)
    }

    method ordenarPorCoraje() = tripulacionGeneral.sortedBy({ p1, p2 => p1.coraje() > p2.coraje()})


    method transferirMasCorajudos(numero, otraEmbarcacion){
        const masCorajudos = self.masCorajudos(numero)
        tripulacionGeneral.removeAll(masCorajudos)
        otraEmbarcacion.agregarATripulacion(masCorajudos)
    }

    method agregarATripulacion(nuevosTripulantes){
        tripulacionGeneral.addAll(nuevosTripulantes)
    }

    method tieneHabilNegociador() = self.tripulacionTotal().any({p => p.nivelInteligencia() > 50})

    method pierdeMitadDeBotin(){
        botin -= self.mitadBotin()
    }

    method agregarBotin(newBotin){
        botin += newBotin
    }

    method mitadBotin() = botin/2
 

    method generarMotin(){

        if(self.capitanResisteElMotin()){
            contramaestre.perderTodasSusArmas()
            contramaestre.aniadirEspadaDesafilada()
            tripulacionGeneral.add(contramaestre)
        } else {
            capitan = contramaestre
        }


        self.ascenderAContramaestre()   
    }

    method capitanResisteElMotin() = capitan.coraje() >= contramaestre.coraje()

    method envejecerCaniones(anios) {
        caniones.forEach({c => c.pasarAnio(anios)})
    }
}

class Contienda{

    method contienda(embarcacion1, embarcacion2) = embarcacion1.puedeEntrarEnConflictoCon(embarcacion2) && self.cumpleOtraCondicion(embarcacion1, embarcacion2)

    method cumpleOtraCondicion(embarcacion1, embarcacion2)
    method tomar(embarcacion1, embarcacion2)

    method validarToma(embarcacion1, embarcacion2) {
        if (not self.contienda(embarcacion1, embarcacion2)){
            throw new Exception(message="no se puede realizar la " + self.kindName())
        }
    }


}

object batalla inherits Contienda{

    override method cumpleOtraCondicion(embarcacion1, embarcacion2) = embarcacion1.poderDeDanio() > embarcacion2.poderDeDanio()
    
    override method tomar(embarcacion1, embarcacion2){
        self.validarToma(embarcacion1, embarcacion2)

        embarcacion1.aumentarCoraje(5)
        embarcacion2.eliminarCobardes(3)
        embarcacion2.reemplazarCapitan(embarcacion1.contramaestre())
        embarcacion1.ascenderAContramaestre()
        embarcacion1.transferirMasCorajudos(3, embarcacion2)        
    }

}


object negociacion inherits Contienda{

    override method cumpleOtraCondicion(embarcacion1, embarcacion2) = embarcacion1.tieneHabilNegociador()

    override method tomar(embarcacion1, embarcacion2){
        self.validarToma(embarcacion1, embarcacion2)

        const newBotin = embarcacion2.mitadBotin()
        embarcacion2.pierdeMitadDeBotin()
        embarcacion1.agregarBotin(newBotin)
    }
}
class Canion{
    
    const property nivelDeDanio // = 350
    var property anioDeAntiguedad = 0

    method danio() = (nivelDeDanio * (1 - anioDeAntiguedad / 100)).max(0)

    method pasarAnio(anios){
        anioDeAntiguedad+=anios
    }

    

}

object canion {
  var property valorActualDanioFabricacion = 350

  method fabricar() = new Canion(nivelDeDanio=valorActualDanioFabricacion)

}

class Ubicacion{
    const property nombreMar
    const property posX 
    const property posY

    method estaEnElMismoMarQue(otraEmbarcacion) = self.nombreMar() == otraEmbarcacion.nombreMar()

    method estaCercaDe(otraEmbarcacion) = self.distanciaA(otraEmbarcacion) < conflicto.distanciaMaxima()
  
    method distanciaA(otra) = ((posX - otra.posX()).square() + (posY - otra.posY()).square()).squareRoot()    


}

object conflicto {
    var property distanciaMaxima = 88
}

class Pirata{
    var property corajeBase
    const property armas = [] 
    var property nivelInteligencia


    method coraje() = armas.sum({a => a.danio(self)}) + self.corajeBase()

    method aumentarCorajeBase(numero){
        corajeBase += numero
    }

    method perderTodasSusArmas(){
        armas.clear()
    }

    method aniadirEspadaDesafilada(){
        const espadaDesafilada = new Espada(
            danio = 1
        )
        armas.add(espadaDesafilada)
    }


}

object cuchillo{
    const danio = 8
    method danio(pirata) = danio // = danioElegido 
}

class Espada{
    const danio 
    method danio(pirata) = danio
}

class Pistola {
  const calibre
  const material

  method danio(pirata) = calibre * indicesMateriales.indicePara(material)

}

object indicesMateriales {
  method indicePara(material) = material.length() //TODO VER LISTA ROBADA
}


class Insulto{
    const frase 

    method danio(pirata) = frase.words().size()*pirata.corajeBase()
}

class Bestia {
    const property nivelDeFuerza

    method atacar(embarcacion){
        if(self.puedeAtacar(embarcacion)){
            self.sufreDanios(embarcacion)
        }
    }

    method puedeAtacar(embarcacion) = nivelDeFuerza > embarcacion.poderDeDanio()

    method sufreDanios(embarcacion)

}

class BallenaAzul inherits Bestia{
    override method sufreDanios(embarcacion){
        embarcacion.envejecerCaniones(8)
    }
}

class TiburonesBlancos inherits Bestia{
    const miedo

    override method sufreDanios(embarcacion){
        embarcacion.aumentarCoraje(-miedo)
    }
}

object kraken inherits Bestia(nivelDeFuerza = 100000){
    
    override method sufreDanios(embarcacion){
        const losMasCorajudos = embarcacion.masCorajudos(5)
        embarcacion.eliminarPiratas(losMasCorajudos)
    }
}
