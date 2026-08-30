object rolando {
    var vida = 100
    var municion = 100
    var granadas = 5
    var armaActual = "pistola"
    var dinero = 0
    var vehiculoActual = null
    var armadura = 0

    method vida() = vida 
    
    method correr(km) {
        vida = vida - (km * 0.01)
    }
    
    method disparar() {
        if (municion > 0) {
            municion = municion - 1
            console.println("¡Disparo! Munición restante: " + municion)
        } else {
            console.println("¡Sin munición!")
        }
    }
    
    method lanzarGranada() {
        if (granadas > 0) {
            granadas = granadas - 1
            console.println("¡Granada lanzada! Granadas restantes: " + granadas)
        } else {
            console.println("¡Sin granadas!")
        }
    }
    
    method atacarConCuchillo() {
        console.println("¡Ataque con cuchillo!")
        vida = vida - 2  // El ataque con cuchillo cansa al personaje
    }
    
    method cambiarArma(arma) {
        armaActual = arma
        console.println("Arma cambiada a: " + armaActual)
    }
    
    method armaActual() = armaActual
    
    method municion() = municion
    
    method granadas() = granadas
    
    // Dinero y robos
    method dinero() = dinero
    
    method robar(cantidad) {
        dinero = dinero + cantidad
        console.println("¡Robado $" + cantidad + "! Dinero total: $" + dinero)
    }
    
    method gastar(cantidad) {
        if (dinero >= cantidad) {
            dinero = dinero - cantidad
            console.println("Gastados $" + cantidad + ". Dinero restante: $" + dinero)
        } else {
            console.println("¡No tienes suficiente dinero!")
        }
    }
    
    method comprarArma(arma, precio) {
        if (dinero >= precio) {
            dinero = dinero - precio
            console.println("¡Arma comprada: " + arma + " por $" + precio)
            municion = municion + 50
        } else {
            console.println("¡No tienes suficiente dinero!")
        }
    }
    
    // Vehículos
    method subirseAlVehiculo(vehiculo) {
        vehiculoActual = vehiculo
        console.println("¡Subido a: " + vehiculo.tipo() + "!")
    }
    
    method bajarseDelVehiculo() {
        if (vehiculoActual != null) {
            console.println("¡Bajado de: " + vehiculoActual.tipo() + "!")
            vehiculoActual = null
        } else {
            console.println("¡No estás en ningún vehículo!")
        }
    }
    
    method conducir(km) {
        if (vehiculoActual != null) {
            vehiculoActual.conducir(km)
            console.println("Conduciendo " + km + "km en " + vehiculoActual.tipo())
        } else {
            console.println("¡No tienes vehículo!")
        }
    }
    
    method vehiculoActual() = vehiculoActual
    
    // Armadura
    method armadura() = armadura
    
    method ponerseArmadura() {
        armadura = 50
        console.println("¡Armadura puesta! Protección: " + armadura)
    }
    
    method recibirDano(dano) {
        var danioReal = dano - (armadura * 0.5)
        vida = vida - danioReal
        console.println("¡Recibido " + danioReal + " de daño! Vida: " + vida)
    }
    
    // Combate con enemigos
    method atacarEnemigo(enemigo) {
        console.println("¡Atacando a " + enemigo.nombre() + "!")
        enemigo.recibirDano(25)
        self.recibirDano(10)
    }

}

object auto {
    var combustible = 100
    var velocidad = 0
    
    method tipo() = "Auto"
    method combustible() = combustible
    
    method conducir(km) {
        combustible = combustible - (km * 0.1)
        console.println("Auto conducido " + km + "km. Combustible: " + combustible)
    }
    
    method repostar(cantidad) {
        combustible = combustible + cantidad
        console.println("Repostado " + cantidad + ". Combustible: " + combustible)
    }
}

object motocicleta {
    var combustible = 50
    var velocidad = 0
    
    method tipo() = "Motocicleta"
    method combustible() = combustible
    
