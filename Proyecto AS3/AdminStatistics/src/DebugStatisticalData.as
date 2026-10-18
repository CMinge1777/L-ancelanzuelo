package  
{
	/**
	 * ...
	 * @author juan felipe from ILLUSIONWARE
	 */
	public class DebugStatisticalData
	{
		
		public function DebugStatisticalData() 
		{
			
		}
		
		public function GetGeneralBalanceData(unDebugedData:Vector.<ReporteDTO>):Array
		{
			var dataArray:Array = new Array();
			var reportDTO:ReporteDTO;
			var mainCaption:String;
			var reporteAcumulado:Number;
			//var balanceMayor
			for (var i:uint = 0; i < unDebugedData.length; i++ )
			{
				reporteAcumulado = 0;
				reportDTO = unDebugedData[i];
				mainCaption = "Balance turno " + reportDTO.turno_id.toString() + ":"
				if(i > 0)
					reporteAcumulado = reportDTO.balance_general + int(dataArray[i - 1][3] as String);
				else
					reporteAcumulado = reportDTO.balance_general;
				dataArray.push([true, false, reportDTO.turno_id.toString(), reporteAcumulado.toString(), reportDTO.turno_id.toString(), reporteAcumulado.toString(), mainCaption]);
			}
			return (dataArray);
		}
		
		public function GetPoblacionData(unDebugedData:Vector.<PezDTO>):Array
		{
			var dataArray:Array = new Array();
			var poblacionDTO:PezDTO;
			var mainCaption:String;
			for (var i:uint = 0; i < unDebugedData.length; i++ )
			{
				poblacionDTO = unDebugedData[i];
				mainCaption = "Población turno " + poblacionDTO.turno_id.toString() + ":"
				dataArray.push([true, false, poblacionDTO.turno_id.toString(), poblacionDTO.poblacion.toString(), poblacionDTO.turno_id.toString(), poblacionDTO.poblacion.toString(), mainCaption]);
			}
			return (dataArray);
		}
		
		public function GetFishingReportData(unDebugedData:Vector.<ReporteDTO>):Array
		{
			var contador:uint = 0;
			var dataArray:Array = new Array();
			var reportDTO:ReporteDTO;
			var mainCaption:String;
			var contadorCaption:uint = 1;
			var captionAgregada:Boolean = false;
			for (var i:uint = 0; i < unDebugedData.length; i++ )
			{
				captionAgregada = false;
				reportDTO = unDebugedData[i];
				
				var capturaSierra:uint = reportDTO.captura_sierra_costa + reportDTO.captura_sierra_mar_proundo;
				var capturaPargo:uint  = reportDTO.captura_pargo_costa  + reportDTO.captura_pargo_mar_profundo;
				var capturaRobalo:uint = reportDTO.captura_robalo_costa + reportDTO.captura_robalo_mar_profundo;
				
				contador++;
				mainCaption = "Captura Sierra:"
				if (capturaSierra >= 0)
				{
					captionAgregada = true;
					dataArray.push([true,false, contadorCaption.toString(), "", contador.toString(), capturaSierra.toString(),mainCaption]);
				}
				
				contador++;
				mainCaption = "Captura Pargo:"
				if (capturaPargo >= 0)
				{
					if(captionAgregada)
						dataArray.push([false, false, "", "", contador.toString(), capturaPargo.toString(), mainCaption]);
					else
					{
						captionAgregada = true;
						dataArray.push([true, false, contadorCaption.toString(), "", contador.toString(), capturaPargo.toString(), mainCaption]);
					}
				}
				
				contador++;
				mainCaption = "Captura Robalo:"
				if (capturaRobalo >= 0)
				{
					if(captionAgregada)
						dataArray.push([false, false, "", "", contador.toString(), capturaRobalo.toString(), mainCaption]);
					else
					{
						captionAgregada = true;
						dataArray.push([true, false, contadorCaption.toString(), "", contador.toString(), capturaRobalo.toString(), mainCaption]);
					}
				}
				
				contadorCaption++;
				 
				if(i < unDebugedData.length - 1)
				{
					contador++;
					dataArray.push([false, false, "", "", contador.toString(), "0", ""]);
				}
				
			}
			return (dataArray);
		}
	}

}