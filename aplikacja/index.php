<!DOCTYPE html>
<html lang="pl">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sklep meblowy - miniprojekt BD1</title>
</head>
<body>
<?php

require_once('conn_configuration.php');

$conn = oci_connect(DB_USERNAME, DB_PASSWORD, DB_CONNECTION_STRING, DB_ENCODING);
if (!$conn) {
  $m = oci_error();
  echo $m['message'], "\n";
  exit;
}
else {
  print "Connected to Oracle!";

  $stid = oci_parse($conn, 'SELECT TABLE_NAME FROM user_tables');
  oci_execute($stid);
   
  echo "<table border='1'>\n";
  echo "<tr><td>Nazwy tabel użytkownika</td></tr>\n";
  while ($row = oci_fetch_array($stid, OCI_ASSOC+OCI_RETURN_NULLS)) {
    echo "<tr>\n";
    foreach ($row as $item) {
      echo "    <td>" . ($item !== null ? htmlentities($item, ENT_QUOTES) : "&nbsp;") . "</td>\n";
    }
    echo "</tr>\n";
   }
  echo "</table>\n";

}

oci_close($conn);
?>
</body>
</html>