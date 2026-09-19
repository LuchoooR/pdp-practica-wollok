object tom {
  var energia = 0
  var ratonesComidos = 0

  method velocidad() = (5 + (energia/10))

  method comerRaton(unRaton) {
    energia += (12 + unRaton.peso())
    ratonesComidos += 1
  }

  method correr(segundos) {
    const metrosCorridos = self.velocidad() * segundos
    energia -= (0.5 * metrosCorridos)
  }

  method meConvieneComerRatonA(unRaton, unaDistancia){
    return (12 + unRaton.peso()) > (0.5 * unaDistancia)
  }

}


object raton {
  const peso = 9
  method peso() = peso
}
