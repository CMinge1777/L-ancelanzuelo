package  {
	/**
	 * ...
	 * @author Fulgore
	 */
	public class CompaniaDTO{
		
		public static const UBICACION_TERRESTRE_NECOCLI:int = 1;
		public static const UBICACION_TERRESTRE_TURBO:int = 2;
		public static const UBICACION_TERRESTRE_BOCASATRATO:int = 3;
		public static const UBICACION_TERRESTRE_ACANDI:int = 4;
		
		public var nombre:String;
		public var password:String;
		public var juego:int;
		public var ubicacion_terrestre:int;
		
		public function CompaniaDTO(nombre:String = "", pasword:String = "", juego:int = 0, ubicacion_terrestre:int = 0) {
			this.nombre = nombre;
			this.password = pasword;
			this.juego = juego;
			this.ubicacion_terrestre = ubicacion_terrestre;
		}
	}

}