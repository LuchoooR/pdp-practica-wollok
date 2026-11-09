class PizzaEstandar {
    const ingredientes = []
    const property porciones = 8

    method costoDePizza() = self.cantidadDeLetrasIngredientes()*100

    method cantidadDeLetrasIngredientes() = ingredientes.sum({palabra => palabra.size()})

    method agregarIngrediente(ingrediente) {
        ingredientes.add(ingrediente)
    }

    method noTiene(ingrediente) = !ingredientes.contains(ingrediente)

}

class PizzaChica inherits PizzaEstandar {
    override method porciones() = 4

    override method costoDePizza() = super() * 0.75

}

class PizzaCompuesta{
    const subPizzas = []

    method porciones() = subPizzas.min({ p => p.porciones() }).porciones()

    method costoDePizza() = self.pizzaMásCostosa().costoDePizza()

    method pizzaMásCostosa() = subPizzas.max({p => p.costoDePizza()})

    method validarArmado() {
        if (subPizzas.size() > self.porciones()) {
            self.error("No se puede realizar la entrega: demasiadas pizzas para combinar")
        }
    }

    method noTiene(ingrediente) = subPizzas.all({p => p.noTiene(ingrediente)})

}

class Pizzeria {
    const costoBase 
    var factorChetez
    var property estilo = normal
    var property clienteHistorico

    method precioDePedido(pedido) = pedido.sum({p => self.precioDePizza(p)})

    method precioDePizza(pizza) = (pizza.costoDePizza() + costoBase)* factorChetez

    method armarPedido(pedido) {
        const precioInicial = self.precioDePedido(pedido)
        const newPedido = estilo.ejecutar(pedido)

        const entrega = new Entrega(
            pedidoOriginal = pedido,
            precioPedido = precioInicial,
            loEntregado = newPedido,
            precioFinal = self.precioDePedido(newPedido)
        ) 
        


        return entrega 


    }



}

class Entrega {
    const property pedidoOriginal
    const property precioPedido
    const property loEntregado
    const property precioFinal
}

object normal {
    method ejecutar(pedido) = pedido 
}

class IngredienteExtra{
    const ingredienteExtra 

    method ejecutar(pedido){
        pedido.forEach({p => p.agregarIngrediente(ingredienteExtra)})
        return pedido
    }
}

object resumen {

    method ejecutar(pedido){
        const newPedido = new PizzaCompuesta(subPizzas = pedido )
        newPedido.validarArmado()
        return [newPedido]
    }


}

object laPreferida{
    const pizzaPredilecta

    method ejecutar(pedido) = pedido.map({ pizza => new PizzaCompuesta(subPizzas = [pizza, pizzaPredilecta]) })

}

object laCombineta{
    method ejecutar(pedido){
        return utils.combinarConSiguiente(pedido).map({ par => 
            new PizzaCompuesta(subPizzas = par) 
        })
    }
}



class Cliente {
    var nivelDeHumor

    method pedirPedido(pedido, pizzeria){
        const entrega = pizzeria.armarPedido(pedido)
        
        if(self.estaConforme(entrega)){
            self.modificarHumor(+1)
        } else {
            self.modificarHumor(-1)
        }

    }

    

    method modificarHumor(humor){
        nivelDeHumor = (nivelDeHumor+humor).max(1).min(10)
    }

    method estaConforme(entrega) 
}

class SuperExigente inherits Cliente {
    override method estaConforme(entrega) = entrega.pedidoOriginal() == entrega.loEntregado()
}

class Humilde inherits Cliente{
    override method estaConforme(entrega) = entrega.precioPedido() <= entrega.precioFinal()
}

class Manioso inherits Cliente {
    const ingredienteFeo

    override method estaConforme(entrega) = entrega.loEntregado().all({p=> p.noTiene(ingredienteFeo)})

}