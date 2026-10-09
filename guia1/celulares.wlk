object juliana {
    var celular = samsungS21
    var compania = personal
    var costo = 0

    method estaApagadoMiCelular() = celular.estaApagado()
    
    method cargarCelular(){
        celular.recargar()
    }

    method llamar(minutos){
        costo += compania.cobro(minutos)
        celular.usar()
    }

    method cuantoGaste() = costo

    method cambiarDeCompania(newCompania){
        compania = newCompania
    }


}



object catalina {
    var celular = iPhone
    var compania = movistar
    var costo = 0

    method estaApagadoMiCelular() = celular.estaApagado()
    
    method cargarCelular(){
        celular.recargar()
    }
    
    method llamar(minutos){
        costo += compania.cobro(minutos)
        celular.usar(minutos)
    }

    method cuantoGaste() = costo

    method cambiarDeCompania(newCompania){
        compania = newCompania
    }

}

object samsungS21 {
    var bateria = 5

    method mirarBateria() = bateria

    method estaApagado() = (bateria == 0)

    method recargar() {
      bateria = 5
    }

    method usar(){
      bateria = 0.max(bateria - 0.25) 
    }

}

object iPhone {
    var bateria = 5

    method mirarBateria() = bateria

    method estaApagado() = (bateria == 0)

    method recargar() {
      bateria = 5
    }

    method usar(minutos) {
        bateria = 0.max(bateria - (0.1 * minutos))
    }

}

object movistar{
    method cobro(minutos){
        return 60*minutos
    }
}

object claro{
    method cobro(minutos){
        return (50*minutos)*1.21
    }
}

object personal{
    method cobro(minutos){
        if (minutos >= 10){
            var resto = minutos - 10
            return (10*70) + (resto*40)
        } else {
            return minutos*70
        }   
    }
}