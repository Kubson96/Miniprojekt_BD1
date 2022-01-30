<?php

require_once 'db_connection.php'; 
		
$conn = openDatabase();

if ($conn)
{
    if (isset($_GET['action_num']))
    {
        $actionNum = $_GET['action_num'];
        $stidSub = '';
        if ($actionNum == 1)
        {
            $stidSub = oci_parse($conn, 'BEGIN zw_cene_naj_wyb_uslug(:procent_podwyzki); END;');
            
            oci_bind_by_name($stidSub, ':procent_podwyzki', $_GET['proc_ch'], 4);
        }
        else if ($actionNum == 2)
        {
            $stidSub = oci_parse($conn, 'BEGIN zw_cene_naj_wyb_zamowien(:procent_podwyzki); END;');
            
            oci_bind_by_name($stidSub, ':procent_podwyzki', $_GET['proc_ch'], 4);
        }
        else if ($actionNum == 3)
        {
            $stidSub = oci_parse($conn, 'BEGIN nadaj_prom_na_min_wyb_prod(:procent_prom); END;');
            
            oci_bind_by_name($stidSub, ':procent_prom', $_GET['proc_ch'], 4);
        }
        else if ($actionNum == 4)
        {
            $stidSub = oci_parse($conn, 'BEGIN skroc_czas_przyjecia_zam; END;');
        }
        
        if (oci_execute($stidSub) == false)
        {
            $e = oci_error($stidSub);
            echo "<p class=\"error\">Błąd podczas wukonywania akcji;</br>";
            echo htmlentities($e['message']);
            echo "</p>\n";
        }
        else
        {
            echo "<p class=\"good\">Akcja została wykonana.</p>";
        }

        oci_free_statement($stidSub);

        echo "<a href=\"main.php\">Wróć do widoku podstawowego</a>";
    }

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

    echo "<h3 class=\"left-align sub-title\">Wybierz akcję do wykonania</h3>\n";
    ?>
        <form id="new_action" action="main.php">
            <label>Wybierz akcję: 
                <select name="action_num" id="action_num" form="new_action">
                    <option value="1">Zwiększ cenę najczęściej wybieranych usług</option>
                    <option value="2">Zwiększ cenę najczęściej wybieranych zamówień</option>
                    <option value="3">Nadaj promocję na najmniej wybierane produkty</option>
                    <option value="4">Skróć czas przyjęcia zamówień</option>
                </select>
            </label></br>
            <label>Procent zmiany: 
                <input type="number", name="proc_ch" value="20">%
            </label></br>

            <input type="submit" value="Wykonaj">
        </form>
    <?php
}
else
{
    exit;
}

oci_close($conn);