import wollok.game.*


object navidad {
	
	const colores = ["Rojo","Verde","Amarillo"]
	const adornos = []
	method llegar(){
		game.width(9)
		game.height(9)
		20.times{x=> self.agregarAdorno()}
		
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
	
	
	method posicionAleatoria() = 
		game.at(
			(0..game.width()-1).anyOne(),
			(0..game.height()-1).anyOne()
		)
	
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
	var property position = game.center()

	method image() = "arbol.png"
}

object saludo {
	var property position = arbol.position().up(1)

	method text() = "¡FELIZ NAVIDAD!"
}

class Adorno {
	
	var property position
	const property color
	method image() = "adorno" + color + ".png"
	
	method mover() {
		const destino = game.at(
			arbol.position().x() + (position.x() - arbol.position().x()).div(2),
			arbol.position().y() + (position.y() - arbol.position().y()).div(2)
		)
		position = [destino.up(1),destino.down(1),destino,destino.right(1),destino.left(1)].anyOne()
	}
}