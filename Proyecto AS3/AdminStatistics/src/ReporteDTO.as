package  
{
	/**
	 * ...
	 * @author 
	 */
	public class ReporteDTO 
	{
		
		public var turno_id:int;
		public var juego_id:int;
		public var compania_nombre:String;
		public var captura_pargo_costa:int;
		public var captura_pargo_mar_profundo:int;
		public var captura_robalo_costa:int;
		public var captura_robalo_mar_profundo:int;
		public var captura_sierra_costa:int;
		public var captura_sierra_mar_proundo:int;
		public var balance_general:int;
				
		public function ReporteDTO(turno:int = 0, juego:int = 0, compania_nombre:String = "", captura_pargo_costa:int = 0, captura_pargo_mar_profundo:int = 0, captura_robalo_costa:int = 0, captura_robalo_mar_profundo:int = 0, captura_sierra_costa:int = 0, captura_sierra_mar_proundo:int = 0, balance_general:int = 0) {
			this.turno_id = turno;
			this.juego_id = juego;
			this.compania_nombre = compania_nombre;
			this.captura_pargo_costa = captura_pargo_costa;
			this.captura_pargo_mar_profundo = captura_pargo_mar_profundo;
			this.captura_robalo_costa = captura_robalo_costa;
			this.captura_robalo_mar_profundo = captura_robalo_mar_profundo;
			this.captura_sierra_costa = captura_sierra_costa;
			this.captura_sierra_mar_proundo = captura_sierra_mar_proundo;
			this.balance_general = balance_general;
		}
		
	}

}