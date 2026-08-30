object rolando {
  var vida = 100
  var tieneEscudo = true

  method vida() = vida // getter

  method tieneEscudo(bool) { //setter
    tieneEscudo = bool
  }

  method correr(km) {
    self.modificarVida(- (km * 0.01))
  }

  method recibirDanio(unidades) {
    if (tieneEscudo) self.modificarVida(-unidades * 0.5)
    else self.modificarVida(-unidades)
  }

  method modificarVida(valor) {
    vida = (vida + valor).max(0).min(100)
  }

  method descansar(horas) {
    self.modificarVida(horas * 10)
  }

}