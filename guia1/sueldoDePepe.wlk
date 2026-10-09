object sueldo{
    var puesto = gerente
    var diasQueFalto = 0
    var bonoPorPresentismo = bonoPresentismo
    var bonoPorResultado = 0

    method puesto() = puesto
    method categoria() = puesto.neto()
    method diasQueFalto() = diasQueFalto

    
    method cambiarDeCategoria(nuevoPuesto) {
        puesto = nuevoPuesto
    }

    method cambiarDeBonoPorPresentismo(nuevoPreBono) {
        bonoPorPresentismo = nuevoPreBono
    }

    method cambiarDeBonoPorResultado(nuevoResBono) {
        bonoPorResultado = nuevoResBono
    }

    method calcularSueldo() {
        return self.categoria() + bonoPorPresentismo.importe(self)         
    }
}


object gerente{
    method neto() {
        return 1000
    }
}

object cadetes{
    method neto() {
        return 1500
    } 
}

object bonoPresentismo {
    method importe(persona) {

    }
}

object bonoNuloPresentismo {
    method importe() = 0
}

object bonoPorcentual {
  
}

object bonoFijo {
  
}

object bonoNulo {

}