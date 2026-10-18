<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="supaCSS.css" />
<title>
</title>
</head>
<body>
<div>
<img class="titulo" src="assets/LancelanzueloTitulo.png" />
<div class="contenido">
<?php
session_start();
session_unset();
session_destroy();
$URL="floginb.php";
header ("Location: $URL");
?>
</div>
</div>
</body>
</html>