<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="supaCSS.css" />
<title>
Ver juegos
</title>
</head>
<body>
<div>
<img class="titulo" src="assets/LancelanzueloTitulo.png" />
<div class="contenido">
<?php
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
mysql_select_db("fishbanksdb", $conexion);
$consulta = "SELECT JUEGO_ID FROM JUEGO;";
$result = mysql_query($consulta);
?>
<form action="juegoseleccionado.php" method="post">
<select name="juegoseleccionado">
<?php
while($row = mysql_fetch_array($result))
  {
  //echo $row['JUEGO_ID'];
  echo "<option value=" . $row['JUEGO_ID'] . ">" . $row['JUEGO_ID'] . "</option>";
  echo "<br />";
  }
mysql_close($conexion);
?>
</select>
</form>
<p>
<input type="submit" name="botonverjuegos" value="Ver este juego"/>
</p>
<p>
</form>
<form action="menufb.php" method="post">
<input type="hidden" name="userlog" value= <?php $_SESSION["usernameffb"]?>/>
<input type="hidden" name="passwordlog" value= <?php $_SESSION["passwordffb"]?>/>
<input type="submit" name="botoncrearjuegosycomp" value="Volver al menu"/>
</form>
<form action="logout.php" method="post">
<input type="submit" name="botoncrearlogout" value="Logout"/>
</form>
</p>
</div>
</div>
</body>
</html>