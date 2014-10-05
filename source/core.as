import gs.*;
import gs.easing.*;

stop();

////////Definición de variables////////
var eventoTeclado:Object = new Object();
var teclaPresionada:Number = 0;
var cronometro:Number = 0;
var segundos:Number = 0;
var tiempoJuego:Number = 80;
var posicionesOriginalesX:Array = new Array();
var posicionesOriginalesY:Array = new Array();
var destinoEIx:Number = 0;
var destinoEIy:Number = 0;
var destinoCajax:Number = 0;
var destinoCajay:Number = 0;
var duracionMovimiento:Number = 0.08;
var numCajas:Number = 4;
var hayCaja:Boolean = false;
var numeroCaja:Number = 0;
var sobraBaldoza:Number = 0.1;
var limitesTierraX:Array = [382.75, 442.75, 472.75, 532.75];
var limitesTierraY:Array = [325.45, 325.45, 385.45, 235.45];
var cajasBienPuestas:Number = 0;
var hundirCaja:Boolean = true;
var cuadroRepaso:Number = 0;
var alertaBien:Sound;
var alertaMal:Sound;
var mensajes:Array = ["¡La esfera cayó al agua!\nInténtelo de nuevo.","¡La caja cayó al agua!\nInténtelo de nuevo.","¡El límite de tiempo llegó a su fin!\nInténtelo de nuevo."];
var numMensaje:Number = -1;
//////**Definición de variables**//////


eventoTeclado.onKeyDown = function(){
	Key.removeListener(eventoTeclado);
	moverPersonaje();
};
/*eventoTeclado.onKeyUp = function() {
};*/
b_reiniciar.onRelease = function(){
	_root.detenerLocutor();
	reiniciarActividad();
}

function moverPersonaje(){
	//Calcular hacia dónde va a moverse el personaje
	switch(Key.getCode()){
		//Izquierda
		case 37:
			destinoEIx = ei._x - (baldoza._width - sobraBaldoza);
			destinoEIy = ei._y;
			break;
		//Arriba
		case 38:
			destinoEIy = ei._y - (baldoza._height - sobraBaldoza);
			destinoEIx = ei._x;
			break;
		//Derecha
		case 39:			
			destinoEIx = ei._x + (baldoza._width - sobraBaldoza);
			destinoEIy = ei._y;
			break;
		//Abajo
		case 40:
			destinoEIy = ei._y + (baldoza._height - sobraBaldoza);
			destinoEIx = ei._x;
			break;
		default:
			Key.addListener(eventoTeclado);
			break;
	}
	//Si el movimiento se hace dentro del escenario
	if(destinoEIx >= b_0_0._x && destinoEIy >= b_0_0._y && destinoEIy < 595.45){
		hayCaja = false;
		//Se mira si el personaje tiene alguna de las cajas enfrente
		for(var i = 1; i <= numCajas; i++){			
			if( destinoEIx === _root["caja_"+i]._x && destinoEIy === _root["caja_"+i]._y){
				hayCaja = true;
				numeroCaja = i;
			}
		}
		if(!hayCaja){//Si no hay una caja en el camino, muevase
			TweenMax.to(ei, duracionMovimiento, {_x:(destinoEIx), _y:(destinoEIy), onComplete:terminaMovimiento});
			/*ei._x = destinoEIx;
			ei._y = destinoEIy;
			tiempo();*/
		}
		else{//Si hay una caja en el camino
			moverCaja();
		}
		//Se determina si el personaje cae en el agua		
		if((destinoEIx >= limitesTierraX[0] && destinoEIx <= limitesTierraX[1] && destinoEIy >= limitesTierraY[0])
			   || (destinoEIx == limitesTierraX[2] && destinoEIy == limitesTierraY[2])
			   || (destinoEIx >= limitesTierraX[3] && destinoEIy >= limitesTierraY[3])){//Si se cae al agua
			//Si cae sobre la plataforma de zona segura, termina el juego
			if(destinoEIx == meta._x && destinoEIy == meta._y){				
				//Para que no se pueda mover se cambia el nombre
				ei._name = "ei_ASalvo";
				gotoAndPlay("salir");
				clearInterval(cronometro);
				
			}				
			else{//Si no cae en la plataforma de zona segura
				//El contador de cajasBienPuestas se pone en cero, asumiendo que no hay cajas sirviendo como puente
					cajasBienPuestas = 0;
					//Se mira si alguna de las casillas a la que me voy a mover es un soporte de puente
					for(var i = 1; i <= numCajas;i++)
						//Si el soporte ya tiene una caja encima, se aumenta el contador de cajasBienPuestas
						if(destinoEIx == _root["pp_"+i]._x && destinoEIy == _root["pp_"+i]._y && _root["pp_"+i].listo == true)
							cajasBienPuestas++;
					//Si no hay una sola caja bien puesta
					if(cajasBienPuestas == 0){
						TweenMax.to(ei, 3, {_alpha:20, ease:Sine.easeOut, onComplete:muerePersonaje});
						numMensaje = 0;
						/*ei._alpha = 20;
						muerePersonaje();*/
						//El personaje muere. Para que no se pueda mover se cambia su nombre
						ei._name = "eiMuerto";
					}
			}
		}
	}
	else{//Si el movimiento no se hace dentro del escenario
		Key.addListener(eventoTeclado);
	}
}

