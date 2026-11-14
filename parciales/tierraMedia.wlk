class Zona{
    const property region
    const property nombre
    const property zonasLimitrofes = #{}
    const property requerimientos = #{}
    const property esPantanosa = true

    method esLaZonaLimitrofeCon(otraZona) = zonasLimitrofes.contains(otraZona)

    method puedeSerAtravesadoPor(grupo) = requerimientos.all({r => grupo.cumplenCon(r)})

    // method requerimientos()
    
    // method cumpleConRequerimiento(viajero) = 


}

class Requerimiento{
    const cantidad
    
    method cumplenCon(grupo) = grupo.cantidadQueCumplenCon(self) >= cantidad

}

class RequerimientoIntegrante inherits Requerimiento{
    const razaRequerida
    const nivelMinimo

    method cumpleCon(viajero) = viajero.raza() == razaRequerida and viajero.nivel() >= nivelMinimo 

}

class RequerimientoElemento inherits Requerimiento {
    const nombreElemento

    method cumpleCon(viajero) = viajero.tengo(nombreElemento)

    override method cumplenCon(grupo) = grupo.cantidadDeElemento(nombreElemento) >= cantidad
}

class Camino{
    const property zonas = []

    method cuantasRegionesAtraviesa() = self.regionesDeLasZonas().size()

    method regionesDeLasZonas() = zonas.map({z => z.region()}).asSet()

    method agregarZona(newZona){
        if(self.puedeAgregarNewZona(newZona)){
            zonas.add(newZona)
        } else {
            throw new Exception(message="la zona no limita con el final del camino")
        }
        
    }

    method puedeAgregarNewZona(newZona) = zonas.isEmpty() or zonas.last().esLaZonaLimitrofeCon(newZona)

    method cantidadDeZonas() = zonas.size()

    method puedeSerAtravesadoPor(grupo) = zonas.all({z => z.puedeSerAtravesadoPor(grupo)})

    method conduceAMordor() = zonas.last().region().nombre() == "Mordor"

}

class Grupo{
    const property integrantes = #{}

    method puedeAtravesar(zona) = zona.puedeSerAtravesadoPor(self)

    method cumplenCon(requerimiento) = requerimiento.cumplenCon(self)

    method cantidadQueCumplenCon(requerimiento) = integrantes.count({i => i.cumpleConRequerimiento(requerimiento)})

    method todosLosObjetos() = integrantes.flatMap({ i => i.objetos() })

    method cantidadDeElemento(nombre) = self.todosLosObjetos().occurrencesOf(nombre)

    method seSienteEnCasa(region) = region.seSientenComoEnCasa(self)

    method integranteMasDebil() = integrantes.min({ i => i.nivel() })

    method borrarAlMenorNivel(){
        const integranteDebil = self.integranteMasDebil()
        integrantes.remove(integranteDebil)
    }

    method aumentarNivel(cantidad){
        integrantes.forEach({i => i.aumentarNivel(cantidad)})
    }

    method puedenAtravesarEl(camino) = camino.puedeSerAtravesadoPor(self)

    method atravesar(camino){
        if(self.puedenAtravesarEl(camino)){
            self.aumentarNivel(camino.cantidadDeZonas())
        } else {
            self.borrarAlMenorNivel()
        }
    }

}

class Ejercito inherits Grupo{
    const componentesEspeciales = []


    override method puedeAtravesar(zona) = super(zona) and componentesEspeciales.all({i => i.puedeAtravesar(zona)})

}

class Integrante{
    const property raza
    var property nivel
    const property objetos = []

    method tengo(objeto) = objetos.contains(objeto)

    method puedeAtravesar(zona) = raza.puedeAtravesar(zona)

    method cumpleConRequerimiento(requerimiento) = requerimiento.cumpleCon(self)

    method aumentarNivel(cantidad){
        nivel += cantidad
    }

}


object nazgul{
    method puedeAtravesar(zona) = true
}

class Catapultas {
    method puedeAtravesas(zona) = not zona.esPantanosa()
}



class Region{
    const property nombre
    const property zonas = #{}

    method esLimitrofeCon(otraRegion) = zonas.any({z => otraRegion.esZonaLimitrofeCon(z)})    
    //otraRegion.zonas().any({z => self.esZonaLimitrofeCon(z)}) // = zonas.any({z => z.esLaZonaLimitrofeCon()})
    
    
    method esZonaLimitrofeCon(otraZona) = zonas.any({z => z.esLaZonaLimitrofeCon(otraZona)}) 

    method seSientenComoEnCasa(grupo) = self.porcentajeDeZonasAtravesadasPor(grupo) >= tierraMedia.porcentajeParaSentirseEnCasa()

    method cantidadDeZonasAtravesadasPor(grupo) = zonas.count({z => z.puedeSerAtravesadoPor(grupo)})

    method porcentajeDeZonasAtravesadasPor(grupo) = self.cantidadDeZonasAtravesadasPor(grupo)*100/zonas.size()

}

object tierraMedia{

    const property caminos = []

    method todosLosCaminosConducenAMordor() = caminos.all({c => c.conduceAMordor()})

    var property porcentajeParaSentirseEnCasa = 75
}