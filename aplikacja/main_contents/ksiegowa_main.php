<?php

require_once 'db_connection.php'; 
		
$conn = openDatabase();

if ($conn)
{
    //echo "<p class=\"good\">Connected to Oracle!</p>";

    $stid = oci_parse($conn, 'SELECT * FROM W_ksiegowa');
    oci_execute($stid);

    $i = 0;
    echo "<table>\n";
    echo "<tr><td>Lp.</td>\n";
    echo "<td>Zysk NETTO</td>\n";
    echo "<td>ID_zamowienia</td>\n";
    echo "<td>Kod produktu</td>\n";
    echo "<td>Nazwa produktu</td>\n";
    echo "<td>Nazwa prodcenta</td>\n";
    echo "<td>Cena NETTO za szt.</td>\n";
    echo "<td>Ilość</td></tr>\n";
    while ($row = oci_fetch_array($stid, OCI_ASSOC+OCI_RETURN_NULLS)) {
        echo "<tr>\n";
            echo "<td>" . ++$i . "</td>\n";
        foreach ($row as $item) {
            echo "<td>" . ($item !== null ? htmlentities($item, ENT_QUOTES) : "&nbsp;") . "</td>\n";
        }
        echo "</tr>\n";
    }
    echo "</table>\n";
}
else
{
    exit;
}

oci_close($conn);