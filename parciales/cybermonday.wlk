
class Local{
    const property ventas = #{}

    method saberCantidad() = ventas.count({ v => v.tienePromocion()})

    method queVentasTuvoEn(fecha) = ventas.filter({ v => v.fecha() == fecha})

    method plataAhorraEn(fecha) = self.queVentasTuvoEn(fecha).sum({ v => v.plataAhorrada()})

    method cantidadDeVentas(lugar) = ventas.count({ v => v.ciudad() == lugar})

    method dineroMovido() = ventas.sum({v => v.monto()})

    //method soloVendeConPromocion(lugar) = 

    method saberVentasDe(lugar) = ventas.filter({ v => v.ciudad() == lugar})

    method sonSoloPromocion(auxVentas) = auxVentas.all({v => v.esSoloPromocion()}) 

    method soloVendeConPromo(lugar) = self.sonSoloPromocion(self.saberVentasDe(lugar))
    
    //esSoloPromocion

    //method soloVendePromocion() = 
    
    // esSoloPromocion()

    // self.saberVentasDe(lugar)
    // ventas.all({v => v.esSoloPromocion()})

}

class ShoppingCenters {
    const property locales = #{}

    method cantidadDeVentas(lugar) = locales.sum({l => l.cantidadDeVentas(lugar)})

    method dineroMovido() = locales.sum({ l => l.dineroMovido()})

    method soloVendeConPromo(lugar) = locales.all({l => l.soloVendeConPromo(lugar)})

}

object empresa{
    const establecimientos = #{}
    const lugares = #{}

    method queLugarTuvoMasVentas() = lugares.max({ l => self.ventasTotalesEn(l)})

    method ventasTotalesEn(lugar) = establecimientos.sum({e => e.cantidadDeVentas(lugar)})

    method esLugarDeTacanios(lugar) = establecimientos.all({e => e.soloVendeConPromo(lugar)})

    method hayAlgunLugarConTacanios() = lugares.any({l => self.esLugarDeTacanios(l)})


}
 // 8, si, use herencia en la parte del producto y me ayudo debido a que me ahorro al momento de escribir código y hacer el código más poliformico y ahorrar copiar tanta lógica.

class Producto{
    var descuento

    method costo()

    method cambiarDescuento(newDescuento){
        descuento = newDescuento
    }
    

    method cualEsElDescuento() = descuento.descuento(self.costo()) 

    method estaEnPromocion() = self.cualEsElDescuento() > 0

    method precio() = self.costo() - self.cualEsElDescuento()

}

class Indumentaria inherits Producto{
    const talle
    const factorDeTalle

    override method costo() = talle*factorDeTalle


}

class Electronica inherits Producto{

    override method costo() = (15 * factorDeConversion.factorDeConversion()) // el * esta pero no lo ves xq desaparece
 
}

class Decoracion inherits Producto{
    const peso
    const ancho
    const alto
    const property materiales = #{}


    method costoDeco() = peso*ancho*alto

    override method costo() = self.costoDeco() + self.valorDeMateriales()

    method valorDeMateriales() = materiales.sum({m => m.valor()})

    method agregarMaterial(material) {
        materiales.add(material)
    }

}

class Material{
    method valor()
}

class Descuento{
    var property numero // si es SinPromocion = 0 y listo

    method descuento(precio) = precio* (numero/100)

}


// no modelo tema madera, hierro, metal y granito xq no lo pide pero se entiende que son objetos que heredan de Material

class Venta{
    const property productos = []
    const property ciudad
    const property fecha

    method monto() = productos.sum({p => p.precio()})

    method plataAhorrada() = productos.sum({p => p.cualEsElDescuento()})

    method tienePromocion() = productos.any({p => p.estaEnPromocion()}) 

    method esSoloPromocion() = productos.all({p => p.estaEnPromocion()}) 

}

object factorDeConversion{
    var numero = 3
    method factorDeConversion() = numero

    method cambiarFactor(newNumero){
        numero = newNumero
    }

}

//bonus: y lo que haría sería adaptar mi código agregando a cada producto el local, y dependiendo el local, tendría un booleano el cual conectaría a mi descuento, siendo que si, por ejemplo, local 1 tiene descuento, ese bool activaría el descuento para la cuenta, sino lo dejaría en 0. Esto ser haría mediante un método estilo "activar descuento para local" algo así ponele.