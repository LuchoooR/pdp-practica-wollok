class Cliente{
    const historialCompras = []
    var plan


    method cambiarPlan(planNuevo){
        plan = planNuevo
    }

    method valorDeEnvio(pedido) = plan.aplicarDescuento(pedido.costoReealDeEnvio(self))

    method realizarCompra(pedido){
        pedido.validarPosibilidadDeCompra()
        const compra = new Compra(
            pedido = pedido,
            costoEnvio = self.valorDeEnvio(pedido),
            fecha = new Date()
        )
        historialCompras.add(compra)
    }

    method todosLosItemsComprados() = historialCompras.flatMap({ c => c.pedido().items() })

    method productoMasCaroDeLasCompras() = self.todosLosItemsComprados().max({ i => i.precioDeProducto() }).producto()
    method productoMasComprado() = self.todosLosItemsComprados().max({ i => i.cantidad() }).producto()

    method compraMasCara() = historialCompras.max({c => c.pedido().precioBruto() + c.costoEnvio()})

    method totalAhorrado() = historialCompras.sum({ c => c.pedido().costoRealDeEnvo(self) - c.costoEnvio() })

}

object planComun{
    method aplicarDescuento(numero) = numero
}

object planSilver{
    method aplicarDescuento(numero) = numero*0.5
}

class PlanGold {
    var comprasRealizadas = 0

    method aplicarDescuento(numero){
        if(comprasRealizadas == 5){
            comprasRealizadas = 0
            return 0
        } else {
            comprasRealizadas +=1
            return numero*0.10
        }
    }

}

class Pedido{
    const property items = []
    const local

    method precioBruto() = items.sum({i => i.precioTotal()})

    method validarPosibilidadDeCompra() = local.validarStock(items)

    //method precioNeto(cliente) = self.precioBruto() + self.costoRealDeEnvo(cliente)    

    method costoRealDeEnvo(cliente) = (calculadorDeCuadras.distancia(cliente, local)*15).min(300)

    method itemMasCaro() = items.max({i => i.precioDeProducto()})
    method itemMasComprado() = items.max({i => i.cantidad()})

    method agregar(producto, cantidad){
        if(not items.any({ i => i.producto() == producto })){
            items.add(new Item(producto = producto))
        }
        items.find({ i => i.producto() == producto }).agregarCantidad(cantidad) 
    }

}

class Local{
    const stock

    method validarStock(items){
        const itemsSinStock = items.filter{i => !self.hayStock(i)}
        if(!itemsSinStock.isEmpty()){
            throw new Exception(message = "Faltante de stock")
        }
    } 

    method hayStock(item) = stock.any({ s => s.hayStockItem(item) })

}

class Item{
    const property producto
    var property cantidad = 0

    method precioTotal() = cantidad*producto.precio()

    method precioDeProducto() = producto.precio()

    method agregarCantidad(_cantidad){
        cantidad += _cantidad
    }

    method hayStockItem(item) = producto == item.producto() and cantidad >= item.cantidad()

}

class Producto{
    const property precio
}

object calculadorDeCuadras {
  method distancia(cliente, local) = 42
}

class Compra{
    const property pedido
    const property costoEnvio
    const fecha
    
    method productoMasCaro() = pedido.itemMasCaro()
}

// 7) no, se uso polimorfismo, el beneficio de usarla es que podes llamar a cualquier objeto con el mismo método y todo van a poder entenderlo.