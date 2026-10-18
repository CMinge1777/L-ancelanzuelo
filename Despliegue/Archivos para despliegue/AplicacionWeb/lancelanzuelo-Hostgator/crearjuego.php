<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="supaCSS.css" />
<title>
Crear juego
</title>
<script language="JavaScript" src="gen_validatorv31.js" type="text/javascript"></script>
<script language="javascript" type="text/javascript" src="datetimepicker.js">

//Date Time Picker script- by TengYong Ng of http://www.rainforestnet.com
//Script featured on JavaScript Kit (http://www.javascriptkit.com)
//For this script, visit http://www.javascriptkit.com 

</script>
</head>
<body>
<div>
<img class="titulo" src="assets/LancelanzueloTitulo.png" />
<div class="contenido">
<p><label>Descripcion del juego</label></p>
<form action="crearcompanias.php" method="post" name="juegoform">
<textarea rows="5" cols="20" name="descripcionjuego"></textarea>
<p>
  <label>Duracion de cada turno:</label>
  <select name="duracionturnojuego">
  <option value=10>10 minutos</option>
  <option value=20>20 minutos</option>
  <option value=30>30 minutos</option>
  <option value=40>40 minutos</option>
  <option value=50>50 minutos</option>
  <option value=60>1 hora</option>
  <option value=120>2 horas</option>
  <option value=180>3 horas</option>
  <option value=240>4 horas</option>
  <option value=300>5 horas</option>
  <option value=1440>1 dia</option>
  <option value=2880>2 dias</option>
  <option value=4320>3 dias</option>
  <option value=5760>4 dias</option>
  <option value=7200>5 dias</option>
  <option value=8640>6 dias</option>
  <option value=10080>1 semana</option>
  <option value=20160>2 semanas</option>
  <option value=30240>3 semana</option>
  <option value=40320>1 mes</option>
  </select>
</p>
<p>
  <label>Fecha de inicio:</label>
  <input type="text" id="diamesano" name="diamesano" class="calendario" maxlength="25" size="25" >
  <a href="javascript:NewCal('diamesano','DDMMYYYY',false,24)">Escoger Fecha</a>
  <label>Hora:</label>
  <select name="horajuego">
  <option value=0>0</option>
  <option value=1>1</option>
  <option value=2>2</option>
  <option value=3>3</option>
  <option value=4>4</option>
  <option value=5>5</option>
  <option value=6>6</option>
  <option value=7>7</option>
  <option value=8>8</option>
  <option value=9>9</option>
  <option value=10>10</option>
  <option value=11>11</option>
  <option value=12>12</option>
  <option value=13>13</option>
  <option value=14>14</option>
  <option value=15>15</option>
  <option value=16>16</option>
  <option value=17>17</option>
  <option value=18>18</option>
  <option value=19>19</option>
  <option value=20>20</option>
  <option value=21>21</option>
  <option value=22>22</option>
  <option value=23>23</option>
  </select>
  :
  <select name="minutosjuego">
  <option value=00>00</option>
  <option value=10>10</option>
  <option value=20>20</option>
  <option value=30>30</option>
  <option value=40>40</option>
  <option value=50>50</option>
  </select>
  </p>
  <p>
  <label>Numero de compañias a crear:</label>
  <select name="numerocompanias">
  <option value=2>2</option>
  <option value=3>3</option>
  <option value=4>4</option>
  </select>
  </p>
<input type="submit" name="botoncrear" value="Crear juego"/>
</form>
<script language="JavaScript" type="text/javascript">
//You should create the validator only after the definition of the HTML form
  var frmvalidator  = new Validator("juegoform"); 
 frmvalidator.addValidation("descripcionjuego","req","Escriba una descripcion para el juego por favor");
</script>
</div>
</div>
</body>
</html>