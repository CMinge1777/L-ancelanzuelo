<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="supaCSS.css" />
<title>
Compañias creadas
</title>
</head>
<body>
<div>
<img class="titulo" src="assets/LancelanzueloTitulo.png" />
<div class="contenido">
<?php
session_start();
echo "Se quieren crear " . strval($_SESSION["numerocompanias"]) . " compañias";
$conexion = mysql_connect("jaibana.udea.edu.co:3306", $_SESSION["usernameffb"] ,$_SESSION["passwordffb"]);

if (!$conexion)
  {
  die('Could not connect: ' . mysql_error());
  echo "la conexion no sirve";
  }
else
{
echo "la conexion sirve";
$consulta = "";
}
if($_SESSION["numerocompanias"] == 2)
{
$consulta = "INSERT INTO COMPANIA VALUES ('" . $_POST["nombrecompania1"] . "' , '" .  $_POST["passwordcompania1"] . "' , '" . strval($_SESSION["juegoid"]) . "' , 1);";
mysql_select_db("fishbanksdb", $conexion);
mysql_query($consulta,$conexion);
$consulta = "INSERT INTO COMPANIA VALUES ('" . $_POST["nombrecompania2"] . "' , '" .  $_POST["passwordcompania2"] . "' , '" . strval($_SESSION["juegoid"]) . "' , 2);";
mysql_query($consulta,$conexion);
$consulta = "INSERT INTO TURNO VALUES( 0, " . $_SESSION["juegoid"] . ",'" . $_SESSION["fechainiciojuego"] ."' );" ;
mysql_query($consulta,$conexion);
mysql_close($conexion);
$_SESSION["nombrecompania1"] = $_POST["nombrecompania1"];
$_SESSION["passwordcompania1"] = $_POST["passwordcompania1"];
$_SESSION["nombrecompania2"] = $_POST["nombrecompania2"];
$_SESSION["passwordcompania2"] = $_POST["passwordcompania2"];
}
elseif ($_SESSION["numerocompanias"] == 3)
{
$consulta = "INSERT INTO COMPANIA VALUES ('" . $_POST["nombrecompania1"] . "' , '" .  $_POST["passwordcompania1"] . "' , '" . strval($_SESSION["juegoid"]) . "' , 1);";
mysql_select_db("fishbanksdb", $conexion);
mysql_query($consulta,$conexion);
$consulta = "INSERT INTO COMPANIA VALUES ('" . $_POST["nombrecompania2"] . "' , '" .  $_POST["passwordcompania2"] . "' , '" . strval($_SESSION["juegoid"]) . "' , 2);";
mysql_query($consulta,$conexion);
$consulta = "INSERT INTO COMPANIA VALUES ('" . $_POST["nombrecompania3"] . "' , '" .  $_POST["passwordcompania3"] . "' , '" . strval($_SESSION["juegoid"]) . "' , 3);";
mysql_query($consulta,$conexion);
$consulta = "INSERT INTO TURNO VALUES( 0, " . $_SESSION["juegoid"] . ",'" . $_SESSION["fechainiciojuego"] ."' );" ;
mysql_query($consulta,$conexion);
$_SESSION["nombrecompania1"] = $_POST["nombrecompania1"];
$_SESSION["passwordcompania1"] = $_POST["passwordcompania1"];
$_SESSION["nombrecompania2"] = $_POST["nombrecompania2"];
$_SESSION["passwordcompania2"] = $_POST["passwordcompania2"];
$_SESSION["nombrecompania3"] = $_POST["nombrecompania3"];
$_SESSION["passwordcompania3"] = $_POST["passwordcompania3"];
}
elseif ($_SESSION["numerocompanias"] == 4)
{
$consulta = "INSERT INTO COMPANIA VALUES ('" . $_POST["nombrecompania1"] . "' , '" .  $_POST["passwordcompania1"] . "' , '" . strval($_SESSION["juegoid"]) . "' , 1);";
mysql_select_db("fishbanksdb", $conexion);
mysql_query($consulta,$conexion);
$consulta = "INSERT INTO COMPANIA VALUES ('" . $_POST["nombrecompania2"] . "' , '" .  $_POST["passwordcompania2"] . "' , '" . strval($_SESSION["juegoid"]) . "' , 2);";
mysql_query($consulta,$conexion);
$consulta = "INSERT INTO COMPANIA VALUES ('" . $_POST["nombrecompania3"] . "' , '" .  $_POST["passwordcompania3"] . "' , '" . strval($_SESSION["juegoid"]) . "' , 3);";
mysql_query($consulta,$conexion);
$consulta = "INSERT INTO COMPANIA VALUES ('" . $_POST["nombrecompania4"] . "' , '" .  $_POST["passwordcompania4"] . "' , '" . strval($_SESSION["juegoid"]) . "' , 4);";
mysql_query($consulta,$conexion);
$consulta = "INSERT INTO TURNO VALUES( 0, " . $_SESSION["juegoid"] . ",'" . $_SESSION["fechainiciojuego"] ."' );" ;
mysql_query($consulta,$conexion);
mysql_close($conexion);
$_SESSION["nombrecompania1"] = $_POST["nombrecompania1"];
$_SESSION["passwordcompania1"] = $_POST["passwordcompania1"];
$_SESSION["nombrecompania2"] = $_POST["nombrecompania2"];
$_SESSION["passwordcompania2"] = $_POST["passwordcompania2"];
$_SESSION["nombrecompania3"] = $_POST["nombrecompania3"];
$_SESSION["passwordcompania3"] = $_POST["passwordcompania3"];
$_SESSION["nombrecompania4"] = $_POST["nombrecompania4"];
$_SESSION["passwordcompania4"] = $_POST["passwordcompania4"];
}

echo "Compañias creadas";
$_SESSION["consulta"] = 
$URL="crearjugadores.php";
header ("Location: $URL");
?>
<!--
<form action="menufb.php" method="post">
<input type="hidden" name="userlog" value= <?php $_SESSION["usernameffb"]?>/>
<input type="hidden" name="passwordlog" value= <?php $_SESSION["passwordffb"]?>/>
<input type="submit" name="botoncrearjuegosycomp" value="Volver al menu"/>
</form>

<br>
<form action="crearjugadores.php" method="post">
<input type="submit" name="botoncrearjuegosycomp" value="Crear jugadores"/>
</form>
-->
</div>
</div>
</body>
</html>