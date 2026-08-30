// COUNTER STRIKE 3 - COMPETITIVE SHOOTER

// ===== TEAMS =====

object equipoCounterTerrorist {
    var nombre = "Counter-Terrorists"
    var jugadores = []
    var dineroEquipo = 16000
    var objetivo = "Defender los sitios de bomba"
    
    method nombre() = nombre
    method agregarJugador(jugador) {
        jugadores.add(jugador)
    }

    method dineroEquipo() = dineroEquipo
    method sumarDinero(cantidad) {
        dineroEquipo = dineroEquipo + cantidad
    }
    
    method restarDinero(cantidad) {
        dineroEquipo = dineroEquipo - cantidad
    }
    
    method jugadores() = jugadores
    method objetivo() = objetivo
}

object equipoTerrorista {
    var nombre = "Terroristas"
    var jugadores = []
    var dineroEquipo = 16000
    var objetivo = "Plantar la bomba"
    var bombadorDesignado = null
    
    method nombre() = nombre
    method agregarJugador(jugador) {
        jugadores.add(jugador)
    }
    
    method dineroEquipo() = dineroEquipo
    method sumarDinero(cantidad) {
        dineroEquipo = dineroEquipo + cantidad
    }
    
    method restarDinero(cantidad) {
        dineroEquipo = dineroEquipo - cantidad
    }
    
    method jugadores() = jugadores
    method objetivo() = objetivo
    method bombadorDesignado() = bombadorDesignado
    method designarBombador(jugador) {
        bombadorDesignado = jugador
    }
}

// ===== MAPAS =====

object mirage {
    var nombre = "Mirage"
    var sitioA = "Sitio A - Mercado"
    var sitioB = "Sitio B - Casa"
    var bombado = false
    var tiempoRonda = 120  // segundos
    
    method nombre() = nombre
    method sitioA() = sitioA
    method sitioB() = sitioB
    method descripcion() = "Mapa de Medio Oriente con mercado y edificios residenciales"
    
    method plantarBomba(sitio) {
        if (sitio == "A" || sitio == "B") {
            bombado = true
            console.println("¡BOMBA PLANTADA en Sitio " + sitio + "!")
            console.println("Los CT tienen 40 segundos para desactivarla.")
        }
    }
    
    method desactivarBomba() {
        bombado = false
        console.println("¡Bomba desactivada! CT ganan la ronda.")
    }
    
    method detonacion() {
        if (bombado) {
            console.println("¡BOOM! ¡Bomba detonada! T ganan la ronda.")
            bombado = false
        }
    }
    
    method mapa() = "🗺️ " + nombre + " - " + this.descripcion()
}

object inferno {
    var nombre = "Inferno"
    var sitioA = "Sitio A - Almacén"
    var sitioB = "Sitio B - Plaza"
    var bombado = false
    var tiempoRonda = 120
    
    method nombre() = nombre
    method sitioA() = sitioA
    method sitioB() = sitioB
    method descripcion() = "Mapa urbano con iglesia, almacén e callejones"
    
    method plantarBomba(sitio) {
        if (sitio == "A" || sitio == "B") {
            bombado = true
            console.println("¡BOMBA PLANTADA en Sitio " + sitio + " de " + nombre + "!")
            console.println("Los CT tienen 40 segundos para desactivarla.")
        }
    }
    
    method desactivarBomba() {
        bombado = false
        console.println("¡Bomba desactivada! CT ganan la ronda.")
    }
    
    method detonacion() {
        if (bombado) {
            console.println("¡BOOM! ¡Bomba detonada en " + nombre + "! T ganan la ronda.")
            bombado = false
        }
    }
    
    method mapa() = "🗺️ " + nombre + " - " + this.descripcion()
}

// ===== JUGADORES =====

class Jugador {
    var nombre
    var equipo
    var vida = 100
    var armor = 0
    var dinero = 0
    var armas = []
    var armaActual = "Pistola"
    var muertes = 0
    var elimina = 0
    var tieneBomba = false
    
    constructor(nombre, equipo) {
        self.nombre = nombre
        self.equipo = equipo
        self.dinero = 800
    }
    
    method nombre() = nombre
    method equipo() = equipo
    method vida() = vida
    method armor() = armor
    method dinero() = dinero
    method elimina() = elimina
    method muertes() = muertes
    method tieneBomba() = tieneBomba
    
