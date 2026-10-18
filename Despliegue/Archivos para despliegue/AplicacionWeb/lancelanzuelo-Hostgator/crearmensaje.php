<?php
session_start();
?>
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
$conexion = mysql_connect("localhost", $_SESSION["usernameffb"] ,$_SESSION["passwordffb"]);

if (!$conexion)
  {
  die('Could not connect: ' . mysql_error());
  //echo "la conexion no sirve";
  }
else
{
//echo "la conexion sirve";
}
mysql_select_db("santdelv_fishbanksDB", $conexion);

$consulta = "SELECT MAX(TURNO_ID) as TURNOM FROM TURNO WHERE JUEGO_ID = " . $_SESSION["juegoseleccionado"] . ";" ;
$result = mysql_query($consulta);
$row = mysql_fetch_array($result);
echo "EL mensaje se creara para el turno " . $row['TURNOM'];
$_SESSION["TURNOM"] = $row['TURNOM'];
// verificar si ya existe la subasta
$consulta = "SELECT * FROM MENSAJE WHERE TURNO_ID = " . $_SESSION["TURNOM"] . " AND JUEGO_ID = " . $_SESSION["juegoseleccionado"] . ";";
$result = mysql_query($consulta);
echo "<br>";
$num=mysql_num_rows($result);

if ($num == 0)
{
?>
<form action="mensajecreado.php" method="post" name="subastaform">
<p><label>Mensaje:</label><textarea rows="5" cols="20" name="textomensaje"></textarea></p>
<input type="submit" name="botonmensaje" value="Crear"/>
</form>
<script language="JavaScript" type="text/javascript">
//You should create the validator only after the definition of the HTML form
  var frmvalidator  = new Validator("subastaform"); 
 frmvalidator.addValidation("textomensaje","req","Llene el mensaje motivacional");
</script>
<?php
}
else
{
echo "Ya existe un mensaje para este turno";
$row = mysql_fetch_array($result);
?>
<p>
<label><b>Mensaje:</b></label><?php echo($row["TEXTO"]); ?>
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