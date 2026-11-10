class Enfrentamiento{
    const property jugadores
    const terrorist = []
    const antiTerrorist = []

    method jugadores() = terrorist + antiTerrorist 

    method killsDe(jugador) = jugador.killsTotales()

    method vecesQueMurio(jugador) = jugador.cantidadDeVecesQueMurio()

    method eficienciaDe(jugador) = jugador.eficiencia()

    method saberMVP() = self.jugadores().max({j => j.eficiencia()})

    method iniciarPartida(){
        jugadores.forEach({j => j.crearAvatar()})
    }
}

class Jugador{
    const property nickname
    const avatares = []
    const historialDeCompras = []
    
    method killsTotales() = avatares.sum({a => a.eliminados().size()})
    method cantidadDeVecesQueMurio() = avatares.count({ a => !a.sobrevivio()})

    method crearAvatar(){
        if(self.esPrimeraRonda()){
            const avatar = new Avatar(
                plata = 800,
                equipamiento = [armaReglamentaria]
            )

            avatares.add(avatar)
        } else {

        } 


    }

    method esPrimeraRonda() = avatares.isEmpty()

    method eficiencia() = (self.killsTotales() - self.cantidadDeVecesQueMurio()).max(0)
}

class Avatar{
    var property plata
    var property equipamiento = []
    var property eliminados = []
    var property sobrevivio = true
    var primeraRoda = true


    method comprarEquipamiento(equipamientos){
        if(plata > equipamientos.costo()){
            equipamiento.addAll(equipamientos)
            plata -= equipamientos.costo()
        }
    }

    


    method kills() = eliminados.size()
    method vecesQueMurio() = if (sobrevivio) 0 else 1
    method eficiencia() = (self.kills() - self.vecesQueMurio()).max(0)


}

object armaReglamentaria{
    method costo() = 0
}

class Equipamiento {
    const property costo
}