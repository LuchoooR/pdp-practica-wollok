class Usuario {
    var property calificacion
    var property acciones = [] //eventos o actividades


    method subirCalificacion(usuario){
        return (usuario.calificacion() + (self.calificacion() * 0.10)).min(5)
    }

    method bajarCalificacion(usuario){
        return (usuario.calificacion() - (self.calificacion() * 0.12)).max(1)
    }

    //1.a)
    method puedeRealizar(accion) = accion.puedeRealizar(self)

    //1.b)
    method notaHipotetica(accion, calificado) {
        return self.notaHipoteticaSinLimites(accion, calificado).max(1).min(5)
    }

    method notaHipoteticaSinLimites(accion, usuario) {
        if (self.aprueba(accion, self)){
            return (usuario.calificacion() + (self.calificacion() * 0.10))
        } else{
            return (usuario.calificacion() - (self.calificacion() * 0.12))
        }

    }

    method aprueba(accion, usuario) = Evaluador.comparar(self, accion)

    method calificar(accion, calificado){
        calificado.calificacion(self.notaHipotetica(accion, calificado))
        //calificacion = self.notaHipotetica(accion, usuario)
    }

    method realizar(accion) {
      if(self.puedeRealizar(accion)){
        accion.aplicarConsecuencias(self)
        acciones.add(accion)
        
      } else {
        throw new Exception(message="no puede realizar la acción")
      }
    }

    method cualEsLaMasPopular(usuario) = acciones.max({a => a.popular(self)})

}



class Famosito inherits Usuario{
    var criterio

    method cambiar(criterioNew){
        criterio = criterioNew
    }


    override method notaHipotetica(accion, usuario) {
        if(criterio.comparar(self, accion, usuario)){
            return (usuario.calificacion() + (self.calificacion() * 0.10)).min(5)
        } else{
            return (usuario.calificacion() - (self.calificacion() * 0.12)).max(1)
        }
      
    }

    override method aprueba(accion, usuario) = criterio.comparar(self, accion, usuario)
}

object admiracion{
    method comparar(famosito, accion, usuario) = famosito.calificacion() < usuario.cualEsLaMasPopular(usuario).popular(usuario)
}

object envidia {
    method comparar(famosito, accion, usuario) = usuario.acciones().size() <= famosito.acciones().size()
}

class Evento{
    var tipo

    method calificacionMinima() = 4 

    method puedeRealizar(usuario) = usuario.calificacion() >= self.calificacionMinima()

    method popular(usuario) = self.calificacionMinima()

    method aplicarConsecuencias(usuario){}
}

class Actividad{
    const property interesados = []

    method puedeRealizar(usuario) = true

    method aplicarConsecuencias(usuario) {
      interesados.forEach({i => i.calificar(self, usuario)})
    }

    method popular(usuario) = interesados.sum({i => i.notaHipoteticaSinLimites(self, usuario)})


}
class Evaluador{
    method comparar(usuario, accion)
}

object rateMe {
    method quienesPuedeRealizar(accion, usuarios){
        return usuarios.filter({u => accion.puedeRealizar(u)})
    }

    method simularItinerario(usuario, acciones){
        const simulado = usuario.copy()

        acciones.filter({a => simulado.puedeRealizar(a)}).forEach({a => simulado.realizar(a)})
    
        return simulado
    }
}