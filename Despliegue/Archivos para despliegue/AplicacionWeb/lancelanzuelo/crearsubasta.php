<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="supaCSS.css" />
<title>
Crear subasta
</title>
<script language="JavaScript" src="gen_validatorv31.js" type="text/javascript"></script>
</head>
<body>
<div>
<img class="titulo" src="assets/LancelanzueloTitulo.png" />
<div class="contenido">
<?php
session_start();
$conexion = mysql_connect("jaibana.udea.edu.co:3306", $_SESSION["usernameffb"] ,$_SESSION["passwordlog"]);

if (!$conexion)
  {
  die('Could not connect: ' . mysql_error());
  echo "la conexion no sirve";
  }
else
{
//echo "la conexion sirve";
}
mysql_select_db("fishbanksdb", $conexion);

$consulta = "SELECT MAX(TURNO_ID) as TURNOM FROM TURNO WHERE JUEGO_ID = " . $_SESSION["juegoseleccionado"] . ";" ;
$result = mysql_query($consulta);
$row = mysql_fetch_array($result);
echo "La subasta se creara para el turno " . $row['TURNOM'];
$_SESSION["TURNOM"] = $row['TURNOM'];
// verificar si ya existe la subasta
$consulta = "SELECT * FROM SUBASTA WHERE TURNO_ID = " . $_SESSION["TURNOM"] . " AND JUEGO_ID = " . $_SESSION["juegoseleccionado"] . ";";
$result = mysql_query($consulta);
echo "<br>";
$num=mysql_num_rows($result);

if ($num == 0)
{
?>
<form action="subastacreada.php" method="post" name="subastaform">
<p><label>Costo:</label><input type="text" name="costo" /></p>
<p><label>Numero de chalupas:</label><input type="text" name="nchalupas" /></p>
<p><label>Numero de lanchas:</label><input type="text" name="npangas" /></p>
<p><label>Numero de barcos pesqueros:</label><input type="text" name="npesqueros" /></p>
<input type="submit" name="botoncrearsubasta" value="Crear"/>
</form>
<script language="JavaScript" type="text/javascript">
//You should create the validator only after the definition of the HTML form
  var frmvalidator  = new Validator("subastaform"); 
 frmvalidator.addValidation("costo","req","Asignele un costo a la subasta");
 frmvalidator.addValidation("nchalupas","req","Asignele un numero de chalupas, si no quiere asignar escriba '0'");
 frmvalidator.addValidation("npangas","req","Asignele un numero de lanchas, si no quiere asignar escriba '0'");
 frmvalidator.addValidation("npesqueros","req","Asignele un numero de pesqueros, si no quiere asignar escriba '0'");
 frmvalidator.addValidation("costo","numeric", "Solo esriba numeros en el costo de la subasta");
 frmvalidator.addValidation("nchalupas","numeric", "Solo esriba numeros en numero de chalupas");
 frmvalidator.addValidation("npangas","numeric", "Solo esriba numeros en numero de lanchas");
 frmvalidator.addValidation("npesqueros","numeric", "Solo esriba numeros en numero de barcos pesqueros");
</script>
<?php
}
else
{
echo "Ya existe una subasta para este turno";
$row = mysql_fetch_array($result);
?>
<p>
<label><b>Costo:</b></label><?php echo($row["COSTO"]); ?>
<label><b>Numero de chalupas:</b></label><?php echo($row["NUMERO_CHALUPAS"]); ?>
<label><b>Numero de lanchas:</b></label><?php echo($row['NUMERO_PANGAS']); ?>
<label><b>Numero de barcos pesqueros:</b></label><?php echo($row["NUMERO_BARCO_PESQUERO"]); ?>
</p>
<form action="menufb.php" method="post">
<input type="hidden" name="userlog" value= <?php $_SESSION["usernameffb"]?>/>
<input type="hidden" name="passwordlog" value= <?php $_SESSION["passwordffb"]?>/>
<input type="submit" name="botoncrearjuegosycomp" value="Volver al menu"/>
</form>
<?php
}
mysql_close($conexion);
?>
</div>
</div>
</body>
</html>