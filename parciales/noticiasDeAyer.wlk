class Noticia {
    const property fechaDePublicacion
    const property personaQuePublica
    var property gradoDeImportancia
    const property titulo
    const property desarrollo

    method esCopada() = self.esImportante() && self.esReciente() 

    method esImportante() = gradoDeImportancia >= 8
    method esReciente() = (new Date() - fechaDePublicacion) < 3

    method esSensacionalista() = self.palabrasSensacionalistas().any({ palabra => titulo.contains(palabra) })
    method palabrasSensacionalistas() = ["espectacular", "increíble", "grandioso"]

    method esChivo() = false
    method tieneDesarrolloCorto() = desarrollo.words().size() < 100
    method empiezaCon(letra) = titulo.startsWith(letra)
    method estaBienEscrita() = titulo.words() >= 2 && !desarrollo.isEmpty() 

    method esDeLaUltimaSemana() = (new Date() - fechaDePublicacion) <= 7
}

class Articulo inherits Noticia{
    const property links = []
    override method esCopada() = super() and self.tieneVariosLinsk()

    method tieneVariosLinsk() = links.size() >= 2
}

class Chivo inherits Noticia{
    var property productoPromocionado
    var property plata

    override method esCopada() = super() and self.muchaPlata()

    method muchaPlata() = plata > 2000000

    override method esChivo() = true

} 

class Reportaje inherits Noticia{
    const property personaReportada

    override method esCopada() = super() and self.esImparSuNombre()

    override method esSensacionalista() = super() && personaReportada == "Dibu Martinez"

    method esImparSuNombre() = personaReportada.size().odd()

    

}

class Cobertura inherits Noticia{
    const property noticias = [] 

    override method esCopada() = super() and noticias.all({n => n.esCopada()})
}

// 2)
class Periodista{
    const property fechaDeIngreso
    const property noticiasPublicadas = []
    var property preferencia

    method prefierePublicar(noticia) = preferencia.leGusta(noticia) 

    method publicarNoticia(noticia){
        if(noticia.estaBienEscrita()){
            if(self.prefierePublicar(noticia)){
            noticiasPublicadas.add(noticia)
        } else {
            if(noticiasPublicadas.count({n => !self.prefierePublicar(n) and n.fechaDePublicacion() == noticia.fechaDePublicacion()}) < 2){
                noticiasPublicadas.add(noticia)
            } else {
                throw new Exception(message="ya publicó 2 noticias que no le gusten")
            }
        }
        } else {
            throw new Exception(message="la noticia no está bien escrita, no se puede publicar")
        }
        
    }

    method publicoEnLaUltimaSemana() = noticiasPublicadas.any({n => n.esDeLaUltimaSemana()})

    method esReciente() = (new Date() - fechaDeIngreso) <= 365
}

object copado{
    method leGusta(noticia) = noticia.esCopada()

}

object sensacionalista {
    method leGusta(noticia) = noticia.esSensacionalista()
}

object vago {
    method leGusta(noticia) = noticia.esChivo() || noticia.tieneDesarrolloCorto()
}

object joseDeZer { 
    method leGusta(noticia) = noticia.empiezaCon("T")
}

// 4)
class Multimedio {
    const periodistas = []

    method periodistasRecientes() = periodistas.filter({p => p.esReciente() and p.publicoEnLaUltimaSemana()})
}