function moverCaja(){	
	//Se asume que no hay otra caja en el camino
	hayCaja = false;
	//Calcular hacia dónde va a empujarse la caja
	switch(Key.getCode()){
		//Izquierda
		case 37:
			destinoCajax = _root["caja_"+numeroCaja]._x - (baldoza._width - sobraBaldoza);
			destinoCajay = _root["caja_"+numeroCaja]._y;
			break;
		//Arriba
		case 38:
			destinoCajay = _root["caja_"+numeroCaja]._y - (baldoza._height - sobraBaldoza);
			destinoCajax = _root["caja_"+numeroCaja]._x;
			break;
		//Derecha
		case 39:			
			destinoCajax = _root["caja_"+numeroCaja]._x + (baldoza._width - sobraBaldoza);
			destinoCajay = _root["caja_"+numeroCaja]._y;
			break;
		//Abajo
		case 40:
			destinoCajay = _root["caja_"+numeroCaja]._y + (baldoza._height - sobraBaldoza);
			destinoCajax = _root["caja_"+numeroCaja]._x;
			break;
	}
	//Se mira si hay otra caja delante de la que se va a mover
	for(var i = 1; i <= numCajas; i++){
		if(i != numeroCaja){
			if( destinoCajax == _root["caja_"+i]._x && destinoCajay == _root["caja_"+i]._y){						
				hayCaja = true;
				break;
			}
		}
	}
	if(!hayCaja){//Si no hay una caja en el camino
		hayCaja = false;
		TweenMax.to(ei, duracionMovimiento, {_x:(destinoEIx), _y:(destinoEIy), onComplete:terminaMovimiento});
		/*ei._x = destinoEIx;
		ei._y = destinoEIy;
		tiempo();*/
		TweenMax.to(_root["caja_"+numeroCaja], duracionMovimiento, {_x:(destinoCajax), _y:(destinoCajay), onComplete:terminaMovimiento});
		/*_root["caja_"+numeroCaja]._x = destinoCajax;
		_root["caja_"+numeroCaja]._y = destinoCajay;
		tiempo();*/				
		//Se determina si la caja cae al agua
		if((destinoCajax >= limitesTierraX[0] && destinoCajax <= limitesTierraX[1] && destinoCajay >= limitesTierraY[0])
		   || (destinoCajax == limitesTierraX[2] && destinoCajay == limitesTierraY[2])
		   || (destinoCajax >= limitesTierraX[3] && destinoCajay >= limitesTierraY[3])){//Si se cae al agua
			//Se asume que la caja se va a hundir
			hundirCaja = true;
			//El contador de cajasBienPuestas se pone en cero, asumiendo que no hay cajas sirviendo como puente
			cajasBienPuestas = 0;
			//Se mira si la caja que cae al agua cae sobre uno de los soportes para el puente
			for(var i = 1; i <= numCajas;i++){
				//Si la caja cae sobre uno de los soportes del puente se aumenta el contador de cajasBienPuestas
				if(destinoCajax == _root["pp_"+i]._x && destinoCajay == _root["pp_"+i]._y){							
					cajasBienPuestas++;
					//Si en ese soporte no hay una caja, se pone allí, y sale la ventana emergente
					if(_root["pp_"+i].listo != true){
						cuadroRepaso++;
						TweenMax.to(_root["caja_"+numeroCaja].textura, 0.5, {tint:0x824E00});						
						mostrarCR(cuadroRepaso);						
						_root["caja_"+numeroCaja].soporte = true;
						_root["pp_"+i].listo = true
					}
					else//Si en el soporte ya hay una caja, se asume que esta no debe hundirse
						hundirCaja = false;
				}
			}
			//Si hay que hundir la caja
			if(hundirCaja){
				if(_root["caja_"+numeroCaja].soporte != true){
					numMensaje = 1;
					TweenMax.to(_root["caja_"+numeroCaja], 3, {_alpha:20, ease:Sine.easeOut, onComplete:muerePersonaje});
				}
				//Se cambia el nombre a la caja para que no pueda moverse
				_root["caja_"+numeroCaja]._name = "caja_"+numeroCaja+"_u";
			}
			/*Si no se ha puesto bien ninguna de las cajas, 
				entonces esta caja se ha desperdiciado y no hay
				forma de completar el juego. El personaje no
				podrá moverse más, por eso se le cambia el nombre.
			*/
			if(cajasBienPuestas == 0){
				ei._name = "eiMuerto";
			}
		}
	}
	else{//Si la caja no cae al agua
		Key.addListener(eventoTeclado);
		hayCaja = false;
	}
}

