<?php
session_start();
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="supaCSS.css" />
<title>
Menu admin Lance L'anzuelo
</title>
</head>
<body>
<div>
<img class="titulo" src="assets/LancelanzueloTitulo.png" />
<div class="contenido">
<?php
	//echo "Probando si existen los cosos del session";
	//echo strval($_SESSION["usernameffb"]);
	//echo strval($_SESSION["passwordffb"]);
	if(isset($_SESSION["usernameffb"]) && isset($_SESSION["passwordffb"]))
	{
		//echo "La sesion existia ";
	}
	else
	{
		//echo "La sesion no existia ";
		$user =  "santdelv_". $_POST["userlog"];
		$password = $_POST["passwordlog"];
		//echo strval($user);
		//echo "//";
		//echo "password: ";
		//echo strval($password);
		$conexion = mysql_connect("localhost", $user ,$_POST["passwordlog"]);
	
		if (!$conexion)
		{
			die('Could not connect: ' . mysql_error());
			echo "Usuario o contraseña incorrecta";
		}
		else
		{
			//echo "la conexion sirve";
			//session_start();
			$_SESSION["usernameffb"] = $user; 
			$_SESSION["passwordffb"] = $_POST["passwordlog"];
			mysql_close($conexion);
		}
	}
?>
<p>
<form action="crearjuego.php" method="link">
<input type="submit" name="botoncrearjuegosycomp" value="Crear juego"/>
</form>
</p>
<p>
<form action="verjuegos.php" method="post">
<input type="submit" name="botonverjuegos" value="Ver juegos"/>
</form>
</p>
<p>
<form action="../estadisticasAdmin/index.html" method="post" target="_blank">
<input type="submit" name="botonverestadisticas" value="Ver estadisticas"/>
</form>
</p>
<p>
<form action="logout.php" method="post">
<input type="submit" name="botoncrearjuegosycomp" value="Logout"/>
</form>
</p>
</div>
</div>
</body>
</html>