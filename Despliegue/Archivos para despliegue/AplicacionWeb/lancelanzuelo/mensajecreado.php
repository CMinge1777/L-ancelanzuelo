<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="supaCSS.css" />
<title>
Subasta creada
</title>
</head>
<body>
<div>
<img class="titulo" src="assets/LancelanzueloTitulo.png" />
<div class="contenido">
<?php
session_start();
// se crea la subasta y se redirige al php
$conexion = mysql_connect("jaibana.udea.edu.co:3306", $_SESSION["usernameffb"] ,$_SESSION["passwordffb"]);

if (!$conexion)
  {
  die('Could not connect: ' . mysql_error());
  echo "la conexion no sirve";
  }
else
{
//echo "la conexion sirve";
}
mysql_select_db("fishbanksDB", $conexion);
$consulta = "INSERT INTO MENSAJE VALUES (" . $_SESSION["TURNOM"] . ", ". $_SESSION["juegoseleccionado"] . $_POST["textomensaje"]  . ");";
mysql_query($consulta);
echo $consulta;
mysql_close($conexion);
$URL="menufb.php";
header ("Location: $URL");
?>
</div>
</div>
</body>
</html>