function terminaMovimiento(){	
	Key.addListener(eventoTeclado);
	hayCaja = false;
}

function muerePersonaje(){
	switch(numMensaje){
		case 0:
			_root.detenerLocutor();
			_root.etiquetaLocutor = "";
		
			_root.locutor = new Sound();
			_root.locutor.loadSound(_root.origen+"audio/esferaAgua.mp3",true);
			_root.locutor.start();
			
			_root.locutor.onSoundComplete = function(){
				_root.detenerLocutor(_root.etiquetaLocutor);
			};
			break;
		case 1:
			_root.detenerLocutor();
			_root.etiquetaLocutor = "";
		
			_root.locutor = new Sound();
			_root.locutor.loadSound(_root.origen+"audio/cajaAgua.mp3",true);
			_root.locutor.start();
			
			_root.locutor.onSoundComplete = function(){
				_root.detenerLocutor(_root.etiquetaLocutor);
			};
			break;
		case 2:
			_root.detenerLocutor();
			_root.etiquetaLocutor = "";
		
			_root.locutor = new Sound();
			_root.locutor.loadSound(_root.origen+"audio/cajasT.mp3",true);
			_root.locutor.start();
			
			_root.locutor.onSoundComplete = function(){
				_root.detenerLocutor(_root.etiquetaLocutor);
			};
			break;
	}
	b_reiniciar.mensaje.text = mensajes[numMensaje];
	clearInterval(cronometro);
	Key.removeListener(eventoTeclado);
	TweenMax.to(b_reiniciar, 0.5, {_alpha:100});
	b_reiniciar._visible = true;
}

function terminaAlertaBien(){
	TweenMax.to(_root.ok, 0.2, {_alpha:0});
	_root.alertaBien.stop();
	_root.alertaBien = null;
}
function terminaAlertaMal(){
	TweenMax.to(_root.errar, 0.2, {_alpha:0});
	_root.alertaMal.stop();
	_root.alertaMal = null;
}
function mostrarCR(cuadroNumero:Number){
	ei._name = "eiQuieto";
	clearInterval(cronometro);
	c_cuadros.gotoAndPlay("cuadro"+cuadroNumero);
	
	
	_root.detenerLocutor();
	_root.etiquetaLocutor = "";

	_root.locutor = new Sound();
	_root.locutor.loadSound(rutaVoz+"voces/ac01a0"+cuadroNumero+".mp3",true);
	_root.locutor.start();
	
	_root.locutor.onSoundComplete = function(){
		_root.detenerLocutor(_root.etiquetaLocutor);
	};
}
function ventanaCerrada(){
	eiQuieto._name = "ei";
	cronometro = setInterval(tiempo, 1000);
	_root.detenerLocutor();
}
function tiempo(){
	segundos--;
	if(segundos <= 10)
		c_temporizador.texto.textColor = 0xFF0000;
	c_temporizador.texto.text = "00:"+segundos;
	if(segundos == 0){
		clearInterval(cronometro);
		numMensaje = 2;		
		muerePersonaje();
	}
}
function iniciar(){	
	b_reiniciar._visible = false;
	segundos = tiempoJuego;
	c_temporizador.texto.textColor = 0x000000;
	c_temporizador.texto.text = "00:"+segundos;
	
	for(var i=0 ; i <= numCajas; i++){
		if(i == 0){
			posicionesOriginalesX[i] = ei._x;
			posicionesOriginalesY[i] = ei._y;
		}
		else{
			posicionesOriginalesX[i] = _root["caja_"+i]._x;
			posicionesOriginalesY[i] = _root["caja_"+i]._y;
		}
	}
	
	hayCaja = false;
	Key.addListener(eventoTeclado);
	cronometro = setInterval(tiempo, 1000);
}
function reiniciarActividad(){
	c_cuadros.gotoAndStop(1);
	cuadroRepaso = 0;	
	for(var i=0 ; i <= numCajas; i++){
		if(i == 0){
			eiMuerto._name = "ei";
			ei._alpha = 100;
			ei._x = posicionesOriginalesX[i];
			ei._y = posicionesOriginalesY[i];
		}
		else{
			if(_root["caja_"+i+"_u"] != undefined)
				_root["caja_"+i+"_u"]._name = "caja_"+i;
			_root["caja_"+i]._alpha = 100;
			_root["caja_"+i]._x = posicionesOriginalesX[i];
			_root["caja_"+i]._y = posicionesOriginalesY[i];
			_root["caja_"+i].soporte = false;
			TweenMax.to(_root["caja_"+i].textura, 0.1, {tint:0xCC9900});
			_root["pp_"+i].listo = false;
		}
	}
	iniciar();
}

iniciar();
_root.cei.gotoAndPlay("solo");