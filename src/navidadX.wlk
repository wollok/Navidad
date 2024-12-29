import wollok.game.*


object navidad {
	const ancho = 25
	const alto = 11
	const colores = ["Rojo","Verde","Amarillo"]
	const adornos = []
	method llegar(){
		game.width(ancho)
		game.height(alto)
		20.times{x=> self.agregarAdorno()}
		
		arbol.inicializar()
		game.addVisualCharacter(arbol)
		
		game.schedule(2000,
			{game.onTick(1000,"mover",{self.moverAdornos()})}
		)
		game.onCollideDo(arbol,{a=> game.removeVisual(a) adornos.remove(a)})
			
	}
	method agregarAdorno() {
		const adorno = new Adorno(position=self.posicionAleatoria(),color = self.color())
		game.addVisual(adorno)
		adornos.add(adorno) 
	}
	
	method color() = colores.anyOne()
	
	
	method posicionAleatoria() { 
		const x = (0..ancho-1).anyOne()
		const y = (0..alto-1).anyOne()
		return if (x.between(3,ancho-2) and y.between(3,alto-2))
					self.posicionAleatoria()
				else
					game.at(x,y)
	}
	method moverAdornos(){
		adornos.forEach{a=>a.mover()}
		if(self.adornosColocados()){
			game.removeTickEvent("mover")
			game.addVisual(saludo)
			}
	}
	
	method adornosColocados() = adornos.all{a=>a.position().distance(arbol.position())<2}
}

object arbol {
	var property position = null

	method image() = "arbol.png"
	method inicializar(){
		position = game.center()
	}
}

object saludo {
	method position() = arbol.position().up(1)

	method text() = "¡FELIZ AÑO!"
}

class Adorno {
	
	var property position
	const property color
	method image() = "adorno" + color + ".png"
	
	method mover() {
		const destino = game.at(
			arbol.position().x() + (position.x() - arbol.position().x()).div(1.2),
			arbol.position().y() + (position.y() - arbol.position().y()).div(1.2)
		)
		position = [destino.up(1),destino.down(1),destino,destino.right(1),destino.left(1)].anyOne()
	}
}