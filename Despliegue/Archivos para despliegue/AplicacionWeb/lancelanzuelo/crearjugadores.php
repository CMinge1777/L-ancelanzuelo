<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="supaCSS.css" />
<title>
Crear jugadores
</title>
<script language="JavaScript" src="gen_validatorv31.js" type="text/javascript"></script>
</head>
<body>
<div>
<img class="titulo" src="assets/LancelanzueloTitulo.png" />
<div class="contenido">
<?php
session_start();
?>
<form action="jugadorescreados.php" method="post" name="jugadorform">
<p><label>Cedula:</label><input type="text" name="cedula" /></p>
<p><label>Nombre:</label><input type="text" name="nombre" /></p>
<p><label>Programa:</label><input type="text" name="programa" /></p>
<!-- Aqui va un select que se llena con segun el numero de companias y con los nombres de estas guardados en la sesion !-->
<?php
if($_SESSION["numerocompanias"] == 2)
{
?>
<p><label>Compañia:</label><select name="companiajugador">
  <option value=<?php echo($_SESSION["nombrecompania1"]); ?>><?php echo ($_SESSION["nombrecompania1"]); ?></option>
  <option value=<?php echo ($_SESSION["nombrecompania2"]); ?>><?php echo ($_SESSION["nombrecompania2"]); ?></option>
  </select>
<?php
}
elseif($_SESSION["numerocompanias"] == 3)
{
?>
<label>Compañia:</label><select name="companiajugador">
  <option value=<?php echo ($_SESSION["nombrecompania1"]); ?>><?php echo ($_SESSION["nombrecompania1"]); ?></option>
  <option value=<?php echo ($_SESSION["nombrecompania2"]); ?>><?php echo ($_SESSION["nombrecompania2"]); ?></option>
  <option value=<?php echo ($_SESSION["nombrecompania3"]); ?>><?php echo ($_SESSION["nombrecompania3"]); ?></option>
  </select>
<?php
}
elseif($_SESSION["numerocompanias"] == 4)
{
?>
<label>Compañia:</label><select name="companiajugador">
  <option value=<?php echo($_SESSION["nombrecompania1"]); ?>><?php echo($_SESSION["nombrecompania1"]); ?></option>
  <option value=<?php echo($_SESSION["nombrecompania2"]); ?>><?php echo ($_SESSION["nombrecompania2"]); ?></option>
  <option value=<?php echo ($_SESSION["nombrecompania3"]); ?>><?php echo ($_SESSION["nombrecompania3"]); ?></option>
  <option value=<?php echo ($_SESSION["nombrecompania4"]); ?>><?php echo ($_SESSION["nombrecompania4"]); ?></option>
  </select></p>
<?php
}
?>
<p><label>Curso:</label><input type="text" name="curso" /></p>
<p><label>edad:</label><input type="text" name="edad" /></p>
<input type="hidden" name="passwordlog" value= <?php $_SESSION["passwordffb"]?>/>
<input type="submit" name="botoncrearjuegosycomp" value="Crear jugador"/>
</form>
<script language="JavaScript" type="text/javascript">
//You should create the validator only after the definition of the HTML form
  var frmvalidator  = new Validator("jugadorform"); 
 frmvalidator.addValidation("cedula","req","Escriba la cedula del estudiante");
 frmvalidator.addValidation("nombre","req","Asignele un nombre al estudiante");
 frmvalidator.addValidation("programa","req","Escriba el programa al cual pertenece el estudiante");
 frmvalidator.addValidation("curso","req","Escriba el curso que esta viendo el estudiante");
 frmvalidator.addValidation("edad","req","Escriba la edad del estudiante");
 frmvalidator.addValidation("cedula","numeric", "Solo escriba numeros en la cedula");
 frmvalidator.addValidation("edad","numeric", "Solo esriba numeros en la edad");
 frmvalidator.addValidation("cedula","maxlen=11", "El maximo de caracteres para este campo es de 11");
 frmvalidator.addValidation("edad","maxlen=3", "El maximo de caracteres para este campo es de 3");
</script>
<form action="menufb.php" method="post">
<input type="hidden" name="userlog" value= <?php $_SESSION["usernameffb"]?>/>
<input type="hidden" name="passwordlog" value= <?php $_SESSION["passwordffb"]?>/>
<input type="submit" name="botoncrearjuegosycomp" value="Volver al menu"/>
</form>
<br>
<form class="logout" action="logout.php" method="post">
<input type="hidden" name="userlog" value= <?php $_SESSION["usernameffb"]?>/>
<input type="hidden" name="passwordlog" value= <?php $_SESSION["passwordffb"]?>/>
<input type="submit" name="botoncrearjuegosycomp" value="Logout"/>
</form>
</div>
</div>
</body>
</html>