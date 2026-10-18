package  
{
	import com.gskinner.motion.easing.*;
	import com.gskinner.motion.GTween;
	import de.polygonal.ds.Array2;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author Fulgore
	 */
	public class VistaGolfo extends Sprite {
		
		[Embed(source = 'data/graficos/vistas/VistaGolfo.jpg')] private var Fondo:Class;
		[Embed(source = 'data/graficos/iconos/Corona.png')] private var Corona:Class;
		[Embed(source = 'data/graficos/iconos/PuertoAcandi.png')] private var PuertoAcandiAmarillo:Class;
		[Embed(source = 'data/graficos/iconos/PuertoBocasAtrato.png')] private var PuertoBocasAtratoRojo:Class;
		[Embed(source = 'data/graficos/iconos/PuertoNecocli.png')] private var PuertoNecocliAzul:Class;
		[Embed(source = 'data/graficos/iconos/PuertoTurbo.png')] private var PuertoTurboVerde:Class;
		[Embed(source = 'data/graficos/zonas/Costa.png')] private var MarCosta:Class;
		[Embed(source = 'data/graficos/zonas/MarProfundo.png')] private var MarProfundo:Class;
		
		private const ROJO:int = 0xfe483d;
		private const AZUL:int = 0x3bd9ff;
		private const AMARILLO:int = 0xfbc73b;
		private const VERDE:int = 0x49fd69;
		
		public static const COLOR_ROJO:String = "rojo";
		public static const COLOR_AZUL:String = "azul";
		public static const COLOR_AMARILLO:String = "amarillo";
		public static const COLOR_VERDE:String = "verde";
		
		public static const ZONA_TERRESTRE_ACANDI:String =  "acandi";
		public static const ZONA_TERRESTRE_NECOCLI:String =  "necocli";
		public static const ZONA_TERRESTRE_TURBO:String =  "turbo";
		public static const ZONA_TERRESTRE_BOCASATRATO:String =  "bocasAtrato";
		
		public static const ZONA_MARITIMA_COSTA:String =  "costa";
		public static const ZONA_MARITIMA_PROFUNDO:String =  "profundo";
		
		public static const BARCO_CHALUPA:String =  "chalupa";
		public static const BARCO_PESQUERO:String =  "pesquero";
		public static const BARCO_PANGA:String =  "panga";
		
		public static const EVENTO_IR_COMPANIA:String = "irAcompania";
		public static const EVENTO_MOSTRAR_COMPANIA:String = "verCompania";
		
		private var compania1:IconoVisual;
		private var compania2:IconoVisual;
		private var compania3:IconoVisual;
		private var compania4:IconoVisual;
		private var nombreCompania1:TextField;
		private var nombreCompania2:TextField;
		private var nombreCompania3:TextField;
		private var nombreCompania4:TextField;
		private var tablaPosiciones:TextField;
		private var corona:IconoVisual;
		private var companiasJugando:int;
		private var fondo:Bitmap;
		private var barcosCostaCompania1:Vector.<Shape>;
		private var	barcosCostaCompania2:Vector.<Shape>;
		private var	barcosCostaCompania3:Vector.<Shape>;
		private var	barcosCostaCompania4:Vector.<Shape>;
		private var	barcosProfundoCompania1:Vector.<Shape>;
		private var	barcosProfundoCompania2:Vector.<Shape>;
		private var	barcosProfundoCompania3:Vector.<Shape>;
		private var	barcosProfundoCompania4:Vector.<Shape>;
		private var bandera_aduenarseDeCompania:Boolean;
		private var matrizPosProfundo:Array2; // matriz de 1s y 0s que representan en donde se pueden poner los barcos, 1:si se puede, 0:no se puede
		private var matrizPosCosta:Array2;// matriz de 1s y 0s que representan en donde se pueden poner los barcos, 1:si se puede, 0:no se puede
		private var temporizador:Temporizador;
		private var splashIniciando:SplashScreen;
		
		public function VistaGolfo() {
			//inicializacion de variables
			fondo = new Fondo as Bitmap;
			compania1 = new IconoVisual(PuertoTurboVerde);
			compania2 = new IconoVisual(PuertoNecocliAzul);
			compania3 = new IconoVisual(PuertoBocasAtratoRojo);
			compania4 = new IconoVisual(PuertoAcandiAmarillo);
			compania1.tabEnabled = false;
			compania2.tabEnabled = false;
			compania3.tabEnabled = false;
			compania4.tabEnabled = false;
			corona = new IconoVisual(Corona);
			corona.tabEnabled = false;
			barcosCostaCompania1 = new Vector.<Shape>;
			barcosCostaCompania2 = new Vector.<Shape>;
			barcosCostaCompania3 = new Vector.<Shape>;
			barcosCostaCompania4 = new Vector.<Shape>;
			barcosProfundoCompania1 = new Vector.<Shape>;
			barcosProfundoCompania2 = new Vector.<Shape>;
			barcosProfundoCompania3 = new Vector.<Shape>;
			barcosProfundoCompania4 = new Vector.<Shape>;
			nombreCompania1 = new TextField();
			nombreCompania2 = new TextField();
			nombreCompania3 = new TextField();
			nombreCompania4 = new TextField();
			tablaPosiciones = new TextField();
			temporizador = new Temporizador();
			companiasJugando = 0;
			bandera_aduenarseDeCompania = true;
			llenarMatricesPosicionamiento((new  MarCosta as Bitmap).bitmapData, (new  MarProfundo as Bitmap).bitmapData);
			var tf:TextFormat = new TextFormat();
			
			
			//modificacion de propiedades
			tf.font = "Maiandra GD";
			tf.size = 15;
			tf.bold = true;
			//tf.color = 0xaa9955;
			tf.color = 0xFFFFFF;
			tf.align = TextFormatAlign.CENTER;
			nombreCompania1.selectable = false;
			//nombreCompania1.border = true;
			//nombreCompania1.borderColor = 0xaa9955;
			//nombreCompania1.background = true;
			//nombreCompania1.backgroundColor = 0x001111;
			nombreCompania1.defaultTextFormat = tf;
			nombreCompania2.selectable = false;
			//nombreCompania2.border = true;
			//nombreCompania2.borderColor = 0xaa9955;
			//nombreCompania2.background = true;
			//nombreCompania2.backgroundColor = 0x001111;
			nombreCompania2.defaultTextFormat = tf;
			nombreCompania3.selectable = false;
			//nombreCompania3.border = true;
			//nombreCompania3.borderColor = 0xaa9955;
			//nombreCompania3.background = true;
			//nombreCompania3.backgroundColor = 0x001111;
			nombreCompania3.defaultTextFormat = tf;
			nombreCompania4.selectable = false;
			//nombreCompania4.border = true;
			//nombreCompania4.borderColor = 0xaa9955;
			//nombreCompania4.background = true;
			//nombreCompania4.backgroundColor = 0x001111;
			nombreCompania4.defaultTextFormat = tf;
			tablaPosiciones.selectable = false;
			//tablaPosiciones.border = true;
			//tablaPosiciones.borderColor = 0xaa9955;
			//tablaPosiciones.background = true;
			//tablaPosiciones.backgroundColor = 0x001111;
			tablaPosiciones.defaultTextFormat = tf;
			
			//adhecion al DL
			addChild(fondo);
			
			//hubicacion
			
		}
		
		public function resetearVista():void {
			
			if (compania1.parent) {
				removeChild(compania1);
				compania1 = null;
				compania1 = new IconoVisual(PuertoTurboVerde);
			}
			if (compania2.parent) {
				removeChild(compania2);
				compania2 = null;
				compania2 = new IconoVisual(PuertoNecocliAzul);
			}
			if (compania3.parent) {
				removeChild(compania3);
				compania3 = null;
				compania3 = new IconoVisual(PuertoBocasAtratoRojo);
			}
			if (compania4.parent) {
				removeChild(compania4);
				compania4 = null;
				compania4 = new IconoVisual(PuertoAcandiAmarillo);
			}
			
			removeChild(corona);
			corona = null;
			corona = new IconoVisual(Corona);
			
			removerBarcos(barcosCostaCompania1);
			removerBarcos(barcosCostaCompania2);
			removerBarcos(barcosCostaCompania3);
			removerBarcos(barcosCostaCompania4);
			removerBarcos(barcosProfundoCompania1);
			removerBarcos(barcosProfundoCompania2);
			removerBarcos(barcosProfundoCompania3);
			removerBarcos(barcosProfundoCompania4);
			barcosCostaCompania1 = null;
			barcosCostaCompania2 = null;
			barcosCostaCompania3 = null;
			barcosCostaCompania4 = null;
			barcosProfundoCompania1 = null;
			barcosProfundoCompania2 = null;
			barcosProfundoCompania3 = null;
			barcosProfundoCompania4 = null;
			barcosCostaCompania1 = new Vector.<Shape>;
			barcosCostaCompania2 = new Vector.<Shape>;
			barcosCostaCompania3 = new Vector.<Shape>;
			barcosCostaCompania4 = new Vector.<Shape>;
			barcosProfundoCompania1 = new Vector.<Shape>;
			barcosProfundoCompania2 = new Vector.<Shape>;
			barcosProfundoCompania3 = new Vector.<Shape>;
			barcosProfundoCompania4 = new Vector.<Shape>;
			
			if (nombreCompania1.parent) {
				removeChild(nombreCompania1);
				nombreCompania1 = null;
				nombreCompania1 = new TextField();
			}
			if (nombreCompania2.parent) {
				removeChild(nombreCompania2);
				nombreCompania2 = null;
				nombreCompania2 = new TextField();
			}
			if (nombreCompania3.parent) {
				removeChild(nombreCompania3);
				nombreCompania3 = null;
				nombreCompania3 = new TextField();
			}
			if (nombreCompania4.parent) {
				removeChild(nombreCompania4);
				nombreCompania4 = null;
				nombreCompania4 = new TextField();
			}
			
			//tablaPosiciones.text = "WTF";
			removeChild(tablaPosiciones);
			tablaPosiciones = null;
			tablaPosiciones = new TextField();
			
			removeChild(temporizador);
			temporizador.destruir();
			temporizador = null;
			temporizador = new Temporizador();
			
			companiasJugando = 0;
			bandera_aduenarseDeCompania = true;
			llenarMatricesPosicionamiento((new  MarCosta as Bitmap).bitmapData, (new  MarProfundo as Bitmap).bitmapData);
			var tf:TextFormat = new TextFormat();
			
			
			//modificacion de propiedades
			tf.font = "Maiandra GD";
			tf.size = 15;
			tf.bold = true;
			tf.color = 0xFFFFFF;
			tf.align = TextFormatAlign.CENTER;
			nombreCompania1.selectable = false;
			nombreCompania1.defaultTextFormat = tf;
			nombreCompania2.selectable = false;
			nombreCompania2.defaultTextFormat = tf;
			nombreCompania3.selectable = false;
			nombreCompania3.defaultTextFormat = tf;
			nombreCompania4.selectable = false;
			nombreCompania4.defaultTextFormat = tf;
			tablaPosiciones.selectable = false;
			tablaPosiciones.defaultTextFormat = tf;
			
			//adhecion al DL
			
			//hubicacion
		}
		
		private function removerBarcos(vectorBarcos:Vector.<Shape>):void{
			for each (var item:Shape in vectorBarcos) {
				removeChild(item);
				item = null;
			}
		}
		
		/**
		 * Pone el temporizador en la vista, el que muestra el tiempo faltante para la finalizacion del turno
		 * @param	fechaInicio
		 * @param	duracionTurnoMinutos
		 */
		public function iniciarTemporizador(fechaInicio:Date,duracionTurnoMinutos:Number,turnoActual:TurnoDTO):void {
			temporizador.iniciarTemporizador(fechaInicio, duracionTurnoMinutos,turnoActual);
			temporizador.x = 140 - (temporizador.width/2);
			temporizador.y = 515;
			temporizador.addEventListener(StatusEvent.STATUS, sincronizarVista, false, 0, true);
			addChild(temporizador);
		}
		
		private function sincronizarVista(e:StatusEvent):void {
			//var spsh:SplashScreen = new SplashScreen("Sync", 0.3);
			//spsh.y = Math.random() * 350;
			//addChild(spsh);
			dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "", Temporizador.SINCRONIZAR));
		}
		
		private function llenarMatricesPosicionamiento(costaBMD:BitmapData, profundoBMD:BitmapData):void {
			
			matrizPosCosta = new Array2(costaBMD.width, costaBMD.height);
			matrizPosProfundo = new Array2(profundoBMD.width, profundoBMD.height);
			for (var i:int = 0; i < matrizPosCosta.width; i++) {
				for (var j:int = 0; j < matrizPosCosta.height; j++) {
					switch (costaBMD.getPixel32(i + 1, j + 1)) {
						case 0x00000000: {
							matrizPosCosta.set(i, j, new int(-1));
							break;
						} case 0xFF000000: {
							matrizPosCosta.set(i, j, new int(1));
							break;
						} default:  {
							matrizPosCosta.set(i, j, new int(1));
							break;
						}
					}
				}
			}
			
			for (var ii:int = 0; ii < matrizPosProfundo.width; ii++) {
				for (var jj:int = 0; jj < matrizPosProfundo.height; jj++) {
					switch (profundoBMD.getPixel32(ii + 1, jj + 1)) {
						case 0x00000000: {
							matrizPosProfundo.set(ii, jj, new int(-1));
							break;
						} case 0xFF000000: {
							matrizPosProfundo.set(ii, jj, new int(1));
							break;
						} default:  {
							matrizPosProfundo.set(ii, jj, new int(1));
							break;
						}
					}
				}
			}
		}
		
		/**
		 * Pone en la vista una cantidad de barcos de un respectivo color
		 * @param	zonaMaritima - zona maritima en la q se desean poner los barcos, usar las constantes ZONA_MARITIMA_
		 * @param	cantidad - cantidad de barcos q se desean poner
		 * @param	color - color de la compañia a la que pertenecen compania1-necocli-azul compania2-turbo-verde compania3-bocasatrato-rojo compania4-acandi-amarillo
		 */
		public function ubicarBarcos(zonaMaritima:String, cantidad:int, barco:String, str_color:String):void {
			var color:int;
			switch (str_color) {
				case COLOR_AMARILLO :  {
					color = AMARILLO;
					break;
				} case COLOR_AZUL :  {
					color = AZUL;
					break;
				} case COLOR_ROJO :  {
					color = ROJO;
					break;
				} case COLOR_VERDE :  {
					color = VERDE;
					break;
				} 
			}
			switch (zonaMaritima) {
				case ZONA_MARITIMA_COSTA: {
					for (var i:int = 0; i < cantidad; i++) {
						var posicion:Point = new Point(Math.random() * matrizPosCosta.width, Math.random() * matrizPosCosta.height);
						posicion = entregarPosicion(posicion,barco,true);
						var shBarco:Shape = new Shape();
						shBarco = construirBarco(barco, color);
						shBarco.x = posicion.x;
						shBarco.y = posicion.y;
						shBarco.rotation = Math.random() * 360;
						addChild(shBarco);
						switch (color) {
							case AMARILLO : {
								barcosCostaCompania4.push(shBarco);
								break;
							} case AZUL :  {
								barcosCostaCompania1.push(shBarco);
								break;
							} case ROJO :  {
								barcosCostaCompania3.push(shBarco);
								break;
							} case VERDE :  {
								barcosCostaCompania2.push(shBarco);
								break;
							}
						}
					}
					break;
				} case ZONA_MARITIMA_PROFUNDO :  {
					for (var ii:int = 0; ii < cantidad; ii++) {
						var posicion1:Point = new Point(Math.random() * matrizPosProfundo.width, Math.random() * matrizPosProfundo.height);
						posicion1 = entregarPosicion(posicion1,barco,false);
						var shBarco1:Shape = new Shape();
						shBarco1 = construirBarco(barco, color);
						shBarco1.x = posicion1.x;
						shBarco1.y = posicion1.y;
						shBarco1.rotation = Math.random() * 360;
						addChild(shBarco1);
						switch (color) {
							case AMARILLO : {
								barcosProfundoCompania4.push(shBarco1);
								break;
							} case AZUL :  {
								barcosProfundoCompania1.push(shBarco1);
								break;
							} case ROJO :  {
								barcosProfundoCompania3.push(shBarco1);
								break;
							} case VERDE :  {
								barcosProfundoCompania2.push(shBarco1);
								break;
							}
						}
					}
					break;
				}
			}
		}
		
		private function entregarPosicion(punto:Point, tipo_barco:String, esCosta:Boolean):Point {
			var xx:int = punto.x;
			var yy:int = punto.y;
			var pos:Point = new Point(xx, yy);
			var posSC:int = 0;
			var matriz:Array2 = (esCosta)?matrizPosCosta:matrizPosProfundo;
			var posInt:int = (matriz.width -1) * (matriz.height - 1);
			var entregar:Boolean = false;
			var maxWidth:int = matriz.width - 1;
			var maxHeight:int = matriz.height - 1;
			while (!entregar) {
				//verifique si se puede poner en punto
				if (matriz.get(pos.x, pos.y) as int == 1) {
					//si - tape alrededor dependiendo del barco y entregue el punto
					switch (tipo_barco) {
						case BARCO_CHALUPA:  {//5-3
							var aux1:Point = new Point(pos.x-2, pos.y-2);
							for (var i:int = 0; i < 5; i++) {
								for (var j:int = 0; j < 5; j++) {
									if ((i != 0 && j != 0) || (i != 0 && j != 4) || (i != 4 && j != 0) || (i != 4 && j != 4)) {
										if (((!((aux1.x + i) < 0)) || (!((aux1.x + i) > maxWidth))) || ((!((aux1.y + j) < 0)) || (!((aux1.y + j) > maxHeight)))) { 
											//control cuando se sale de los bounds de la matriz
											matriz.set(aux1.x + i, aux1.y + j, 0);
										}
									}
								}
							}
							break;
						} case BARCO_PANGA:  {//7-4
							var aux2:Point = new Point(pos.x-3, pos.y-3);
							for (var ii:int = 0; ii < 5; ii++) {
								for (var jj:int = 0; jj < 5; jj++) {
									if ((ii != 0 && jj != 0) || (ii != 0 && jj != 4) || (ii != 4 && jj != 0) || (ii != 4 && jj != 4)) {
										if ((!((aux2.x + ii) < 0) || !((aux2.x + ii) > maxWidth)) || (!((aux2.y + jj) < 0) || !((aux2.y + jj) > maxHeight))) { 
											//control cuando se sale de los bounds de la matriz
											matriz.set(aux2.x + ii, aux2.y + jj, 0);
										}
									}
								}
							}
							break;
						} case BARCO_PESQUERO :  {//8-5
							var aux3:Point = new Point(pos.x-4, pos.y-4);
							for (var iii:int = 0; iii < 5; iii++) {
								for (var jjj:int = 0; jjj < 5; jjj++) {
									if ((iii != 0 && jjj != 0) || (iii != 0 && jjj != 4) || (iii != 4 && jjj != 0) || (iii != 4 && jjj != 4)) {
										if (!((aux3.x + iii) < 0) || !((aux3.x + iii) > maxWidth) || !((aux3.y + jjj) < 0) || !((aux3.y + jjj) > maxHeight)) { 
											//control cuando se sale de los bounds de la matriz
											matriz.set(aux3.x + iii, aux3.y + jjj, 0);
										}
									}
								}
							}
							break;
						}
					}
					entregar = true;
				} else { // no - busque un punto vacio
					var paso:int = Math.random() * 200;
					pos.x = (pos.x + paso >= matriz.width)?0:pos.x + paso;
					if (pos.x == 0 ) {
						pos.y = (pos.y + 1 >= matriz.height)?0:pos.y + 1;
					}
					posSC++;
					if (posSC == posInt) { // significa q le dio la vuelta y no encontro posicion
						//encuentre el primer 0 y retorne esa posicion
						var encontro:Boolean = false;
						var px:int = (Math.random() * (matriz.width / 2)) - (matriz.width / 3);
						var py:int = (Math.random() * (matriz.height / 2)) - (matriz.height / 3);
						pos.x = px;
						pos.y = py;
						while (!encontro) {
							pos.x = (pos.x + 1 >= (matriz.width)?0:pos.x + 1);
							if (pos.x == 0) {
								pos.y = (pos.y + 1 >= (matriz.height)?0:pos.y + 1);
							}
							if (matriz.get(pos.x, pos.y) as int == 0 ) {
								encontro = true;
							}
						}
						entregar = true;
					}
				}
			} 
			pos.x = (esCosta)?pos.x + 48:pos.x + 116;
			return(pos);
		}
		
		/**
		 * Ubica en la vista que compañias se ven. Tecnicamente representa los contrincantes y el rpopio jugador
		 * necocli = 1, turbo = 2, bocasAtrato = 3, acandi = 4
		 * @param	cuantas
		 */
		public function ponerCompanias(cuantas:int, nombres:Vector.<String>):void {
			companiasJugando = cuantas;
			actualizarTablaDePosiciones(nombres);
			for (var i:int = 1; i <= companiasJugando; i++) {
				switch(i) {
					case 1: {
						compania1.x = 513;
						compania1.y = 157;
						addChild(compania1);
						nombreCompania1.text = nombres[0];
						nombreCompania1.width = nombreCompania1.textWidth + 6;
						nombreCompania1.height = nombreCompania1.textHeight + 4;
						nombreCompania1.x = 543 - (nombreCompania1.width / 2);
						nombreCompania1.y = 206;
						addChild(nombreCompania1);
						if (compania2.parent) {
							removeChild(compania2);
							removeChild(nombreCompania2);
						}
						if (compania3.parent) {
							removeChild(compania3);
							removeChild(nombreCompania3);
						}
						if (compania4.parent) {
							removeChild(compania4);
							removeChild(nombreCompania4);
						}
						break;
					} case 2: {
						compania2.x = 563;
						compania2.y = 428;
						addChild(compania2);
						nombreCompania2.text = nombres[1];
						nombreCompania2.width = nombreCompania2.textWidth + 6;
						nombreCompania2.height = nombreCompania2.textHeight + 4;
						nombreCompania2.x = 593 - (nombreCompania2.width / 2);
						nombreCompania2.y = 481;
						addChild(nombreCompania2);
						if (compania3.parent) {
							removeChild(compania3);
							removeChild(nombreCompania3);
						}
						if (compania4.parent) {
							removeChild(compania4);
							removeChild(nombreCompania4);
						}
						break;
					} case 3: {
						compania3.x = 302;
						compania3.y = 287;
						addChild(compania3);
						nombreCompania3.text = nombres[2];
						nombreCompania3.width = nombreCompania3.textWidth + 6;
						nombreCompania3.height = nombreCompania3.textHeight + 4;
						nombreCompania3.x = 324 - (nombreCompania3.width / 2);
						nombreCompania3.y = 338;
						addChild(nombreCompania3);
						if (compania4.parent) {
							removeChild(compania4);
							removeChild(nombreCompania4);
						}
						break;
					} case 4: {
						compania4.x = 99;
						compania4.y = 86;
						addChild(compania4);
						nombreCompania4.text = nombres[3];
						nombreCompania4.width = nombreCompania4.textWidth + 6;
						nombreCompania4.height = nombreCompania4.textHeight + 4;
						nombreCompania4.x = 126 - (nombreCompania4.width / 2);
						nombreCompania4.y = 138;
						addChild(nombreCompania4);
						break;
					}
				}
			}
		}
		
		/**
		 * Este cliente va a ser dueño de cual compañia, tecnicamente le da control visual a una compañia seleccionada
		 * Este metodo solo se puede usar 1 vez por objeto instanciado
		 * @param	zonaTerrestre - usar las constantes estaticas dentro de esta clase con el prefijo ZONA_TERRESTRE
		 */
		public function aduenarseDeCompania(zonaTerrestre:String):void {
			if (bandera_aduenarseDeCompania) {
				bandera_aduenarseDeCompania = false;
				switch(zonaTerrestre) {
					case ZONA_TERRESTRE_NECOCLI : {
						compania1.addEventListener(MouseEvent.CLICK, irCompania, false, 0, true);
						compania2.addEventListener(MouseEvent.CLICK, mostrarDatosCompania, false, 0, true);
						compania3.addEventListener(MouseEvent.CLICK, mostrarDatosCompania, false, 0, true);
						compania4.addEventListener(MouseEvent.CLICK, mostrarDatosCompania, false, 0, true);
						break;
					} case ZONA_TERRESTRE_TURBO : {
						compania2.addEventListener(MouseEvent.CLICK, irCompania, false, 0, true);
						compania1.addEventListener(MouseEvent.CLICK, mostrarDatosCompania, false, 0, true);
						compania3.addEventListener(MouseEvent.CLICK, mostrarDatosCompania, false, 0, true);
						compania4.addEventListener(MouseEvent.CLICK, mostrarDatosCompania, false, 0, true);
						break;
					} case ZONA_TERRESTRE_BOCASATRATO : {
						compania3.addEventListener(MouseEvent.CLICK, irCompania, false, 0, true);
						compania1.addEventListener(MouseEvent.CLICK, mostrarDatosCompania, false, 0, true);
						compania2.addEventListener(MouseEvent.CLICK, mostrarDatosCompania, false, 0, true);
						compania4.addEventListener(MouseEvent.CLICK, mostrarDatosCompania, false, 0, true);
						break;
					} case ZONA_TERRESTRE_ACANDI : {
						compania4.addEventListener(MouseEvent.CLICK, irCompania, false, 0, true);
						compania1.addEventListener(MouseEvent.CLICK, mostrarDatosCompania, false, 0, true);
						compania2.addEventListener(MouseEvent.CLICK, mostrarDatosCompania, false, 0, true);
						compania3.addEventListener(MouseEvent.CLICK, mostrarDatosCompania, false, 0, true);
						break;
					}
				}
			}
		}
		
		private function irCompania(e:MouseEvent):void {
			dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "", EVENTO_IR_COMPANIA));
		}
		
		private function mostrarDatosCompania(e:MouseEvent):void {
			dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "", EVENTO_MOSTRAR_COMPANIA));
		}
		
		/**
		 * 
		 * @param	tipo - usar las constantes estaticas con el prefijo BARCO_
		 * @param	color
		 * @return
		 */
		private function construirBarco(tipo:String, color:int):Shape {
			
			var shape:Shape = new Shape();
			shape.graphics.beginFill(color);
			shape.graphics.lineStyle();
			switch(tipo) {
				case BARCO_CHALUPA: {
					shape.graphics.drawRoundRect( -2.5, -1.5, 5, 3, 2);
					break;
				} case BARCO_PANGA: {
					shape.graphics.drawRoundRect( -6.5, -2, 7, 4, 3);
					break;
				} case BARCO_PESQUERO: {
					shape.graphics.drawRoundRect( -4, -2.5, 8, 5, 2);
					break;
				}
			}
			shape.graphics.endFill();
			return(shape);
		}
		
		/**
		 * Cual compañia va ganando
		 * @param	zonaTerrestre - usar las constantes estaticas dentro de esta clase con el prefijo ZONA_
		 */		
		public function ponerCorona(zonaTerrestre:String):void {
			switch(zonaTerrestre) {
				case ZONA_TERRESTRE_NECOCLI : {
					corona.x = 515;
					corona.y = 123;
					break;
				} case ZONA_TERRESTRE_TURBO : {
					corona.x = 570;
					corona.y = 396;
					break;
				} case ZONA_TERRESTRE_BOCASATRATO : {
					corona.x = 305;
					corona.y = 250;
					break;
				} case ZONA_TERRESTRE_ACANDI : {
					corona.x = 99;
					corona.y = 56;
					break;
				} 
			}
			if(corona.parent == null) {
				addChild(corona);
			}
		}
		
		/**
		 * Anima los barquitos como si hubiese oleaje
		 */
		public function animacionOleaje():void {
			var tween:GTween;
			//var easeExp:Function = Exponential.easeOut(10,0,0,0);
			for each (var item1:Shape in barcosCostaCompania1) {
				tween = new GTween(item1, 2.5, { x:(item1.x + 3), y:(item1.y + 2) }, { ease:Exponential.easeOut, delay:(Math.random()*2)});
				tween.onComplete = terminoAnimacion;
			}
			for each (var item2:Shape in barcosCostaCompania2) {
				tween = new GTween(item2, 2.5, { x:(item2.x + 3), y:(item2.y + 2) }, { ease:Exponential.easeOut, delay:(Math.random()*2)} );
				tween.onComplete = terminoAnimacion;
			}
			for each (var item3:Shape in barcosCostaCompania3) {
				tween = new GTween(item3, 2.5, { x:(item3.x + 3), y:(item3.y + 2) }, { ease:Exponential.easeOut, delay:(Math.random()*2)} );
				tween.onComplete = terminoAnimacion;
			}
			for each (var item4:Shape in barcosCostaCompania4) {
				tween = new GTween(item4, 2.5, { x:(item4.x + 3), y:(item4.y + 2) }, { ease:Exponential.easeOut, delay:(Math.random()*2)} );
				tween.onComplete = terminoAnimacion;
			}
			for each (var item11:Shape in barcosProfundoCompania1) {
				tween = new GTween(item11, 2.5, { x:(item11.x + 3), y:(item11.y + 2) }, { ease:Exponential.easeOut, delay:(Math.random()*2)} );
				tween.onComplete = terminoAnimacion;
			}
			for each (var item22:Shape in barcosProfundoCompania2) {
				tween = new GTween(item22, 2.5, { x:(item22.x + 3), y:(item22.y + 2) }, { ease:Exponential.easeOut, delay:(Math.random()*2)} );
				tween.onComplete = terminoAnimacion;
			}
			for each (var item33:Shape in barcosProfundoCompania3) {
				tween = new GTween(item33, 2.5, { x:(item33.x + 3), y:(item33.y + 2) }, { ease:Exponential.easeOut, delay:(Math.random()*2)});
				tween.onComplete = terminoAnimacion;
			}
			for each (var item44:Shape in barcosProfundoCompania4) {
				tween = new GTween(item44, 2.5, { x:(item44.x + 3), y:(item44.y + 2) }, { ease:Exponential.easeOut, delay:(Math.random()*2)} );
				tween.onComplete = terminoAnimacion;
			}
		}
		
		private function terminoAnimacion(tween:GTween):void {
			//var easeExp:Function = Exponential.easeOut(10,0,0,0);
			var tween1:GTween = new GTween(tween.target, 2.5, { x:(tween.target.x - 3), y:(tween.target.y - 2) }, { ease:Exponential.easeOut} );
			tween1.onComplete = terminoAnimacion2;
		}
		
		private function terminoAnimacion2(tween:GTween):void {
			//var easeExp:Function = Exponential.easeOut(10,0,0,0);
			var tween1:GTween = new GTween(tween.target, 2.5, { x:(tween.target.x + 3), y:(tween.target.y + 2) }, { ease:Exponential.easeOut } );
			tween1.onComplete = terminoAnimacion;
		}
		
		/**
		 * Actualiza la tabla de posiciones
		 * @param	nombres - el vector debe de estar ordenado de  mejor a peor posicion
		 */
		public function actualizarTablaDePosiciones(nombres:Vector.<String>):void {
			tablaPosiciones.text = "Posiciones\n";
			for (var i:int = 0; i < companiasJugando ; i++) {
				tablaPosiciones.text = tablaPosiciones.text + ( i + 1 ) + " " + nombres[i] + "\n";
			}
			tablaPosiciones.width = tablaPosiciones.textWidth + 6;
			tablaPosiciones.height = tablaPosiciones.textHeight + 4;
			tablaPosiciones.x = 678 - (tablaPosiciones.width / 2);
			tablaPosiciones.y = 35;
			addChild(tablaPosiciones);
			//678-35
		}
		
		public function splashSincronizando():void {
			var splashSync:SplashScreen = new SplashScreen("SINCRONIZANDO", 2);
			splashSync.x = 400 - splashSync.width / 2;
			splashSync.y = 300;
			addChild(splashSync);
		}
		
		public function adherirSplashIniciando():void {
			splashIniciando = new SplashScreen("CARGANDO", 0);
			splashIniciando.x = 400 - splashIniciando.width / 2;
			splashIniciando.y = 100;
			addChild(splashIniciando);
		}
		
		public function quitarSplashIniciando():void {
			splashIniciando.destroyMe();
		}
	}

}