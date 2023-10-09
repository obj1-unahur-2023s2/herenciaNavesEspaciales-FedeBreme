//NaveEspacial

class NaveEspacial {
	var property velocidad = 0
	var property direccion = 0
	var combustible = 0
	
	method acelerar(cuanto) {
		velocidad += cuanto.min(100000)
	}
	
	method desacelerar(cuanto) {
		velocidad -= cuanto.max(0)
	}
	
	method irHaciaElSol() {
		direccion = 10
	}
	
	method escaparDelSol() {
		direccion = -10
	}
	
	method ponerseParaleloAlSol() {
		direccion = 0
	}
	
	method acercarseUnPocoAlSol() {
		direccion += 1.min(10)
	}
	
	method alejarseUnPocoDelSol() {
		direccion -= 1.max(-10)
	}
	
	method cargarCombustible(litros) {
		combustible += litros
	}
	
	method descargarCombustible(litros) {
		combustible -= litros.max(0)
	}
	
	method estaTranquila() {
		return combustible <= 4000 and velocidad <= 12000
	}
	
	method recibirAmenaza() 
	
	method estaRelajada() {
		return self.estaTranquila() 
	}
	
	method prepararViaje() {
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
}

//NavesPrincipales

class NavesBaliza inherits NaveEspacial {
	var property baliza = "apagada"
	var property cantidadDeCambiosDeBaliza = 0
	
	method cambiarColorDeBaliza(colorNuevo) {
		baliza = colorNuevo
		cantidadDeCambiosDeBaliza += 1
	}
	
	override method prepararViaje() {
		self.cambiarColorDeBaliza("verde") 
		self.ponerseParaleloAlSol()
		super()
	}
	
	override method estaTranquila() {
		return super() and baliza != "rojo"
	}
	
	override method recibirAmenaza() {
		self.irHaciaElSol()
		self.cambiarColorDeBaliza("rojo")
	}
	
	override method estaRelajada() {
		return super() and cantidadDeCambiosDeBaliza <= 1.max(0)
	}
}

class NavesDePasajeros inherits NaveEspacial {
	var property cantidadDePasajerosQuePuedeLlevar
	var property comidas = 0
	var property bebidas = 0
	
	method cargarComida(cantidadDeComida) {
		comidas += cantidadDeComida
	}
	
	method descargarComida(cantidadDeComida) {
		comidas -= cantidadDeComida
	}
	
	method cargarBebida(cantidadDeBebida) {
		bebidas += cantidadDeBebida
	}
	
	method descargarBebida(cantidadDeBebida) {
		bebidas -= cantidadDeBebida
	}
	
	override method prepararViaje() {
		self.cargarComida(cantidadDePasajerosQuePuedeLlevar * 4)
		self.cargarBebida(cantidadDePasajerosQuePuedeLlevar * 6)
		self.acercarseUnPocoAlSol()
		super()
	}
	
	override method recibirAmenaza() {
		velocidad *= 2
		comidas -= cantidadDePasajerosQuePuedeLlevar
		bebidas -= (cantidadDePasajerosQuePuedeLlevar * 2)
	}
	
	override method estaRelajada() {
		return super() and self.comidas() < 50
	}
}

class NavesDeCombate inherits NaveEspacial {
	var property estaInvisible = false
	var property misilesDesplegados = false
	const property mensajesEmitidos = []
	
	method ponerseVisible() {
		estaInvisible = false
	}
	
	method ponerseInvisible() {
		estaInvisible = true
	}
	
	method desplegarMisiles() {
		misilesDesplegados = true
	}
	
	method replegarMisiles() {
		misilesDesplegados = false
	}
	
	method emitirMensaje(mensaje) {
		mensajesEmitidos.add(mensaje)
	}
	
	method primerMensajeEmitido() {
		mensajesEmitidos.get(0)
	}
	
	method ultimoMnesajeEmitido() {
		mensajesEmitidos.last()
	}
	
	method esEscueta() {
		return mensajesEmitidos.any({m => m.length() >= 30})
	}
	
	method emitioMnesaje(mensaje) {
		mensajesEmitidos.any({m => m == mensaje})
	}
	
	override method prepararViaje() {
		self.ponerseVisible()
		self.replegarMisiles()
		self.acelerar(15000)
		self.emitirMensaje("Saliendo en misión")
		super()
	}
	
	override method estaTranquila() {
		return super() and !misilesDesplegados 
	}
	
	override method recibirAmenaza() {
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
		self.emitirMensaje("Amenaza recibida")
	}
	
	override method estaRelajada() {
		return super() and self.esEscueta()
	}
}

//NavesSecundarias

class NaveHospital inherits NavesDePasajeros {
	var property tienePreparadoLosQuirofanos = false
	
	override method estaTranquila() {
		return super() and not self.tienePreparadoLosQuirofanos()
	}
	
	override method recibirAmenaza() {
		super() 
		tienePreparadoLosQuirofanos = true
	}
}

class NaveDeCombateSigilosa inherits NavesDeCombate {
	
	override method estaTranquila() {
		return super() and not self.estaInvisible()
	}
	
	override method recibirAmenaza() {
		super()
		self.desplegarMisiles()
		self.ponerseInvisible()
	}
}

