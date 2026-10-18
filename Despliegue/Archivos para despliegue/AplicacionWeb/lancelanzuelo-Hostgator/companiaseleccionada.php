<?php
session_start();
?>
<html>
<head>
<link rel="stylesheet" type="text/css" href="supaCSS.css" />
<title>
Informacion de la compañia
</title>
</head>
<body>
<div>
<img class="titulo" src="assets/LancelanzueloTitulo.png" />
<div class="contenido">
<?php
echo $_SESSION["juegoseleccionado"];
$conexion = mysql_connect("localhost", $_SESSION["usernameffb"] ,$_SESSION["passwordffb"]);

$selectedgame = $_SESSION["juegoseleccionado"];

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
mysql_select_db("santdelv_fishbanksDB", $conexion);
$consulta = "SELECT * FROM COMPANIA WHERE JUEGO_ID =". $_SESSION["juegoseleccionado"] . " AND NOMBRE = '" . $_SESSION["companiaseleccionada"] . "';";
echo "<p>";
$result = mysql_query($consulta);
while($row = mysql_fetch_array($result))
  {
  echo "<label>Nombre:</label> " .  $row['NOMBRE'];
  //echo "<br>";
  echo "<label>Contraseña:</label> " . $row['PASSWORD'];
  //echo "<br>";
  echo "<label>Ubicacion terrestre:</label> ";
if ($row['UBICACION_TERRESTRE'] == 1) 
         echo "Necocli";
else if ($row['UBICACION_TERRESTRE'] == 2) 
        echo "Turbo";
else if ($row['UBICACION_TERRESTRE'] == 3) 
        echo "Bocas del atrato";
else if ($row['UBICACION_TERRESTRE'] == 4) 
        echo "Acandi";

  echo "</p>";
  }

echo "<p><b>Juadores asociados a la compañia:</b> </p>";
$consulta = " SELECT * FROM USUARIO WHERE COMPANIA_NOMBRE = '" . $_SESSION["companiaseleccionada"] . "' AND JUEGO_ID = " . $_SESSION["juegoseleccionado"] . ";" ;
$result = mysql_query($consulta);
while($row = mysql_fetch_array($result))
  {
  echo "<p>";
  echo "<label>Nombre:</label>" .  $row['NOMBRE'];
  //echo "<br>";
  echo "<label>Cedula:</label>" . $row['CEDULA'];
  //echo "<br>";
  echo "<label>Programa:</label>" . $row['PROGRAMA'];
  //echo "<br>";
  echo "<label>Curso:</label>" . $row['CURSO'];
  //echo "<br>";
  echo "<label>Edad:</label>" . $row['EDAD'];
  echo "</p>";
  }
mysql_close($conexion);
?>
<br />

<form action="juegoseleccionado.php" method="post">
<input type="hidden" name="juegoseleccionado" value= <?php echo $selectedgame?>>
<input type="submit" name="botonverjuegos" value="Volver al juego seleccionado"/>
</form>

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