<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="supaCSS.css" />
<title>
Informacion del juego
</title>
</head>
<body>
<div>
<img class="titulo" src="assets/LancelanzueloTitulo.png" />
<div class="contenido">
<?php
session_start();
$_SESSION["juegoseleccionado"] = $_POST["juegoseleccionado"];
$conexion = mysql_connect("jaibana.udea.edu.co:3306", $_SESSION["usernameffb"] ,$_SESSION["passwordffb"]);

if (!$conexion)
  {
  die('Could not connect: ' . mysql_error());
  echo "la conexion no sirve";
  }
else
{
//echo "la conexion sirve";
$consulta = "";
}
mysql_select_db("fishbanksDB", $conexion);
$consulta = "SELECT * FROM JUEGO WHERE JUEGO_ID = " . $_SESSION["juegoseleccionado"] . ";";
echo "<p>";
$result = mysql_query($consulta);
while($row = mysql_fetch_array($result))
  {
  echo "<p><label><b>Id del juego:</b></label>" .  $row['JUEGO_ID'];
  echo "</p>";
  echo "<p><label><b>Descripcion:</b></label>" . $row['DESCRIPCION'];
  echo "</p>";
  echo "<p><label><b>Duracion de cada turno:</b></label>" . $row['DURACION_TURNOS'] . " minutos";
  echo "</p>";
  echo "<p><label><b>Fecha de inicio:</b></label>" . $row['FECHA_INICIO'];
  echo "</p><p>";
  if($row ['FINALIZADO'] == 0)
  {
	echo "<label><b>finalizado:</b></label>NO";
  }
  else
  {
	echo "<label><b>finalizado:</b></label>SI";
  }
  
  }
  echo "</p></p>";

$consulta = "SELECT NOMBRE FROM COMPANIA WHERE JUEGO_ID = ". $_SESSION["juegoseleccionado"] . ";";
$result = mysql_query($consulta);
?>
<p>
<label><b>Compañias asociadas:</b></label>
<form action="companiaseleccionada.php" method="post">
<select name="companiaseleccionada">
<?php
while($row = mysql_fetch_array($result))
  {
  //echo $row['JUEGO_ID'];
  echo "<option value=" . $row['NOMBRE'] . ">" . $row['NOMBRE'];
  echo "<br />";
  }
mysql_close($conexion);
?>
</select>
<input type="submit" name="botonverjuegos" value="Ver esta compañia"/>
</form>
</p>
<p>
<form action="crearsubasta.php" method="post">
<input type="submit" name="botoncrearsubasta" value="Crear subasta"/>
</form>
<form action="crearmensaje.php" method="post">
<input type="submit" name="botoncrearmensaje" value="Crear mensaje"/>
</form>
</p>
<form action="menufb.php" method="post">
<input type="hidden" name="userlog" value= <?php $_SESSION["usernameffb"]?>/>
<input type="hidden" name="passwordlog" value= <?php $_SESSION["passwordffb"]?>/>
<input type="submit" name="botoncrearjuegosycomp" value="Volver al menu"/>
</form>
<form class="logout" action="logout.php" method="post">
<input type="submit" name="botoncrearlogout" value="Logout"/>
</form>
</div>
</div>
</body>
</html>