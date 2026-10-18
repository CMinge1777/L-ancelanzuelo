<?php 
//some script for function date test
$curdate = date('Y-m-d H:i:s', strtotime("+1 minutes"));
echo($curdate . " date p 1m");
?>
<br />
<?php
$curdate2 = date('Y-m-d H:i:s');
echo($curdate2 . " date");
?>
<br />
<?php
if ($curdate2 > curdate) {
echo("mayor 2 q nada, y esto es mierda");
} else {
echo("mayor nada q 2");
}
?>