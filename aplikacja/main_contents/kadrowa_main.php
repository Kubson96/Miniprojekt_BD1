<?php

require_once 'db_connection.php'; 
		
$conn = openDatabase();

if ($conn)
{
    if (isset($_GET['name']))
    {
        $stidSub = oci_parse($conn, 'BEGIN Dodaj_pracownika(:imie_v, :nazwisko_v, 
        :data_ur_v, :PESEL_v, :nr_telefonu_v, :email_v, :plec_v, :misto_v, :ulica_v, :nr_budynku_v, :nr_mieszkania_v, 
        :pensja_v, :st_zdrowia_v, :data_bad_okresowego_v, :szczepiony_v, :ID_Stanowiska_v, :ID_Przelozonego_v, :uwagi_v); END;');
            
        oci_bind_by_name($stidSub, ':imie_v', $_GET['name'], 55);
        oci_bind_by_name($stidSub, ':nazwisko_v', $_GET['surname'], 70);
        oci_bind_by_name($stidSub, ':data_ur_v', $_GET['born']);
        oci_bind_by_name($stidSub, ':PESEL_v', $_GET['PESEL'], 11);
        oci_bind_by_name($stidSub, ':nr_telefonu_v', $_GET['tel'], 13);
        oci_bind_by_name($stidSub, ':email_v', $_GET['mail'], 216);
        oci_bind_by_name($stidSub, ':plec_v', $_GET['sex'], 2);
        oci_bind_by_name($stidSub, ':misto_v', $_GET['city'], 70);
        oci_bind_by_name($stidSub, ':ulica_v', $_GET['street'], 70);
        oci_bind_by_name($stidSub, ':nr_budynku_v', $_GET['home_num'], 30);
        oci_bind_by_name($stidSub, ':nr_mieszkania_v', $_GET['apartment_num'], 30);
        oci_bind_by_name($stidSub, ':pensja_v', $_GET['salary']);
        oci_bind_by_name($stidSub, ':st_zdrowia_v', $_GET['health'], 75);
        oci_bind_by_name($stidSub, ':data_bad_okresowego_v', $_GET['test_date']);
        oci_bind_by_name($stidSub, ':szczepiony_v', $_GET['vaccinated'], 2);
        oci_bind_by_name($stidSub, ':ID_Stanowiska_v', $_GET['ID_Stanowiska']);
        oci_bind_by_name($stidSub, ':ID_Przelozonego_v', $_GET['ID_Przelozonego']);
        oci_bind_by_name($stidSub, ':uwagi_v', $_GET['comments'], 512);
        
        if (oci_execute($stidSub) == false)
        {
            $e = oci_error($stidSub);
            echo "<p class=\"error\">Błąd podczas dodawania pracownika;</br>";
            echo htmlentities($e['message']);
            echo "</p>\n";
        }
        else
        {
            echo "<p class=\"good\">Pracownik został dodany.</p>";
        }

        oci_free_statement($stidSub);

        echo "<a href=\"main.php\">Wróć do widoku podstawowego</a>";
    }

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
        <label>Wybierz stanowisko: 
        <?php
            $stid = oci_parse($conn, 'SELECT ID_Stanowiska, nazwa FROM Stanowiska');
            oci_execute($stid);

            echo "<select name=\"ID_Stanowiska\" id=\"position\"  form=\"new_worker_form\">\n";
            while ($row = oci_fetch_array($stid, OCI_ASSOC+OCI_RETURN_NULLS)) {
                echo "<option value=\"" . $row['ID_STANOWISKA'] . "\">";

                foreach ($row as $item => $value) {

                    if ($item == 'ID_STANOWISKA')
                    { }
                    else
                    {
                        echo ($value !== null ? htmlentities($value, ENT_QUOTES) : "&nbsp;") . " ";
                    }
                }
            }
            echo "</select></br>\n";
        ?>
        </label>
        <label>Wybierz przełożonego: 
        <?php
            $stid = oci_parse($conn, 'SELECT ID_Osoby, imie, nazwisko, PESEL FROM Osoby');
            oci_execute($stid);

            echo "<select name=\"ID_Przelozonego\" id=\"boss\"  form=\"new_worker_form\">\n";
            while ($row = oci_fetch_array($stid, OCI_ASSOC+OCI_RETURN_NULLS)) {
                echo "<option value=\"" . $row['ID_OSOBY'] . "\">";

                foreach ($row as $item => $value) {

                    if ($item == 'ID_OSOBY')
                    { }
                    else if ($item == 'PESEL')
                    {
                        echo ($value !== null ? htmlentities(', PESEL: ' . $value, ENT_QUOTES) : "&nbsp;") . " ";
                    }
                    else
                    {
                        echo ($value !== null ? htmlentities($value, ENT_QUOTES) : "&nbsp;") . " ";
                    }
                }
            }
            echo "</option>\n";
            echo "<option value=\"-1\">brak";
            echo "</option>\n";
            echo "</select></br>\n";
        ?>
        </label>

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