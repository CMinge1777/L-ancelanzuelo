<?php
session_start();
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>
Crear companias
</title>
<script language="JavaScript" src="gen_validatorv31.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="supaCSS.css" />
</head>
<body>
<div>
<img class="titulo" src="assets/LancelanzueloTitulo.png" />
<div class="contenido">
<?php
$_SESSION["descripcionjuego"] = $_POST["descripcionjuego"];
$_SESSION["duracionturnojuego"] = $_POST["duracionturnojuego"];
$_SESSION["fechainiciojuego"] = $_POST["diamesano"] . " " . $_POST["horajuego"] . ":" . $_POST["minutosjuego"] . ":00";
//$_SESSION["usernameffb"] = "superusuario"; 
//$_SESSION["passwordffb"] = "santiago";
// Creo la conexion
$conexion = mysql_connect("localhost", $_SESSION["usernameffb"] ,$_SESSION["passwordffb"]);
if (!$conexion)
  {
  die('Could not connect: ' . mysql_error());
  echo "la conexion no sirve";
  }
else
{
//echo "la conexion sirve";
}
// Crea un juego nuevo
$consulta = "INSERT INTO JUEGO VALUES (". "null, " . "'" .$_SESSION["descripcionjuego"]."'," . $_SESSION["duracionturnojuego"] . ", " . "CONVERT_TZ(STR_TO_DATE('" . $_SESSION["fechainiciojuego"] . "','%e-%c-%Y %k:%i:%s'),'-05:00','SYSTEM')" . ", false" .  " )" . ";";
mysql_select_db("santdelv_fishbanksDB", $conexion);
mysql_query($consulta,$conexion);
//echo $consulta;
// Obtengo el id del juego y lo guardo
//$consulta = "SELECT MAX (JUEGO_ID) FROM JUEGO";
$juegoxx = mysql_insert_id($conexion);
//$juegoxx = mysql_query($consulta, $conexion);
//echo "el juego prueba es";
//echo strval($juegoxx);
?>
<label class ="juego" ><b> Ha creado el juego
<?php
$_SESSION["juegoid"] = $juegoxx;
echo strval($juegoxx);
?>
</b></label>
<?php
//$consulta = "INSERT INTO TURNO VALUES( 0, " . $_SESSION["juegoid"] . ",'" . $_SESSION["fechainiciojuego"] ."' );" ;
//mysql_query($consulta,$conexion);
// Cierro la conexion
mysql_close($conexion);
if($_POST["numerocompanias"] == 2)
{
//echo "Son 2 compañias";
$_SESSION["numerocompanias"] = 2;
?>
<form action="companiascreadas.php" method="post" name="companiasform2">
<p><label>Nombre compañia 1:</label><input type="text" name="nombrecompania1" value="uno"/>
<label>Contraseña compañia 1:</label><input type="text" name="passwordcompania1" value="uno"/></p>
<br />
<p><label>Nombre compañia 2:</label><input type="text" name="nombrecompania2" value="dos"/>
<label>Contraseña compañia 2:</label><input type="text" name="passwordcompania2" value="dos"/></p>
<input type="submit" name="botoncrearjuegosycomp" value="Crear compañias"/>
</form>
<script language="JavaScript" type="text/javascript">
//You should create the validator only after the definition of the HTML form
  var frmvalidator  = new Validator("companiasform2"); 
 frmvalidator.addValidation("nombrecompania1","req","Asignele un nombre a la compañia 1");
 frmvalidator.addValidation("nombrecompania2","req","Asignele un nombre a la compañia 2");
 frmvalidator.addValidation("passwordcompania1","req","Asignele una contraseña a la compañia 1");
 frmvalidator.addValidation("passwordcompania2","req","Asignele una contraseña a la compañia 2");
</script>
<?php
}
elseif($_POST["numerocompanias"] == 3)
{
//echo "Son 3 compañias";
$_SESSION["numerocompanias"] = 3;
?>
<form action="companiascreadas.php" method="post" name="companiasform3">
<p><label>Nombre compañia 1:</label><input type="text" name="nombrecompania1" value="uno"/>
<label>Contraseña compañia 1:</label><input type="text" name="passwordcompania1" value="uno"/></p>
<p><label>Nombre compañia 2:</label><input type="text" name="nombrecompania2" value="dos"/>
<label>Contraseña compañia 2:</label><input type="text" name="passwordcompania2" value="dos"/></p>
<p><label>Nombre compañia 3:</label><input type="text" name="nombrecompania3" value="tres"/>
<label>Contraseña compañia 3:</label><input type="text" name="passwordcompania3" value="tres"/></p>
<input type="submit" name="botoncrearjuegosycomp" value="Crear compañias"/>
</form>
<script language="JavaScript" type="text/javascript">
//You should create the validator only after the definition of the HTML form
  var frmvalidator  = new Validator("companiasform3"); 
 frmvalidator.addValidation("nombrecompania1","req","Asignele un nombre a la compañia 1");
 frmvalidator.addValidation("nombrecompania2","req","Asignele un nombre a la compañia 2");
 frmvalidator.addValidation("nombrecompania3","req","Asignele un nombre a la compañia 3");
 frmvalidator.addValidation("passwordcompania1","req","Asignele una contraseña a la compañia 1");
 frmvalidator.addValidation("passwordcompania2","req","Asignele una contraseña a la compañia 2");
 frmvalidator.addValidation("passwordcompania3","req","Asignele una contraseña a la compañia 3");
</script>
<?php
}
elseif($_POST["numerocompanias"] == 4)
{
//echo "Guardar en el session el numero de compañias";
$_SESSION["numerocompanias"] = 4;
?>
<form action="companiascreadas.php" method="post" name="companiasform4">
<p><label>Nombre compañia 1:</label><input type="text" name="nombrecompania1" value="uno"/>
<label>Contraseña compañia 1:</label><input type="text" name="passwordcompania1" value="uno"/></p>
<p><label>Nombre compañia 2:</label><input type="text" name="nombrecompania2" value="dos"/>
<label>Contraseña compañia 2:</label><input type="text" name="passwordcompania2" value="dos"/></p>
<p><label>Nombre compañia 3:</label><input type="text" name="nombrecompania3" value="tres"/>
<label>Contraseña compañia 3:</label><input type="text" name="passwordcompania3" value="tres"/></p>
<p><label>Nombre compañia 4:</label><input type="text" name="nombrecompania4" value="cuatro"/>
<label>Contraseña compañia 4:</label><input type="text" name="passwordcompania4" value="cuatro"/></p>
<input type="submit" name="botoncrearjuegosycomp" value="Crear compañias"/>
</form>
<script language="JavaScript" type="text/javascript">
//You should create the validator only after the definition of the HTML form
  var frmvalidator  = new Validator("companiasform4"); 
 frmvalidator.addValidation("nombrecompania1","req","Asignele un nombre a la compañia 1");
 frmvalidator.addValidation("nombrecompania2","req","Asignele un nombre a la compañia 2");
 frmvalidator.addValidation("nombrecompania3","req","Asignele un nombre a la compañia 3");
 frmvalidator.addValidation("nombrecompania3","req","Asignele un nombre a la compañia 4");
 frmvalidator.addValidation("passwordcompania1","req","Asignele una contraseña a la compañia 1");
 frmvalidator.addValidation("passwordcompania2","req","Asignele una contraseña a la compañia 2");
 frmvalidator.addValidation("passwordcompania3","req","Asignele una contraseña a la compañia 3");
 frmvalidator.addValidation("passwordcompania3","req","Asignele una contraseña a la compañia 4");
</script>
<?php
}
?>
</div>
</div>
</body>
</html>