    method comprarArma(arma, precio) {
        if (dinero >= precio) {
            dinero = dinero - precio
            armas.add(arma)
            console.println(nombre + " compró " + arma + " por $" + precio)
        } else {
            console.println(nombre + " no tiene suficiente dinero para " + arma)
        }
    }
    
    method comprarArmor(tipo, precio) {
        if (dinero >= precio) {
            dinero = dinero - precio
            if (tipo == "Chaleco") {
                armor = 50
            } else if (tipo == "Casco+Chaleco") {
                armor = 100
            }
            console.println(nombre + " compró " + tipo + " por $" + precio)
        }
    }
    
    method recibirDano(dano) {
        var danioReal = dano - (armor * 0.3)
        vida = vida - danioReal
        console.println(nombre + " recibió " + danioReal + " de daño. Vida: " + vida)
        if (vida <= 0) {
            this.morir()
        }
    }
    
    method morir() {
        muertes = muertes + 1
        vida = 0
        console.println("¡" + nombre + " fue eliminado!")
    }
    
    method eliminar(enemigo) {
        elimina = elimina + 1
        enemigo.morir()
        dinero = dinero + 300  // Reward por kill
        console.println(nombre + " eliminó a " + enemigo.nombre() + ". K/D: " + elimina + "/" + muertes)
    }
    
    method plantarBomba() {
        if (tieneBomba) {
            tieneBomba = false
            console.println("¡" + nombre + " plantó la bomba!")
        }
    }
    
    method tomarBomba() {
        tieneBomba = true
        console.println("¡" + nombre + " tiene la bomba!")
    }
    
    method desactivarBomba() {
        console.println(nombre + " está desactivando la bomba...")
        console.println("⏳ 3 segundos...")
    }
    
    method estadisticas() {
        console.println("=== " + nombre + " ===")
        console.println("Equipo: " + equipo.nombre())
        console.println("Vida: " + vida + " | Armor: " + armor)
        console.println("Dinero: $" + dinero)
        console.println("K/D: " + elimina + "/" + muertes)
        console.println("Armas: " + armas.toString())
    }
}

// ===== JUGADORES CT =====

object ct_inspector {
    var nombre = "Inspector"
    var equipo = equipoCounterTerrorist
    var vida = 100
    var armor = 100
    var dinero = 2400
    var elimina = 0
    var muertes = 0
    
    method nombre() = nombre
    method vida() = vida
    method armor() = armor
    method dinero() = dinero
    method elimina() = elimina
    method muertes() = muertes
    
    method disparar() {
        console.println(nombre + " dispara con AWP...")
    }
    
    method obtenerPosicion() = "CT Spawn - Mirage"
}

object ct_rifleman {
    var nombre = "Rifleman"
    var equipo = equipoCounterTerrorist
    var vida = 100
    var armor = 100
    var dinero = 2400
    var elimina = 0
    var muertes = 0
    
    method nombre() = nombre
    method vida() = vida
    method armor() = armor
    method dinero() = dinero
    method elimina() = elimina
    method muertes() = muertes
    
    method disparar() {
        console.println(nombre + " dispara con AK-47...")
    }
}

object ct_support {
    var nombre = "Support"
    var equipo = equipoCounterTerrorist
    var vida = 100
    var armor = 100
    var dinero = 2400
    var elimina = 0
    var muertes = 0
    
    method nombre() = nombre
    method vida() = vida
    method armor() = armor
    method dinero() = dinero
    method elimina() = elimina
    method muertes() = muertes
    
    method dispararGranada() {
        console.println(nombre + " lanza una granada cegadora!")
    }
}

// ===== JUGADORES T =====

object t_awper {
    var nombre = "AWPer"
    var equipo = equipoTerrorista
    var vida = 100
    var armor = 0
    var dinero = 2400
    var elimina = 0
    var muertes = 0
    var tieneBomba = false
    
    method nombre() = nombre
    method vida() = vida
    method armor() = armor
    method dinero() = dinero
    method elimina() = elimina
    method muertes() = muertes
    method tieneBomba() = tieneBomba
    
    method tomarBomba() {
        tieneBomba = true
        console.println(nombre + " tomó la bomba. ¡Objetivo: Plantar en Sitio A o B!")
    }
    
