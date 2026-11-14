class Contenido{
    const property genero
    const property actoresProtagonistas = #{}

    method duracion()
    method fueVistoCompletoPor(usuario)

    method actuoProtagonista(unActor) = actoresProtagonistas.contains(unActor)
    method actuo(unActor) = self.actuoProtagonista(unActor)
}

class Series inherits Contenido{
    const temporadas = #{}

    override method duracion() = temporadas.sum({t => t.duracion()})

    method totalDeTemporadas() = temporadas.size()

    method ultimaTemporada() = temporadas.max({t => t.numeroDeTemporada()})

    method ultimoCapituloDeSerie() = self.ultimaTemporada().ultimoCapitulo()
    
    override method fueVistoCompletoPor(usuario) = temporadas.all({ t => t.fueVistoCompletoPor(usuario) })

    override method actuo(unActor) = super(unActor) or temporadas.any({t => t.actuo(unActor)})

    method fueEmpezadoPor(usuario) = temporadas.any({ t => t.fueEmpezadoPor(usuario) })



}

class Temporada{
    const serie
    const property capitulos = #{}
    const property numeroDeTemporada
    const property totalDeCapitulos
    
    method genero() = serie.genero()

    method fueVistoCompletoPor(usuario) = self.estanTodosLosCapitulos() and capitulos.all({c => c.fueVistoCompletoPor(usuario)})

    method estanTodosLosCapitulos() = capitulos.size() == totalDeCapitulos

    method duracion() = capitulos.sum({c => c.duracion()})
    method ultimoCapitulo() = capitulos.max({c => c.numeroDeCapitulo()})

    method actuo(unActor) = capitulos.any({c => c.actuo(unActor)})

    method esProtagonistaDeLaSerie(unActor) = serie.actuo(unActor)

    method fueEmpezadoPor(usuario) = capitulos.any({c => c.fueEmpezadoPor(usuario)})

    method estanCargadosTodosLosCapitulos() = totalDeCapitulos == capitulos.size()

    method estanCargadosBienLosCapitulo() = capitulos.all({num => self.tieneCapituloNumero(num)})

    method proximoCapitulo() = (capitulos.size()+1).min(totalDeCapitulos)

    method agregarCapitulo(unCapitulo) {
        self.validarAgregarCapitulo(unCapitulo)
        capitulos.add(unCapitulo)
    }

    method validarAgregarCapitulo(unCapitulo) {
        if (unCapitulo.numeroDeCapitulo() > totalDeCapitulos) {
            self.error("El número de capítulo supera el total de la temporada")
        }
        if (self.tieneCapituloNumero(unCapitulo.numeroDeCapitulo())) {
            self.error("El capítulo ya fue cargado")
        }
        if (not self.estanCargadosLosAnterioresA(unCapitulo.numeroDeCapitulo())) {
            self.error("Faltan cargar capítulos anteriores")
        }
    }

    method estanCargadosLosAnterioresA(unNumero) = (1 .. (unNumero - 1)).all({ num => self.tieneCapituloNumero(num) })

    method tieneCapituloNumero(unNumero) =
        capitulos.any({ c => c.numeroDeCapitulo() == unNumero })

    // 7b: Crear e incorporar un nuevo capítulo a la temporada
    method crearCapitulo(unaDuracion, unosActoresInvitados) {
        const nuevoCapitulo = new Capitulo(
            temporada = self,
            duracion = unaDuracion,
            numeroDeCapitulo = self.proximoNumeroDeCapitulo(),
            actoresInvitados = unosActoresInvitados
        )
        self.agregarCapitulo(nuevoCapitulo)
    }

    method proximoNumeroDeCapitulo() = capitulos.size() + 1
}

class Capitulo{
    const temporada
    const property duracion
    const property numeroDeCapitulo
    const actoresInvitados = []

    method genero() = temporada.genero() 

    method fueVistoCompletoPor(usuario) = usuario.vio(self)

    method actuo(unActor) = actoresInvitados.contains(unActor) or temporada.esProtagonistaDeLaSerie(unActor)

    method fueEmpezadoPor(usuario) = usuario.vio(self)

}

class Peliculas inherits Contenido{
    const property duracion

    override method fueVistoCompletoPor(usuario) = usuario.vio(self)


    method fueEmpezadoPor(usuario) = usuario.vio(self)    


}

class Usuario{
    const property contenidosVistos = #{}

    method vioCompleto(unContenido) = unContenido.fueVistoCompletoPor(self)

    method vio(unContenido) = contenidosVistos.contains(unContenido)

    method generosVistos() = contenidosVistos.map({c => c.genero()}).asSet()

    method minutosDe(genero) = contenidosVistos.filter({ c => c.genero() == genero}).sum({c => c.duracion()})  

    method generoPreferico() = self.generosVistos().max({g => self.minutosDe(g)})

    method esFanDe(unActor) = contenidosVistos.all({c => c.actuo(unActor)})

    method noVioCompleto(unContenido) = not self.vioCompleto(unContenido)

}

object repositorio{
    const usuarios = #{}
    const contenidos = #{}
    const destacados = #{}

    method fansDe(unActor) = usuarios.filter({u => u.esFanDe(unActor) })

    method recomendacion(usuario) = destacados + self.loQueNoVio(usuario)

    method loQueNoVio(usuario) = contenidos.filter({c => c.fueEmpezadoPor(usuario) and usuario.noVioCompleto(c)})


}