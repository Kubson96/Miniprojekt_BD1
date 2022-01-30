<!DOCTYPE html>
<html lang="pl">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Firma przewozowa</title>
</head>
<body>
<center>

<b>Dane osobowe:</b>
<?php
$conn = oci_connect("pawel", "password", "//localhost/orclpdb", "AL32UTF8");
if (!$conn) {
  $m = oci_error();
  echo $m['message'], "\n";
  exit;
}
else{
$stid = oci_parse($conn, 'select id_osoby, Imie, Nazwisko, telefon from osoba');
oci_execute($stid);
echo "<table border='1'>";
echo "<tr><th>" . "Dane_id" . "</th><th>" . "Imie" . "</th><th>" . "Nazwisko" . "</th><th>" . "Telefon" . "</th><th>" . "Email" . "</th></tr>";
while(($row = oci_fetch_array($stid, OCI_BOTH))!=false){

//var_dump($row);

echo "<tr><td>" . $row['ID_OSOBY'] . "</td><td>" . $row['IMIE'] . "</td><td>" . $row['NAZWISKO'] . 
"</td><td> " . (!empty($row['TELEFON']) ? htmlentities($row['TELEFON'], ENT_QUOTES) : "&nbsp;") . "</td></tr>";
}
echo "</table>";
}
oci_close($conn);
?>
<br>
</center>
</body>
</html>