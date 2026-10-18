package  
{
	/**
	 * ...
	 * @author ...
	 */
	public class Company 
	{
		private var nombre:String;
		private var dinero:Number;
		
		public function Company(nombre:String, dinero:Number) 
		{
			this.nombre = nombre;
			this.dinero = dinero;
		}
		
		public function getDinero():Number		
		{
			return(dinero);
		}
		
		public function getNombre():String
		{
			return(nombre);
		}
		
		// se le manda el pedido nada mas, el gasto de ubicacion se cobra en la base de datos
		// tambien es importante tener en cuenta que el valor ofertado en la subasta no podra ser mayor a este monto
		// cada vez que se modifique el pedido se llama a este metodo
		public function calcularDinero(pedidoHecho:Pedido):void
		{
			dinero = dinero - pedidoHecho.getPrecioTotal();
		}
		
	}

}