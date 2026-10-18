<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="supaCSS.css" />
<title>
</title>
</head>
<body>
<div>
<img class="titulo" src="assets/LancelanzueloTitulo.png" />
<div class="contenido">
<?php
// crear jugadores en la BD
session_start();
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
$consulta = "INSERT INTO USUARIO VALUES (" . $_POST["cedula"] . " , '" .  $_POST["nombre"] . "' , '" .  $_POST["programa"] . "' , '" .  $_POST["companiajugador"] . "' , " .  strval($_SESSION["juegoid"]) . " , '" .  $_POST["curso"] . "' , " .  $_POST["edad"] . ");";
//echo "La consulta es: ";
//echo $consulta;
mysql_select_db("fishbanksdb", $conexion);
mysql_query($consulta,$conexion);
mysql_close($conexion);

// Redireccionar a la forma de crear jugadores
?>
<p>
<form action="crearjugadores.php" method="post">
<input type="submit" name="botoncrearjuegosycomp" value="Crear mas jugadores"/>
</form>
</p>
<p>
<form action="menufb.php" method="post">
<input type="hidden" name="userlog" value= <?php $_SESSION["usernameffb"]?>/>
<input type="hidden" name="passwordlog" value= <?php $_SESSION["passwordffb"]?>/>
<input type="submit" name="botoncrearjuegosycomp" value="Volver al menu"/>
</form>
</p>
<p>
<form action="logout.php" method="post">
<input type="submit" name="botoncrearlogout" value="Logout"/>
</form>
</p>
</div>
</div>
</body>
</html>