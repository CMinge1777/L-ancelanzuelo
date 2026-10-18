package  {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author Fulgore
	 */
	public class Temporizador extends Sprite{
		
		public static const SINCRONIZAR:String = "sincronize el juego";
		
		private var tiempoFaltante:Number; // tiempo faltante para q se acabe el turno, en milisegundos
		private var turnoActual:int; // turno actual del juego
		private var duracionTurnoMinutos:Number; //duracion del turno en minutos
		private var duracionTurnoMilisegundos:Number;
		private var fechaServidor:Date; //tiempo del servidor
		private var fechaOS:Date; //tiempo del sistema operativo, para calcular el transcurso del tiempo
		private var tfTempo:TextField;
		private var turnoActualDTO:TurnoDTO;
		private var sincronizacionAnterior:Number;
		private var desincronizado:Boolean;
		private var finalizado:Boolean;
		
		/**
		 * 
		 * @param	fechaInicio 
		 * @param	duracionTurnos
		 */
		public function Temporizador() {
		}
		
		public function iniciarTemporizador(fechaServidor:Date, duracionTurnoMinutos:Number, turno:TurnoDTO):void {
			//icializacion variables
			turnoActualDTO = turno;
			this.fechaServidor = fechaServidor;
			this.duracionTurnoMinutos = duracionTurnoMinutos;
			fechaOS = new Date();
			duracionTurnoMilisegundos = duracionTurnoMinutos * 60 * 1000;
			var tiempoactual:Number = fechaServidor.getTime();
			var tiempotranscurrido:Number = tiempoactual - turnoActualDTO.insercion.getTime();
			desincronizado = ((tiempotranscurrido / duracionTurnoMilisegundos) > 1)?true:false;
			sincronizacionAnterior = (new Date()).getTime();
			turnoActual = turnoActualDTO.turno_id;
			tiempoFaltante = duracionTurnoMilisegundos - tiempotranscurrido;
			tfTempo = new TextField();
			var tf:TextFormat = new TextFormat();
			finalizado = (turnoActualDTO.turno_id >= 11)?true:false;
			
			//modificacion de propiedades
			tf.font = "Maiandra GD";
			tf.size = 15;
			tf.color = 0xFFFFFF;
			tf.bold = true;
			tf.align = TextFormatAlign.CENTER;
			tfTempo.selectable = false;
			//tfTempo.border = true;
			//tfTempo.borderColor = 0xaa9955;
			//tfTempo.background = true;
			//tfTempo.backgroundColor = 0x001111;
			tfTempo.defaultTextFormat = tf;
			var dia:int = (((tiempoFaltante / 1000 ) / 60 ) / 60 ) / 24 ;
			tiempoFaltante -= dia * 1000 * 60 * 60 * 24;
			var hora:int = (((tiempoFaltante / 1000 ) / 60 ) / 60 );
			tiempoFaltante -= hora * 1000 * 60 * 60;
			var minuto:int = ((tiempoFaltante / 1000 ) / 60 );
			tiempoFaltante -= minuto * 1000 * 60;
			var segundo:int = tiempoFaltante / 1000;
			tfTempo.text = "--00D :00:00:00--\n -desincronizado 00-";
			tfTempo.width = tfTempo.textWidth;
			if (!finalizado){
				tfTempo.text =  dia.toString() + "D " + hora.toString() + ":" + minuto.toString() + ":" + segundo.toString() + "\n Turno: " + turnoActual.toString();
			} else {
				tfTempo.text = "Juego \nFinalizado";
			}
			tfTempo.height = tfTempo.textHeight + 4;
			
			// adhiriendo al dl
			addChild(tfTempo);
			
			// adhiriendo listeners
			if(!finalizado){
				if (desincronizado) {
					addEventListener(Event.ENTER_FRAME, sincronizando, false, 0, true);
				} else {
					addEventListener(Event.ENTER_FRAME, actualizarTeporizador, false, 0, true);
				}
			}
		}
		
		private function actualizarTeporizador(e:Event):void {
			var tiempoactual:Number = ((new Date()).getTime() - fechaOS.getTime()) + fechaServidor.getTime();
			var tiempotranscurrido:Number = tiempoactual - turnoActualDTO.insercion.getTime();
			var turnoAnterior:int = tiempotranscurrido / duracionTurnoMilisegundos;
			tiempoFaltante = (duracionTurnoMilisegundos) - tiempotranscurrido;
			var dia:int = (((tiempoFaltante / 1000 ) / 60 ) / 60 ) / 24;
			tiempoFaltante -= dia * 1000 * 60 * 60 * 24;
			var hora:int = (((tiempoFaltante / 1000 ) / 60 ) / 60 );
			tiempoFaltante -= hora * 1000 * 60 * 60;
			var minuto:int = ((tiempoFaltante / 1000 ) / 60 );
			tiempoFaltante -= minuto * 1000 * 60;
			var segundo:int = tiempoFaltante / 1000;
			tfTempo.text =  dia.toString() + "D " + hora.toString() + ":" + minuto.toString() + ":" + segundo.toString() + "\n Trimestre: " + turnoActual.toString();
			if (turnoAnterior >= 1 && !desincronizado) { // acabo de desincronizarse
				tfTempo.text =  "Juego\n desincronizado ";
				sincronizacionAnterior = tiempoactual;
				desincronizado = true;
				removeEventListener(Event.ENTER_FRAME, actualizarTeporizador);
				addEventListener(Event.ENTER_FRAME, sincronizando, false, 0, true);
			} 
		}
		
		private function sincronizando(e:Event):void {
			// entra aqui para q despues de 20 segundos vuelva a despachar el evento de sincronizar
			var auxSync:Number = (new Date()).getTime();
			if (auxSync > sincronizacionAnterior + 20000) { // vuelva a llamar el evento de sincronizacion
				sincronizacionAnterior = auxSync;
				dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "", SINCRONIZAR));
			} else { // cuente el tiempo q falta para resincronizar
				var tiempoEspera:int = (((sincronizacionAnterior + 20000) - auxSync) / 1000);
				tfTempo.text =  "Juego\n desincronizado " + tiempoEspera;
			}
		}
		
		public function temporizadorDesincronizado():Boolean { return(desincronizado); }
		
		public function destruir():void {
			try {
				removeEventListener(Event.ENTER_FRAME, actualizarTeporizador);
			} catch (err:Error) {
				// solo por si las moscas
			}
			try {
				removeEventListener(Event.ENTER_FRAME, sincronizando);
			} catch (err:Error) {
				// solo por si las moscas
			}
		}
	}

}