object pepita {
  var energia = 100
  var lugar = buenosAires

  method energia() = energia

  method volar(km) {
    energia = (energia - km - 10).max(0)
  }

  method comer(g){
    energia = energia + (g*4)
  }

  method lugar() = lugar

  method viajar(nuevoLugar) {
    self.volar(lugar.distanciaA(nuevoLugar))
    lugar = nuevoLugar  
  }

  method puedeIrA(nuevoLugar) {
    const costoDeViaje = lugar.distanciaA(nuevoLugar) + 10 
    return energia >= costoDeViaje
  }
}


object buenosAires {
  method kilometro() = 0
  method distanciaA(unLugar) = (self.kilometro() - unLugar.kilometro()).abs()
}

object rosario {
  method kilometro() = 287
  method distanciaA(unLugar) = (self.kilometro() - unLugar.kilometro()).abs()
}

object cordoba {
  method kilometro() = 400
  method distanciaA(unLugar) = (self.kilometro() - unLugar.kilometro()).abs()
  }