    method plantarBomba(sitio) {
        if (tieneBomba) {
            console.println(nombre + " plantó la bomba en Sitio " + sitio + "!")
            tieneBomba = false
        }
    }
    
    method disparar() {
        console.println(nombre + " dispara con AWP...")
    }
}

object t_rifleman {
    var nombre = "Entrenador"
    var equipo = equipoTerrorista
    var vida = 100
    var armor = 0
    var dinero = 2400
    var elimina = 0
    var muertes = 0
    
    method nombre() = nombre
    method vida() = vida
    method armor() = armor
    method dinero() = dinero
    method elimina() = elimina
    method muertes() = muertes
    
    method disparar() {
        console.println(nombre + " dispara con M4...")
    }
}

object t_sapper {
    var nombre = "Sapper"
    var equipo = equipoTerrorista
    var vida = 100
    var armor = 0
    var dinero = 2400
    var elimina = 0
    var muertes = 0
    
    method nombre() = nombre
    method vida() = vida
    method armor() = armor
    method dinero() = dinero
    method elimina() = elimina
    method muertes() = muertes
    
    method colocarBomba() {
        console.println(nombre + " coloca la bomba C-4...")
    }
}

// ===== ARMAS Y ECONOMÍA =====

object sistemaArmas {
    method armasDisponibles() = [
        "Pistola: $200",
        "Famas: $2050",
        "Galil: $2000",
        "AK-47: $2500",
        "M4A1: $3100",
        "AWP: $4750",
        "Escopeta: $1200"
    ]
    
    method precioArma(arma) {
        if (arma == "Pistola") { return 200 }
        if (arma == "Famas") { return 2050 }
        if (arma == "Galil") { return 2000 }
        if (arma == "AK-47") { return 2500 }
        if (arma == "M4A1") { return 3100 }
        if (arma == "AWP") { return 4750 }
        if (arma == "Escopeta") { return 1200 }
        return 0
    }
    
    method mostrarArmas() {
        console.println("=== ARMAS DISPONIBLES ===")
        this.armasDisponibles().forEach({ a => console.println(a) })
    }
}

// ===== SISTEMA DE RONDAS =====

object ronda {
    var numero = 1
    var equipo_ct_ganador = null
    var equipo_t_ganador = null
    var razonVictoria = ""
    var mapa = mirage
    
    method numero() = numero
    method mapa() = mapa
    method iniciarRonda() {
        console.println("============================================")
        console.println("RONDA " + numero + " - " + mapa.nombre())
        console.println("============================================")
        console.println("🔵 CT: Defender bombas en Sitio A y B")
        console.println("🔴 T: Plantar bomba o eliminar CT")
        console.println("⏱️ Tiempo: 120 segundos")
    }
    
    method finalizarRonda(ganador, razon) {
        console.println("")
        console.println("══════════════════════════════════")
        console.println("¡" + ganador.nombre() + " GANAN LA RONDA!")
        console.println("Razón: " + razon)
        console.println("══════════════════════════════════")
        numero = numero + 1
    }
    
    method cambiarMapa(nuevoMapa) {
        mapa = nuevoMapa
    }
}

// ===== FUNCIONES PRINCIPALES =====

object juego {
    var enCurso = false
    var mapaActual = mirage
    
    method iniciarPartida() {
        enCurso = true
        console.println("╔════════════════════════════════════╗")
        console.println("║    COUNTER STRIKE 3 - INICIADO     ║")
        console.println("║        Mirage vs Inferno           ║")
        console.println("╚════════════════════════════════════╝")
        console.println("")
        console.println("CT: Inspector, Rifleman, Support")
        console.println("T:  AWPer, Entrenador, Sapper")
        console.println("")
        ronda.iniciarRonda()
    }
    
    method mostrarEquipos() {
        console.println("\n=== COUNTER-TERRORISTS ===")
        console.println("Inspector | Rifleman | Support")
        console.println("Dinero: $" + equipoCounterTerrorist.dineroEquipo())
        
        console.println("\n=== TERRORISTAS ===")
        console.println("AWPer | Entrenador | Sapper")
        console.println("Dinero: $" + equipoTerrorista.dineroEquipo())
    }
    
    method mostrarMapas() {
        console.println("\n" + mirage.mapa())
        console.println(inferno.mapa())
    }
}
