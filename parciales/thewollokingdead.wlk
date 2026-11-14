object sobreviviente {
    var property consumo = 3
}

class Sobreviviente {
    method consumo() = sobreviviente.consumo()

    method mejorar() {}

    method provisionesQueRecolecta(cantidadBase) = cantidadBase

    method bajasPorMinuto()
    method balasPorMinuto()
}

class Tirador inherits Sobreviviente {
    const cantidadArmas

    override method bajasPorMinuto() = cantidadArmas * 10

    override method balasPorMinuto() = self.bajasPorMinuto()
}

class Recolector inherits Sobreviviente {
    const property armasBlancas = #{}

    override method bajasPorMinuto() = self.armaConMayorEficacia().cantidadDeKills()

    override method balasPorMinuto() = 0

    method armaConMayorEficacia() = armasBlancas.max({ a => a.cantidadDeKills() })

    override method provisionesQueRecolecta(cantidadBase) = super(cantidadBase) * 1.4
}

object cuchillo {
    method cantidadDeKills() = 2
} 

object katana {
    method cantidadDeKills() = 5
}

class Principiante inherits Sobreviviente {
    var balasPorWolloker = 5

    override method mejorar() {
        balasPorWolloker = 2.max(balasPorWolloker - 1)
    }

    override method provisionesQueRecolecta(cantidadBase) = super(cantidadBase) * 0.8

    override method bajasPorMinuto() = self.balasPorMinuto() / balasPorWolloker

    override method balasPorMinuto() = 20
}

class Refugio {
    const property sobrevivientes = #{}
    var balas
    var comida

    method bajasPorMinuto() = sobrevivientes.sum({ s => s.bajasPorMinuto() })

    method balasPorMinuto() = sobrevivientes.sum({ s => s.balasPorMinuto() })

    method balasNecesarias(horda) = self.balasPorMinuto() * horda.tiempoDeAtaque()

    method tieneSuficienteBalasPara(horda) = balas >= self.balasNecesarias(horda)

    method modificarBalas(numero) {
        balas += numero
    }

    method puedeSoportarAtaque(horda) = 
        self.bajasPorMinuto() >= horda.wollokersPorMinuto() && self.tieneSuficienteBalasPara(horda)

    method ataqueDe(horda) {
        if (self.puedeSoportarAtaque(horda)) {
            self.modificarBalas(-self.balasNecesarias(horda))
            self.mejorarSobrevivientes()
        } else {
            self.eliminarSobrevivientesAlAzar(horda.tiempoDeAtaque())
        }

        self.consumirComida(2)    
    }

    method eliminarSobrevivientesAlAzar(cantidad) {
        utils.eliminarRandoms(sobrevivientes, cantidad.min(sobrevivientes.size()))
    }

    method consumirComida(dias) {
        if (comida >= self.cantidadDeComidaRequeridaPara(dias)) {
            self.consumirRaciones(dias)
        } else {
            self.eliminarSobrevivientesAlAzar(self.muertosDeHambre(dias))
            self.consumirRaciones(dias)
        }
    }

    method muertosDeHambre(dias) = 
        0.max(self.cantidadNecesitaAlimentar() - self.cantidadPuedeAlimentar(dias))
    
    method cantidadPuedeAlimentar(dias) = comida.div(self.consumoTotalPorPersona(dias))

    method cantidadNecesitaAlimentar() = sobrevivientes.size()

    method consumirRaciones(dias) {
        comida = (comida - self.cantidadDeComidaRequeridaPara(dias)).max(0)
    }

    method consumoTotalPorPersona(dias) = sobreviviente.consumo() * dias

    method cantidadDeComidaRequeridaPara(dias) = 
        self.cantidadNecesitaAlimentar() * self.consumoTotalPorPersona(dias)

    method mejorarSobrevivientes() {
        sobrevivientes.forEach({ s => s.mejorar() })
    }

    method recolectarTotal(cantidadBase) = 
        sobrevivientes.sum({ s => s.provisionesQueRecolecta(cantidadBase) })

    method realizarExpedicion(expedicion) {
        expedicion.esExploradoPor(self)
    }

    method nuevosSobrevivientes(lista) {
        sobrevivientes.addAll(lista)
    }

    method encontrarComida(cantidad) {
        comida += cantidad
    }


    method robarRefugio(otroRefugio) {
        if (otroRefugio.bajasPorMinuto() >= self.bajasPorMinuto()) {
            throw new Exception(message = "Las bajas por minuto no son suficientes para robar")
        } 
        otroRefugio.serRobadoPor(self)
    }

    method serRobadoPor(otroRefugio) {
        otroRefugio.encontrarComida(comida)
        otroRefugio.modificarBalas(balas)
        comida = 0
        balas = 0
    }
}

class Despensa {
    const listaDeSobrevivientes = #{}
    
    method esExploradoPor(refugio) {
        refugio.encontrarComida(refugio.recolectarTotal(5))
        refugio.nuevosSobrevivientes(listaDeSobrevivientes)
    }
}

class Armeria {
    method esExploradoPor(refugio) {
        refugio.modificarBalas(refugio.recolectarTotal(20))
    }
}

class Wollokmart {
    const cantidadN

    method esExploradoPor(refugio) {
        refugio.modificarBalas(refugio.recolectarTotal(cantidadN))
        refugio.encontrarComida(refugio.recolectarTotal(cantidadN))
    }
}

class Horda {
    const property cantidadWollokers
    const property tiempoDeAtaque

    method wollokersPorMinuto() = cantidadWollokers / tiempoDeAtaque

    method atacar(refugio) {
        refugio.ataqueDe(self)
    }
}

object utils {
    method eliminarRandoms(lista, cantidad) {
        cantidad.times({ n => lista.remove(lista.anyOne()) })
    }
}