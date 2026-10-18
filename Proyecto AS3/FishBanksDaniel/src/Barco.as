package  
{
	/**
	 * ...
	 * @author ...
	 */
	public class Barco 
	{
		public var ubicacion:String;
		public static var precio:Number;
		public var capacidad:Number;
		public var tasaPescaPargoCosta:Number;
		public var tasaPescaPargoMarProfundo:Number;
		public var tasaPescaRobaloCosta:Number;
		public var tasaPescaRobaloMarProfundo:Number;
		public var tasaPescaSierraCosta:Number;
		public var tasaPescaSierraMarProfundo:Number;
		
		public static const PUERTO:String    = "puerto"; 
		public static const COSTA:String  = "costa"; 		
		public static const MARPROFUNDO:String = "profundo"; 
		
		public function Barco() 
		{			
		}
		
		public function setUbicacion(ubicacion:String):void
		{
			this.ubicacion = ubicacion;
		}
		
		public function getUbicacion():String
		{
			return(ubicacion);
		}
		
		public function getCapacidad():Number
		{
			return(capacidad);
		}
		
		public function getPrecio():Number
		{
			return(precio);
		}
		
		public function getTasaPescaPargoCosta():Number
		{
			return(tasaPescaPargoCosta);
		}
		
		public function getTasaPescaPargoMarProfundo():Number
		{
			return(tasaPescaPargoMarProfundo);
		}
		
		public function getTasaPescaRobaloCosta():Number
		{
			return(tasaPescaRobaloCosta);
		}
		
		public function getTasaPescaRobaloMarProfundo():Number
		{
			return(tasaPescaRobaloMarProfundo);
		}
		
		public function getTasaPescaSierraCosta():Number
		{
			return(tasaPescaSierraCosta);
		}
		
		public function getTasaPescaSierraMarProfundo():Number
		{
			return(tasaPescaSierraMarProfundo);
		}
		
	}

}