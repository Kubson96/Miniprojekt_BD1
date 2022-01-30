<?php

require_once 'db_connection.php'; 
		
$conn = openDatabase();

if ($conn)
{
    $stid = oci_parse($conn, 'SELECT * FROM W_ksiegowa_produkty');
    oci_execute($stid);

    $i = 0;
    echo "<h3 class=\"left-align sub-title\">Produkty sprzedane w ciągu ostatniego miesiąca</h3>\n";
    echo "<table>\n";
    echo "<tr><td>Lp.</td>\n";
    echo "<td>Zysk NETTO</td>\n";
    echo "<td>ID zamówienia</td>\n";
    echo "<td>Kod produktu</td>\n";
    echo "<td>Nazwa produktu</td>\n";
    echo "<td>Nazwa producenta</td>\n";
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
    if ($i == 0)
    {
        echo "<p class=\"info\">Brak danych do wyświetlenia.</p>";
    }
    echo "</table>\n";

    $stid = oci_parse($conn, 'SELECT * FROM W_ksiegowa_uslugi');
    oci_execute($stid);

    $i = 0;
    echo "<h3 class=\"left-align sub-title\">Usługi z ostatniego miesiąca</h3>\n";
    echo "<table>\n";
    echo "<tr><td>Lp.</td>\n";
    echo "<td>Zysk NETTO</td>\n";
    echo "<td>ID usługi</td>\n";
    echo "<td>Nazwa usługi</td>\n";
    echo "<td>Cena NETTO usługi</td>\n";
    echo "<td>Ilość</td>\n";
    echo "<td>Pracownicy usługi</td>\n";
    while ($row = oci_fetch_array($stid, OCI_ASSOC+OCI_RETURN_NULLS)) {
        $idUslugi = -1;
        echo "<tr>\n";
            echo "<td>" . ++$i . "</td>\n";
        foreach ($row as $item => $value) {

            if ($item == 'ID_ZLECENIA_USLUGI')
            {
                $idUslugi = $value;
            }
            else
            {
                echo "<td>" . ($value !== null ? htmlentities($value, ENT_QUOTES) : "&nbsp;") . "</td>\n";
            }

        }

        echo "<td>\n";
        $stidSub = oci_parse($conn, 'SELECT imie, nazwisko, PESEL FROM W_ksiegowa_prac_us WHERE ID_Zlecenia_Uslugi = ' . $idUslugi);
        oci_execute($stidSub);

        while (($rowSub = oci_fetch_array($stidSub))) {
            echo "<p>\n";
            echo $rowSub['IMIE'] . ' ' . $rowSub['NAZWISKO'] . ' PESEL: ' . $rowSub['PESEL'];
            echo "</p>\n";
        }
        echo "</td>\n";
        oci_free_statement($stidSub);
        echo "</tr>\n";
    }
    if ($i == 0)
    {
        echo "<p class=\"info\">Brak danych do wyświetlenia.</p>";
    }
    echo "</table>\n";
}
else
{
    exit;
}

oci_close($conn);