object silla1 {
    method peso() = 90
}

object silla2 {
    method peso() = 85
}

object televisor1 {
    method peso() = 6
}

object televisor2 {
    method peso() = 8
}

object televisor3 {
    method peso() = 5
}

object camion {
    const property cantidadDeCosasMaxima = 3
    const property cosasLlevadas = []
    const property pesoMaximo = 500

    method subirAlCamnio(cosa) {
      if (cosasLlevadas.size() < cantidadDeCosasMaxima){
        cosasLlevadas.add(cosa)
      } 
    }
    
    method pesoTotal() {
        return cosasLlevadas.sum({cosa => cosa.peso()})
    }
}