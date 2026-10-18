package  
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author ...
	 */
	public class Subasta 
	{
		
		private var costo:Number;
		private var barcos:Array;
		private var numeroChalupas:Number = 0;
		private var numeroPangas:Number = 0;
		private var numeroPesqueros:Number = 0;
		
		public function Subasta(costo:Number, barcos:Array):void
		{
			this.costo = costo;
			this.barcos = barcos;
			contarBarcos();
		}
		
		public function getCosto():Number
		{
			return(costo);
		}
		
		public function getBarcos():Array
		{
			return(barcos);
		}
		
		public function setCosto(costo:Number):void
		{
			this.costo = costo;
		}
		
		public function setBarcos(barcos:Array):void
		{
			this.barcos = barcos;
			contarBarcos();
		}
		
		public function contarBarcos():void
		{
			for (var i:Number = 0; i < barcos.length; i++)
			{
				var aux:Barco = barcos[i] as Barco;
				if (aux is Chalupa)
				{
					numeroChalupas++;
				}
				else if (aux is Panga)
				{
					numeroPangas++;
				}
				else if (aux is Pesquero)
				{
					numeroPesqueros++;
				}
				
			}
		}
		
		public function getNumeroChalupas():Number
		{
			return(numeroChalupas);
		}
		
		public function getNumeroPangas():Number
		{
			return(numeroPangas);
		}
		
		public function getNumeroPesqueros():Number
		{
			return(numeroPesqueros);
		}
		
	}

}