    method conducir(km) {
        combustible = combustible - (km * 0.08)
        console.println("Motocicleta conducida " + km + "km. Combustible: " + combustible)
    }
    
    method repostar(cantidad) {
        combustible = combustible + cantidad
        console.println("Repostado " + cantidad + ". Combustible: " + combustible)
    }
    
    method acelerarMax() {
        console.println("¡Aceleración máxima en motocicleta!")
    }
}

object helicoptero {
    var combustible = 200
    var altura = 0
    
    method tipo() = "Helicóptero"
    method combustible() = combustible
    method altura() = altura
    
    method despegar() {
        altura = 100
        console.println("¡Helicóptero despegado! Altura: " + altura + "m")
    }
    
    method aterrizar() {
        altura = 0
        console.println("¡Helicóptero aterrizando!")
    }
    
    method conducir(km) {
        combustible = combustible - (km * 0.15)
        console.println("Helicóptero volando " + km + "km a " + altura + "m. Combustible: " + combustible)
    }
}

// ENEMIGOS

object policia {
    var vida = 80
    var nombre = "Oficial de Policía"
    var dineroQueDropea = 150
    
    method nombre() = nombre
    method vida() = vida
    
    method recibirDano(dano) {
        vida = vida - dano
        console.println(nombre + " recibió " + dano + " de daño. Vida: " + vida)
        if (vida <= 0) {
            self.morir()
        }
    }
    
    method morir() {
        console.println(nombre + " fue eliminado. ¡Dinero obtenido: $" + dineroQueDropea + "!")
    }
    
    method perseguir(objetoX, objetoY) {
        console.println("¡" + nombre + " te está persiguiendo!")
    }
}

object pandillero {
    var vida = 60
    var nombre = "Pandillero"
    var dineroQueDropea = 100
    var arma = "pistola"
    
    method nombre() = nombre
    method vida() = vida
    
    method recibirDano(dano) {
        vida = vida - dano
        console.println(nombre + " recibió " + dano + " de daño. Vida: " + vida)
        if (vida <= 0) {
            self.morir()
        }
    }
    
    method morir() {
        console.println(nombre + " fue eliminado. ¡Dinero obtenido: $" + dineroQueDropea + "!")
    }
    
    method disparar() {
        console.println(nombre + " ¡dispara con " + arma + "!")
    }
}

object jefe {
    var vida = 150
    var nombre = "Gran Jefe Criminal"
    var dineroQueDropea = 5000
    var escudo = true
    
    method nombre() = nombre
    method vida() = vida
    
    method recibirDano(dano) {
        if (escudo) {
            console.println("¡El escudo del " + nombre + " absorbió el daño!")
            escudo = false
        } else {
            vida = vida - dano
            console.println(nombre + " recibió " + dano + " de daño. Vida: " + vida)
        }
        if (vida <= 0) {
            self.morir()
        }
    }
    
    method morir() {
        console.println("¡" + nombre + " fue derrotado! ¡Dinero obtenido: $" + dineroQueDropea + "! ¡MISION COMPLETADA!")
    }
    
    method activarEscudo() {
        escudo = true
        console.println(nombre + " ¡activa su escudo!")
    }
}

// CUSTOM GARAGE - EL TALLER (The Boot Place)

object taller {
    var nombre = "Taller de Customización"
    var trabajadores = [mecanico1, mecanico2, mecanico3]
    var clientesPresentes = []
    
    method nombre() = nombre
    
    method traerVehiculo(vehiculo, cliente) {
        clientesPresentes.add(cliente)
        console.println("¡" + cliente + " llegó al taller con su " + vehiculo.tipo() + "!")
    }
    
    method customizarVehiculo(vehiculo, tipo, precio) {
        if (mecanico1.disponible()) {
            mecanico1.customizar(vehiculo, tipo, precio)
        } else if (mecanico2.disponible()) {
            mecanico2.customizar(vehiculo, tipo, precio)
        } else if (mecanico3.disponible()) {
            mecanico3.customizar(vehiculo, tipo, precio)
        } else {
            console.println("¡Todos los mecánicos están ocupados!")
        }
    }
    
