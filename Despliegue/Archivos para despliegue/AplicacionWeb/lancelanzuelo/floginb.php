<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="supaCSS.css" />
<title>
Login admin Lance L'anzuelo
</title>
<script language="JavaScript" src="gen_validatorv31.js" type="text/javascript"></script>
</head>
<body>
<div>
<img class="titulo" src="assets/LancelanzueloTitulo.png" />
<div class="contenido">
<form action="menufb.php" method="post" name="loginform" >
<p><label>Usuario:</label><input type="text" name="userlog" /></p>
<p><label>Contraseña:</label><input type="password" name="passwordlog" /></p>
<input type="submit" name="botonlogin" value="Login"/>
</form>
<script language="JavaScript" type="text/javascript">
//You should create the validator only after the definition of the HTML form
  var frmvalidator  = new Validator("loginform"); 
 frmvalidator.addValidation("userlog","req","Escriba su nombre de usuario por favor");
 frmvalidator.addValidation("passwordlog","req","Escriba su contraseña por favor");
</script>
</div>
</div>
</body>
</html>