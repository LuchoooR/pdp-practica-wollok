// 1)

class AntivirusPago {
    const property malwares = []

    method esMalware(programa) = malwares.contains(programa.nombre())

    method actualizarMalwares(malwaresNuevos){
        malwares.addAll(malwaresNuevos)
    }

}

class AntiVirusGratuito inherits AntivirusPago {
    const fechaActual
    const fechaExpiracion

    override method esMalware(programa) {
        if(self.estaVencido()){
            return false
        } else {
            return super(programa)
        }
    }
    method estaVencido() = fechaExpiracion < fechaActual
}

class AntiVirusTrial inherits AntivirusPago {
    const cantidadDeChequeosMax
    var cantidadActual

    override method esMalware(programa){
        if(cantidadActual < cantidadDeChequeosMax){
            cantidadActual+=1
            return super(programa)
        } else{
            return false
        }
    }

}


class Computadora{
    var property archivos = []
    const apps = []
    var antivirus 


    method agregarArchivo(archivo){
        archivos.add(archivo)
    }

    method eliminarArchivo(archivo){
        archivos.remove(archivo)
    }

    method instalarPrograma(programa){
        apps.add(programa)
    }

    method borrarTodosLosArchivos(){
        archivos.clear()
    }

    method desinstalarPrograma(programa){
        apps.remove(programa)
    }

    method agregarArchivos(_archivos){
        archivos.addAll(_archivos)
    }



    method ejecutar(programa) {
        if (self.tieneAntivirus() && antivirus.esMalware(programa)) {
            self.error("Ejecución interrumpida: es un malware")
        }
        programa.ejecutar(self)
    }

    
    method tieneArchivos() = !archivos.isEmpty() 

    method tieneAntivirus() = antivirus != null
}


// 2)

class Archivo {
    var property nombreArchivo

    method peso()

    method ciberAtaque(virus){}
}


class Texto inherits Archivo{
    var property contenido 

    override method peso() = (nombreArchivo.length() + contenido.size())/5

    override method ciberAtaque(virus){
        contenido = virus.nombre()
    }
}

class Imagen inherits Archivo{
    var alto
    var ancho

    override method peso() = (self.resolucion())/100

    method resolucion() = alto*ancho

    override method ciberAtaque(virus){
        const aux = alto
        alto = ancho
        ancho = aux
        nombreArchivo = "Brad Pitt dentro de un caballo de madera gigante"
    }

}

class Musica inherits Archivo {
    const nombreCancion
    var property artista
    const property anioSalida 
    const property peso

    override method nombreArchivo() = nombreCancion + " - " + artista


    override method ciberAtaque(virus){
        if(nombreCancion != "Pronta Entrega"){
            artista = virus.nombre()
        }
    }
}

// 3)

class Programa{
    const property nombre

    method ejecutar(compu) {
        const archivo = new Texto(
            nombreArchivo = "datos." + nombre,
            contenido = "información muy importante para el trabajo"
        )

        compu.agregarArchivo(archivo)
            
    }


}

class Virus{
    const property nombre

    method ejecutar(compu){
        compu.archivos().forEach({p => p.ciberAtaque(self)})
    }
}

class Ransomware {
  const property nombre
  const property bitcoins
  const property cuentaADepositar
  var property archivosCopy = []

  method ejecutar(compu) {
    if (self.encontrarComprobanteDePago(compu)) {
      compu.agregarArchivos(archivosCopy)
      archivosCopy = []
    } 
    else if (compu.tieneArchivos() and not self.tieneArchivoREADME(compu)) {
      archivosCopy = compu.archivos()
      compu.borrarTodosLosArchivos()
      compu.agregarArchivo(self.crearArchivoREADME())
    } 
    else {
      throw new DomainException(message = "No se pudo realizar el rescate ni hay archivos nuevos para cifrar.")
    }
  }

  method tieneArchivoREADME(compu) = 
    compu.archivos().any({ archivo => archivo.nombreArchivo() == "README" })

  method encontrarComprobanteDePago(compu) = 
    compu.archivos().any({ archivo => archivo.nombreArchivo() == "Comprobante de pago" and archivo.contenido() == cuentaADepositar })

  method crearArchivoREADME() = 
    new Texto(
      nombreArchivo = "README", 
      contenido = "Depositar " + bitcoins + " en esta cuenta: " + cuentaADepositar
    )
}


// 6)

object theUltimateAntivirusBenchmark{
    var property listaDeProgramas = []
    var property listaDeMalwares = []


    method elegirMejorAntivirus(antiviruses) = antiviruses.max({a => self.cantidadDeAciertos(a) })

    method cantidadDeAciertos(antivirus){
        return self.cantidadDeAciertosMalwares(antivirus) + self.cantidadDeAciertosProgramasNormales(antivirus)
    }


    method cantidadDeAciertosProgramasNormales(antivirus){
        return listaDeProgramas.count({p => !antivirus.esMalware(p)})
    }

    method cantidadDeAciertosMalwares(antivirus){
        return listaDeMalwares.count({m => antivirus.esMalware(m)})
    }
    
}
