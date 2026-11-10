class Usuario {
    var property calificacion = 5
    var acciones = [] //eventos o actividades


    method subirCalificacion(usuario){
        calificacion += (usuario.calificacion()*0.10).min(5)
    }

    method bajarCalificaicon(usuario){
        calificacion -= (usuario.calificacion()*0.12).max(1)
    }

    //1.a)
    method puedeRealizar(accion) = accion.puedeRealizar(self)

    //1.b)
    method notaHipotetica(accion, usuario) {

        if (Evaluador.comparar(self, accion)){
            return (usuario.calificacion() + (self.calificacion() * 0.10)).min(5)
        } else{
            return (usuario.calificacion() - (self.calificacion() * 0.12)).max(1)
        }

    }

    method calificar(accion, calificado){
        calificado.calificacion(self.notaHipotetica(accion, calificado))
        //calificacion = self.notaHipotetica(accion, usuario)
    }

    method realizar(accion) {
      if(self.puedeRealizar(accion)){
        acciones.add(accion)
        accion.aplicarConsecuencias(self)
      } else {
        throw new Exception(message="no puede realizar la acción")
      }
    }

    method cualEsLaMasPopular() = acciones.max({a => a.popular()})

}

class Evento{
    var tipo

    method calificacionMinima() = 4 

    method puedeRealizar(usuario) = usuario.calificacion() >= self.calificacionMinima()

    method popular() = self.calificacionMinima()

    method aplicarConsecuencias(usuario){}
}

class Actividad{
    const property interesados = []

    method puedeRealizar(usuario) = true

    method aplicarConsecuencias(usuario) {
      interesados.forEach({i => i.calificar(self, usuario)})
    }

    method popular() = 
}
class Evaluador{
    method comparar(usuario, accion)
}

object rateMe {
    method quienesPuedeRealizar(accion, usuarios){
        return usuarios.filter({u => accion.puedeRealizar(u)})
    }
}