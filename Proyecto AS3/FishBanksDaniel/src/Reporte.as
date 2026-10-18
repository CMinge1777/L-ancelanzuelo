package  
{
	/**
	 * ...
	 * @author ...
	 */
	public class Reporte 
	{
		// estos datos se llenan al inicio de cada turno de la bse de datos,
		// corresponden al turno anterior
		
		private var balanceGeneral:Number;
		private var capturaPargoCosta:Number;
		private var capturaPargoMarProfundo:Number;
		private var capturaRobaloCosta:Number;
		private var capturaRobaloMarProfundo:Number;
		private var capturaSierraCosta:Number;
		private var capturaSierraMarProfundo:Number;
		// esto se calcula de la BD, es lo que se gano con la venta de los peces
		private var ventaTotal:Number;
		private var turno:int;
		
		
		public function Reporte(balanceGeneral:Number, capturaPargoCosta:Number, capturaPargoMarProfundo:Number, capturaRobaloCosta:Number, capturaRobaloMarProfundo:Number, capturaSierraCosta:Number, capturaSierraMarProfundo:Number, ventaTotal:Number, turno:int) 
		{
			this.balanceGeneral = balanceGeneral;
			this.capturaPargoCosta = capturaPargoCosta;
			this.capturaPargoMarProfundo = capturaPargoMarProfundo;
			this.capturaRobaloCosta = capturaRobaloCosta;
			this.capturaRobaloMarProfundo = capturaRobaloMarProfundo;
			this.capturaSierraCosta = capturaSierraCosta;
			this.capturaSierraMarProfundo = capturaSierraMarProfundo;
			this.ventaTotal = ventaTotal;
			this.turno = turno;
		}
		
		public function getBalanceGeneral():Number
		{
			return(balanceGeneral);
		}
		
		public function getCapturaPargoCosta():Number
		{
			return(capturaPargoCosta);
		}
		
		public function getCapturaPargoMarProfundo():Number
		{
			return(capturaPargoMarProfundo);
		}
		
		public function getCapturaRobaloCosta():Number
		{
			return(capturaRobaloCosta);
		}
		
		public function getCapturaRobaloMarProfundo():Number
		{
			return(capturaRobaloMarProfundo);
		}
		
		public function getCapturaSierraCosta():Number
		{
			return(capturaSierraCosta);
		}
		
		public function getCapturaSierraMarProfundo():Number
		{
			return(capturaSierraMarProfundo);
		}
		
		public function getVentaTotal():Number
		{
			return(ventaTotal);
		}
		
		public function getTurno():Number
		{
			return(turno);
		}
		
	}

}