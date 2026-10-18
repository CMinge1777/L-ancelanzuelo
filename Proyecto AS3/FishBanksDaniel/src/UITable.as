package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.BevelFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Daniel Isaza Jiménez - from Illusionware
	 */
	public class UITable extends Sprite
	{
		
		private var columnas:int;
		private var filas:int;
		private var anchoColumnas:Array;
		private var altoFilas:int;
		private var nombreColumnas:Array;
		private var datosFilas:Array;
		private var mascara:Bitmap;
		private var borde:Sprite;
		
		public function UITable(nombreCol:Array,datos:Array,ancho:uint = 100,alto:uint = 100) {
			
			super ();
			
			var nokiafont:TextFormat = new TextFormat();
			nokiafont.font = "Maiandra GD";
			nokiafont.color = 0x0;
			nokiafont.size = 14;
			nokiafont.bold = true;
			
			this.anchoColumnas = new Array();
			this.nombreColumnas = nombreCol;
			this.datosFilas = datos;
			this.columnas = this.nombreColumnas.length;
			this.filas = this.datosFilas.length;
			this.mascara = new Bitmap(new BitmapData(ancho, alto, true, 0x000000));
			this.mask = this.mascara;
			this.addChild(this.mascara);
			
			var tfAux:TextField = new TextField();
			tfAux.defaultTextFormat = nokiafont;
			tfAux.antiAliasType = AntiAliasType.NORMAL;
			tfAux.autoSize = TextFieldAutoSize.LEFT;
			
			var anchoMayor:int = 0;
			/*for (var i:int = 0; i < this.columnas; i++) {
				tfAux.text = this.nombreColumnas[i];
				anchoMayor = tfAux.textWidth;
				this.altoFilas = tfAux.textHeight;
				for (var j:int = 0; j < this.filas; j++) {
					if (this.columnas > 1) {
						tfAux.text = this.datosFilas[j][i];
						anchoMayor = (anchoMayor > tfAux.textWidth)?anchoMayor:tfAux.textWidth;
					} else {
						tfAux.text = this.datosFilas[j];
						anchoMayor = (anchoMayor > tfAux.textWidth)?anchoMayor:tfAux.textWidth;
					}
				}
				anchoColumnas.push(anchoMayor);
			}*/
			for (var i:int = 0; i < this.columnas; i++) {
				tfAux.text = this.nombreColumnas[i];
				anchoMayor = (tfAux.text.length * 8);
				this.altoFilas = tfAux.textHeight;
				for (var j:int = 0; j < this.filas; j++) {
					if (this.columnas > 1) {
						tfAux.text = this.datosFilas[j][i];
						anchoMayor = (anchoMayor > (tfAux.text.length*8))?anchoMayor:tfAux.text.length*8;
					} else {
						tfAux.text = this.datosFilas[j];
						anchoMayor = (anchoMayor > (tfAux.text.length*8))?anchoMayor:tfAux.text.length*8;
					}
				}
				anchoColumnas.push(anchoMayor);
			}
			
			var spAux:Sprite;
			
			for (var ii:int = 0; ii < this.columnas; ii++) {
				for (var jj:int = 0; jj < this.filas + 1; jj++) {
					tfAux = new TextField();
					tfAux.defaultTextFormat = nokiafont;
					tfAux.antiAliasType = AntiAliasType.NORMAL;
					tfAux.autoSize = TextFieldAutoSize.LEFT;
					var properx:int = 0;
					for (var p:int = 0; p < ii; p++) {
						properx += this.anchoColumnas[p] /*+ 6*/;
					}
					tfAux.x = properx;
					tfAux.y = jj * (this.altoFilas + 6);
					if (jj == 0) {
						nokiafont.bold = true;
						tfAux.defaultTextFormat = nokiafont;
						//tfAux.filters = [new BevelFilter(2, 45, 0x000000, 0, 0x0000FF, .8)];
						tfAux.text = nombreColumnas[ii];
						//tfAux.border = true;
						tfAux.height = (filas + 1) * 22;
						tfAux.width = this.anchoColumnas[ii];
					} else {
						nokiafont.bold = false;
						tfAux.defaultTextFormat = nokiafont;
						if (this.columnas > 1) {
							tfAux.text = this.datosFilas[jj-1][ii];
						} else {
							tfAux.text = this.datosFilas[jj-1];
						}
					}
					tfAux.width = tfAux.textWidth + 6;
					tfAux.selectable = false;
					this.addChild(tfAux);
				}
			}
			
			ponerBordes();
		}
		
		private function ponerBordes():void {
			borde = new Sprite();
			var anchoT:int = 0;
			var altoT:int = 0;
			for each (var ancho:int in anchoColumnas) {
				anchoT += ancho;
			}
			altoT = (altoFilas + 6) * (filas + 1);
			borde.graphics.lineStyle(1);
			borde.graphics.moveTo(0, 0);
			borde.graphics.lineTo(0, altoT);
			borde.graphics.moveTo(0, 0);
			borde.graphics.lineTo(anchoT, 0);
			
			var acumAncho:int = 0;
			for (var i:int = 0; i < columnas; i++) {
				acumAncho += anchoColumnas[i];
				borde.graphics.moveTo(acumAncho, 0);
				borde.graphics.lineTo(acumAncho, altoT);
			}
			
			var acumAlto:int = 0;
			for (var j:int = 0; j < filas+1; j++) {
				acumAlto += altoFilas+6;
				borde.graphics.moveTo(0, acumAlto);
				borde.graphics.lineTo(anchoT, acumAlto);
			}
			//borde.graphics.beginFill(0, 1);
			//borde.graphics.drawRect(0, 0, 10, 10);
			addChild(borde);
		}
	}
}