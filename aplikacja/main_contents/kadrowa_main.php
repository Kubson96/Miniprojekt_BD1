<?php

require_once 'db_connection.php'; 
		
$conn = openDatabase();

if ($conn)
{
    $stid = oci_parse($conn, 'SELECT * FROM W_kadrowa');
    oci_execute($stid);

    $i = 0;
    echo "<h3 class=\"left-align sub-title\">Produkty sprzedane w ciągu ostatniego miesiąca</h3>\n";
    echo "<table>\n";
    echo "<tr><td>Lp.</td>\n";
    echo "<td>Imię</td>\n";
    echo "<td>Nazwisko</td>\n";
    echo "<td>PESEL</td>\n";
    echo "<td>Nr telefonu</td>\n";
    echo "<td>Email</td>\n";
    echo "<td>Płeć</td>\n";
    echo "<td>Pensja</td>\n";
    echo "<td>Data zatrudnienia</td>\n";
    echo "<td>Stan zdrowia</td>\n";
    echo "<td>Data badania okresowego</td>\n";
    echo "<td>Szczepiony</td>\n";
    echo "<td>Zysk NETTO</td>\n";
    echo "<td>Bilans dla firmy</td></tr>\n";
    while ($row = oci_fetch_array($stid, OCI_ASSOC+OCI_RETURN_NULLS)) {
        echo "<tr>\n";
            echo "<td>" . ++$i . "</td>\n";
        foreach ($row as $item => $value) {

            if ($item == 'SZCZEPIONY')
            {
                if ($value == '1')
                {
                    echo "<td>TAK</td>\n";
                }
                else if ($value == '0')
                {
                    echo "<td>NIE</td>\n";
                }
            }
            else
            {
                echo "<td>" . ($value !== null ? htmlentities($value, ENT_QUOTES) : "&nbsp;") . "</td>\n";
            }
        }
        echo "</tr>\n";
    }
    if ($i == 0)
    {
        echo "<p class=\"info\">Brak danych do wyświetlenia.</p>";
    }
    echo "</table>\n";

    $stid = oci_parse($conn, 'SELECT * FROM W_kadrowa_wszyscy_prac');
    oci_execute($stid);

    $i = 0;
    echo "<h3 class=\"left-align sub-title\">Adresy pracowników</h3>\n";
    echo "<table>\n";
    echo "<tr><td>Lp.</td>\n";
    echo "<td>Imię</td>\n";
    echo "<td>Nazwisko</td>\n";
    echo "<td>PESEL</td>\n";
    echo "<td>Nr telefonu</td>\n";
    echo "<td>Email</td>\n";
    echo "<td>Płeć</td>\n";
    echo "<td>Pensja</td>\n";
    echo "<td>Data zatrudnienia</td>\n";
    echo "<td>Stan zdrowia</td>\n";
    echo "<td>Data badania okresowego</td>\n";
    echo "<td>Szczepiony</td>\n";
    echo "<td>Uwagi</td>\n";
    echo "<td>Adres zamieszkania</td>\n";
 
    while ($row = oci_fetch_array($stid, OCI_ASSOC+OCI_RETURN_NULLS)) {
        echo "<tr>\n";
            echo "<td>" . ++$i . "</td>\n";
        foreach ($row as $item => $value) {

            if ($item == 'SZCZEPIONY')
            {
                if ($value == '1')
                {
                    echo "<td>TAK</td>\n";
                }
                else if ($value == '0')
                {
                    echo "<td>NIE</td>\n";
                }
            }
            else if ($item == 'ULICA' || $item == 'NR_BUDYNKU' || $item == 'NR_MIESZKANIA' || $item == 'MIASTO')
            { }
            else if ($item == 'UWAGI')
            {
                if (empty($value) == false)
                {
                    echo "<td>" . ($value !== null ? htmlentities($value, ENT_QUOTES) : "&nbsp;") . "</td>\n";
                }
                else
                {
                    echo "<td>Brak</td>\n";
                }
            }
            else
            {
                echo "<td>" . ($value !== null ? htmlentities($value, ENT_QUOTES) : "&nbsp;") . "</td>\n";
            }

        }

        echo "<td>\n";
        $adresString = $row['ULICA'] . ', ' . $row['NR_BUDYNKU'] . '/ ' . $row['NR_MIESZKANIA'] . "</br>\n";
        $adresString .= $row['MIASTO'] . "</br>\n";
        echo $adresString;
        echo "</td>\n";
        echo "</tr>\n";
    }
    if ($i == 0)
    {
        echo "<p class=\"info\">Brak danych do wyświetlenia.</p>";
    }
    echo "</table>\n";

    $stid = oci_parse($conn, 'SELECT * FROM W_kadrowa_hierarchia_prac');
    oci_execute($stid);

    $i = 0;
    echo "<h3 class=\"left-align sub-title\">Hierarchia stanowisk pracy w firmie</h3>\n";
    echo "<table>\n";
    echo "<tr><td>Lp.</td>\n";
    echo "<td>Imię</td>\n";
    echo "<td>Nazwisko</td>\n";
    echo "<td>PESEL</td>\n";
    echo "<td>Stanowiska</td>\n";
    echo "<td>Przełożony</td>\n";
 
    while ($row = oci_fetch_array($stid, OCI_ASSOC+OCI_RETURN_NULLS)) {
        $idPracownika = -1;
        $idPrzelozonego = -1;
        echo "<tr>\n";
            echo "<td>" . ++$i . "</td>\n";
        foreach ($row as $item => $value) {

            if ($item == 'ID_PRACOWNIKA')
            {
                $idPracownika = $value;
            }
            else if ($item == 'ID_PRZELOZONEGO')
            {
                $idPrzelozonego = $value;
            }
            else
            {
                echo "<td>" . ($value !== null ? htmlentities($value, ENT_QUOTES) : "&nbsp;") . "</td>\n";
            }

        }

        echo "<td>\n";
        $stidSub = oci_parse($conn, 'SELECT * FROM W_kadrowa_stanowiska_prac WHERE ID_Pracownika = ' . $idPracownika);
        oci_execute($stidSub);

        while (($rowSub = oci_fetch_array($stidSub))) {
            echo "<p>" . $rowSub['NAZWA'] . ' : ' . $rowSub['OBOWIAZKI'] . "</p>\n";
        }
        oci_free_statement($stidSub);
        echo "</td>\n";

        echo "<td>\n";
        $stidSub = oci_parse($conn, 'SELECT imie, nazwisko, PESEL FROM Osoby WHERE ID_Osoby = ' . $idPrzelozonego);
        oci_execute($stidSub);

        while (($rowSub = oci_fetch_array($stidSub))) {
            if ($row['PESEL'] != $rowSub['PESEL'])
            {
                echo "<p>" . $rowSub['IMIE'] . ' : ' . $rowSub['NAZWISKO'] . ', PESEL: ' . $rowSub['PESEL'] . "</p>\n";
            }
            else
            {
                echo "<p>brak przełożonego</p>";
            }
        }
        oci_free_statement($stidSub);
        echo "</td>\n";
        echo "</tr>\n";
    }
    if ($i == 0)
    {
        echo "<p class=\"info\">Brak danych do wyświetlenia.</p>";
    }
    echo "</table>\n";

    echo "<h3 class=\"left-align sub-title\">Dodawanie nowego pracownika</h3>\n";
    ?>
    <form id="new_worker_form" action="main.php">
        <label>Imię: <input type="text" name="name"></label></br>
        <label>Nazwisko: <input type="text" name="surname"></label></br>
        <label>Data ur: <input type="date" name="born"></label></br>
        <label>PESEL: <input type="number" name="PESEL"></label></br>
        <label>Nr telefonu: <input type="text" name="tel"></label></br>
        <label>Email: <input type="text" name="mail"></label></br>
        <label>Płeć:</label></br>
        <input type="radio" id="K" name="sex" value="K">
        <label for="K">kobieta</label><br>
        <input type="radio" id="M" name="sex" value="M">
        <label for="M">mężczyzna</label><br>
        <label>Miasto: <input type="text" name="city"></label></br>
        <label>Ulica: <input type="text" name="street"></label></br>
        <label>Nr budynku: <input type="text" name="home_num"></label></br>
        <label>Nr mieszkania: <input type="text" name="apartment_num"></label></br>
        <label>Pensja: <input type="number" name="salary"></label></br>
        <label>Stan zdrowia: <input type="text" name="health"></label></br>
        <label>Data badania okresowego: <input type="date" name="test_date"></label></br>
        <label>Szczepiony:</label></br>
        <input type="radio" id="T" name="vaccinated" value="1">
        <label for="T">tak</label><br>
        <input type="radio" id="N" name="vaccinated" value="0">
        <label for="N">nie</label><br>
        <label>Uagi: <input type="text" name="comments"></label></br>
        <input type="submit" value="Zatwierdź">

    </form>
    <?php
}
else
{
    exit;
}

oci_close($conn);