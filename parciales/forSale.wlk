class Operacion{
    const property inmueble

    method comision()
}

class Alquiler inherits Operacion{
    const cantidadMeses

    override method comision() = (cantidadMeses/5000)*inmueble.valor()



}

class Venta inherits Operacion{

    override method comision() = inmueble.valor()*sistema.porcentaje()

}

class Inmueble{
    const metrosCuadrados
    const cantidadDeAmbientes
    const reserva // que cliente la reservó

    method valor()

    // method estaReservado() = not reserva
    
}

class Casa inherits Inmueble{
    const valorParticular

    override method valor() = valorParticular
}

class PH inherits Inmueble{

    override method valor() = (4000*metrosCuadrados).max(50000)
}

class Depto inherits Inmueble{

    override method valor() = 35000*cantidadDeAmbientes
}


class Cliente{
    const property intereses = [] 
}   

object sistema{
    const property registro = []
    const property agentes = #{}
    var property criterioDeMejorAgente = totalComision

    var property porcentaje = 1.5

    method mejorAgentePorComision() = agentes.max({ a => criterioDeMejorAgente.ponderacion(a)})

    method cambiarCriterio(newCriterio){
        criterioDeMejorAgente = newCriterio
    }

    method hayQueRenovarPersona() = agentes.all({a => a.tieneProblemaConAlguno(self.agentes())})

    
}


object totalComision{
    method ponderacion(agente) = agente.comisiones()
}

object cantidadOperacion {
    method ponderacion(agente) = agente.cantidadDeOperaciones()
}

object promedioPorOperacion {
    method ponderacion(agente) = agente.promedioPorOperacion()
}

class Agente{

    const property operaciones = #{}

    method comisiones() = operaciones.sum({o => o.comision()})

    method cantidadDeOperaciones() = operaciones.size()

    method promedioDeComisionPorOperacion() = if(operaciones.isEmpty()) 0 else self.comisiones()/self.cantidadDeOperaciones()

    method vaATenerPoblemaCon(otroAgente) = operaciones.any({o => self.opereSobre(o) && otroAgente.opereSobre(o)})

    method opereSobre(unInmueble) = operaciones.any({o => o.inmueble() == unInmueble})

    method tieneProblemaConAlguno(agentes) = agentes.any({a => a.vaATenerPoblemaCon(self)})

}