    method repararVehiculo(vehiculo, precio) {
        if (mecanico1.disponible()) {
            mecanico1.reparar(vehiculo, precio)
        } else if (mecanico2.disponible()) {
            mecanico2.reparar(vehiculo, precio)
        } else {
            console.println("¡No hay mecánicos disponibles!")
        }
    }
    
    method agregarTurbo(vehiculo, precio) {
        console.println("¡Agregando turbo a " + vehiculo.tipo() + " por $" + precio + "!")
        console.println("¡Velocidad máxima aumentada!")
    }
    
    method pintar(vehiculo, color, precio) {
        console.println("¡Pintando " + vehiculo.tipo() + " color " + color + " por $" + precio + "!")
    }
    
    method listarTrabajadores() {
        console.println("=== Trabajadores del Taller ===")
        trabajadores.forEach({ t => console.println("- " + t.nombre() + " (Especialidad: " + t.especialidad() + ")") })
    }
}

// MECÁNICOS DEL TALLER

object mecanico1 {
    var nombre = "Carlos 'El Máquina'"
    var especialidad = "Motores y Turbo"
    var disponible = true
    var clienteActual = null
    
    method nombre() = nombre
    method especialidad() = especialidad
    method disponible() = disponible
    method clienteActual() = clienteActual
    
    method customizar(vehiculo, tipo, precio) {
        disponible = false
        console.println(nombre + " está customizando el " + vehiculo.tipo() + " con " + tipo + "...")
        console.println("Precio: $" + precio)
    }
    
    method reparar(vehiculo, precio) {
        disponible = false
        console.println(nombre + " está reparando el " + vehiculo.tipo() + " por $" + precio)
    }
    
    method terminarTrabajo() {
        disponible = true
        console.println(nombre + " terminó el trabajo.")
    }
    
    method diasTrabajados() = 15
}

object mecanico2 {
    var nombre = "Roberto 'Chapa'"
    var especialidad = "Carrocería y Pintura"
    var disponible = true
    var clienteActual = null
    
    method nombre() = nombre
    method especialidad() = especialidad
    method disponible() = disponible
    method clienteActual() = clienteActual
    
    method customizar(vehiculo, tipo, precio) {
        disponible = false
        console.println(nombre + " está customizando la carrocería del " + vehiculo.tipo() + "...")
        console.println("Precio: $" + precio)
    }
    
    method reparar(vehiculo, precio) {
        disponible = false
        console.println(nombre + " está reparando la chapa del " + vehiculo.tipo() + " por $" + precio)
    }
    
    method terminarTrabajo() {
        disponible = true
        console.println(nombre + " terminó el trabajo.")
    }
    
    method pintarEspecial(vehiculo, diseño, precio) {
        console.println(nombre + " está haciendo un diseño especial: " + diseño)
    }
}

object mecanico3 {
    var nombre = "Juan 'El Electricista'"
    var especialidad = "Sistemas Eléctricos e Iluminación"
    var disponible = true
    var clienteActual = null
    
    method nombre() = nombre
    method especialidad() = especialidad
    method disponible() = disponible
    method clienteActual() = clienteActual
    
    method customizar(vehiculo, tipo, precio) {
        disponible = false
        console.println(nombre + " está instalando " + tipo + " en el " + vehiculo.tipo() + "...")
        console.println("Precio: $" + precio)
    }
    
    method reparar(vehiculo, precio) {
        disponible = false
        console.println(nombre + " está reparando los sistemas del " + vehiculo.tipo() + " por $" + precio)
    }
    
    method terminarTrabajo() {
        disponible = true
        console.println(nombre + " terminó el trabajo.")
    }
    
    method instalarNeon(vehiculo, color, precio) {
        console.println(nombre + " instalando neon " + color + " por $" + precio)
    }
}