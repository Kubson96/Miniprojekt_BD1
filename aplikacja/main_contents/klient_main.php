<?php

require_once 'db_connection.php'; 
		
$conn = openDatabase();

if ($conn)
{
    $actual_link = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http") . "://$_SERVER[HTTP_HOST]$_SERVER[REQUEST_URI]";

    if (isset($_GET['zamawianie']) && $_GET['zamawianie'] == 1)
    {
        $idProduktu = $_GET['ID_Produktu'];
        $stid = oci_parse($conn, 'SELECT * FROM W_klient WHERE ID_Produktu = ' . $idProduktu);
        oci_execute($stid);
        
        if (oci_execute($stid) == false)
        {
            $e = oci_error($stid);
            echo "<p class=\"error\">Błąd podczas wybierania produktu;</br>";
            echo htmlentities($e['message']);
            echo "</p>\n";
        }

        echo "<h3 class=\"left-align sub-title\">Zamawianie poduktu</h3>\n";
        echo "<table>\n";
        echo "<td>Kategoria</td>\n";
        echo "<td>Nazwa</td>\n";
        echo "<td>Opis</td>\n";
        echo "<td>Cena BRUTTO</td>\n";
        echo "<td>Ilość</td>\n";
        echo "<td>Kod produktu</td>\n";
        echo "<td>Nazwa producenta</td>\n";
        echo "<td>Mieś. gwarancji</td>\n";
        while ($row = oci_fetch_array($stid, OCI_ASSOC+OCI_RETURN_NULLS)) {
            echo "<tr>\n";
            foreach ($row as $item => $value) {
    
                if ($item != 'ID_PRODUKTU')
                {
                    echo "<td>" . ($value !== null ? htmlentities($value, ENT_QUOTES) : "&nbsp;") . "</td>\n";
                }
            }
            echo "</tr>\n";
        }
        echo "</table>\n";

        $adresString = '';
        if (isset($_GET['ID_Klienta'])) {
            $idKlienta = $_GET['ID_Klienta'];
            $stidSub = oci_parse($conn, 'SELECT * FROM W_adres_klienta WHERE ID_Klienta = ' . $idKlienta);
            oci_execute($stidSub);

            while (($row = oci_fetch_array($stidSub))) {
                $adresString = $row['ULICA'] . ', ' . $row['NR_BUDYNKU'] . '/ ' . $row['NR_MIESZKANIA'] . "</br>\n";
                $adresString .= $row['MIASTO'] . "</br>\n";
            }
            oci_free_statement($stidSub);

            echo "<h3 class=\"left-align sub-title\">Wybierz ilość i sposób dostawy</h3>\n";
            echo "<h3 class=\"\">Adres dostawy:</h3>";
            echo "<p class=\"\">" . $adresString . "</p>";
            echo "<form action=\"" . $actual_link . "\" id=\"customer_form\">\n";
            echo "<input type=\"text\" style=\"display: none;\" name=\"ID_Produktu\" value=\"" . $idProduktu . "\">\n";
            echo "<input type=\"text\" style=\"display: none;\" name=\"ID_Klienta\" value=\"" . $idKlienta . "\">\n";
            echo "<input type=\"text\" style=\"display: none;\" name=\"ID_Adresu\" value=\"" . $_GET['ID_Adresu'] . "\">\n";
            echo "<label>Ilość: <input type=\"number\" name=\"ilosc\" value=\"1\"></label>\n";
            echo "<label><input type=\"checkbox\" name=\"dostawa\" value=\"1\"> Dostaa na podany adres</label>\n";
            echo "<input type=\"submit\" value=\"Zamów\">\n";
            echo "</form>\n";
            echo "<a href=\"main.php?ID_Klienta=" . $idKlienta . "\">Wróć do widoku produktów</a>";
        }
    }
    else if (isset($_GET['ilosc']) && $_GET['ilosc'] > 0)
    {
        if (isset($_GET['ID_Klienta'])) {
            $idKlienta = $_GET['ID_Klienta'];
            $doWysylki = 0;

            $kodOdp = 0;
            $wiadOdp = '';

            if (isset($_GET['dostawa']))
            {
                $doWysylki = 1;
            }

            echo "<h3 class=\"left-align sub-title\">Zamawiam</h3>\n";

            $stidSub = oci_parse($conn, 'BEGIN Zamow_produkt(:ID_Produktu, :ID_Klienta, 
            :ilosc, :czy_do_wysylki, :ID_Adresu, :kod_odp, :wiadomosc); END;');
            
            oci_bind_by_name($stidSub, ':ID_Produktu', $_GET['ID_Produktu'], 7);
            oci_bind_by_name($stidSub, ':ID_Klienta', $idKlienta, 7);
            oci_bind_by_name($stidSub, ':ilosc', $_GET['ilosc'], 5, SQLT_INT);
            oci_bind_by_name($stidSub, ':czy_do_wysylki', $doWysylki, 2);
            oci_bind_by_name($stidSub, ':ID_Adresu', $_GET['ID_Adresu'], 7);
            oci_bind_by_name($stidSub, ':kod_odp', $kodOdp, 32);
            oci_bind_by_name($stidSub, ':wiadomosc', $wiadOdp, 512);
            
            if (oci_execute($stidSub) == false)
            {
                $e = oci_error($stidSub);
                echo "<p class=\"error\">Błąd podczas zamawiania;</br>";
                echo htmlentities($e['message']);
                echo "</p>\n";
            }
            if ($kodOdp < 0)
            {
                echo "<p class=\"error\">Błąd: " . $kodOdp . ': ' . $wiadOdp . "</p>";
            }
            else
            {
                echo "<p class=\"good\">Produkt został zamówniony.</p>";
            }

            oci_free_statement($stidSub);

            echo "<a href=\"main.php?ID_Klienta=" . $idKlienta . "\">Wróć do widoku produktów</a>";
        }
    }
    else
    {
        $stid = oci_parse($conn, 'SELECT * FROM W_klient');
        oci_execute($stid);
    
        $i = 0;
        $idAdresu  = NULL;
        echo "<h3 class=\"left-align sub-title\">Tabela produktów</h3>\n";
        echo "<table>\n";
        echo "<tr><td>Lp.</td>\n";
        echo "<td>Kategoria</td>\n";
        echo "<td>Nazwa</td>\n";
        echo "<td>Opis</td>\n";
        echo "<td>Cena BRUTTO</td>\n";
        echo "<td>Ilość</td>\n";
        echo "<td>Kod produktu</td>\n";
        echo "<td>Nazwa producenta</td>\n";
        echo "<td>Mieś. gwarancji</td>\n";
        if (isset($_GET['ID_Klienta'])) {
            $idKlienta = $_GET['ID_Klienta'];
            $stidSub = oci_parse($conn, 'SELECT * FROM W_adres_klienta WHERE ID_Klienta = ' . $idKlienta);
            oci_execute($stidSub);

            while (($row = oci_fetch_row($stidSub))) {
                $idAdresu = $row[0];
            }
            oci_free_statement($stidSub);
            echo "<td>Zamawianie</td>\n"; 
        }
        while ($row = oci_fetch_array($stid, OCI_ASSOC+OCI_RETURN_NULLS)) {
            echo "<tr>\n";
                echo "<td>" . ++$i . "</td>\n";
            foreach ($row as $item => $value) {
    
                if ($item != 'ID_PRODUKTU')
                {
                    echo "<td>" . ($value !== null ? htmlentities($value, ENT_QUOTES) : "&nbsp;") . "</td>\n";
                }
            }
            if (isset($_GET['ID_Klienta']))
            {
                echo "<td> <a href=\"" . $actual_link  . "&ID_Produktu=" . $row['ID_PRODUKTU'] . "&ID_Adresu=" . $idAdresu . "&zamawianie=1\">Zamów</a> </td>\n";
            }
            echo "</tr>\n";
        }
        if ($i == 0)
        {
            echo "<p class=\"info\">Brak danych do wyświetlenia.</p>";
        }
        echo "</table>\n";
    
        $stid = oci_parse($conn, 'SELECT * FROM W_wybor_klienta');
        oci_execute($stid);
        if (oci_execute($stid) == false)
        {
            $e = oci_error($stid);
            echo "<p class=\"error\">Błąd podczas sprawdzania listy klientów;</br>";
            echo htmlentities($e['message']);
            echo "</p>\n";
        }
    
        $i = 0;
        echo "<h3 class=\"left-align sub-title\">Wybierz klienta</h3>\n";
    
        echo "<select name=\"ID_Klienta\" id=\"customers\"  form=\"customer_form\">\n";
        while ($row = oci_fetch_array($stid, OCI_ASSOC+OCI_RETURN_NULLS)) {
            echo "<option value=\"" . $row['ID_KLIENTA'] . "\">";
    
            foreach ($row as $item => $value) {
    
                if ($item != 'ID_KLIENTA' && $item != 'NR_TELEFONU' && $item != 'NIP')
                {
                    //var_dump($item);
                    echo ($value !== null ? htmlentities($value, ENT_QUOTES) : "&nbsp;") . ", ";
                }
    
                if ($item == 'NR_TELEFONU')
                {
                    echo ($value !== null ? htmlentities('telefon: ' . $value, ENT_QUOTES) : "&nbsp;") . ", ";
                }
    
                if ($item == 'NIP')
                {
                    echo ($value !== null ? htmlentities('NIP: ' . $value, ENT_QUOTES) : "&nbsp;");
                }
            }
            echo "</option>\n";
        }
        echo "</select>\n";
    
        echo "<form action=\"/main.php\" id=\"customer_form\">\n";
        echo "<input type=\"submit\" value=\"Wybierz\">\n";
        echo "</form>\n";
    
        if (isset($_GET['ID_Klienta']))
        {
            $idKlienta = $_GET['ID_Klienta'];
            $stid = oci_parse($conn, 'SELECT * FROM W_zamowienia_klienta WHERE ID_klienta = ' . $idKlienta);
            oci_execute($stid);
    
            $i = 0;
            echo "<h3 class=\"left-align sub-title\">Zamowienia klienta</h3>\n";
            echo "<table>\n";
            echo "<tr><td>Lp.</td>\n";
            echo "<td>Nr klienta</td>\n";
            echo "<td>Nazwa produktu</td>\n";
            echo "<td>Kod produktu</td>\n";
            echo "<td>Cena BRUTTO</td>\n";
            echo "<td>Ilość</td>\n";
            echo "<td>Data złożenia zamówienia</td>\n";
            echo "<td>Przyjęto zamóeienie</td>\n";
            echo "<td>Zrealizowano zamóeienie</td>\n";
            echo "<td>Data realizacji zamównienia</td>\n";
            echo "<td>Do wysyłki</td>\n";
            while ($row = oci_fetch_array($stid, OCI_ASSOC+OCI_RETURN_NULLS)) {
                echo "<tr>\n";
                echo "<td>" . ++$i . "</td>\n";
                $zrealizowano = false;    
                foreach ($row as $item => $value) {
                    
                    if ($item == 'CZY_PRZYJETO_ZAMOWIENIE')
                    {
                        echo "<td>" . ($value == 1 ? htmlentities('TAK', ENT_QUOTES) : "NIE") . "</td>\n";
                    } else if ($item == 'CZY_ZREALIZOWANO_ZAMOWIENIE')
                    {
                        if ($value == 1)
                        {
                            $zrealizowano = true;
                            echo "<td>TAK</td>\n";
                        }
                        else
                        {
                            echo "<td>NIE</td>\n";
                        }
                    } else if ($item == 'CZY_DO_WYSYLKI')
                    {
                        echo "<td>" . ($value == 1 ? htmlentities('TAK', ENT_QUOTES) : "NIE") . "</td>\n";
                    } else if ($item == 'DATA_REALIZACJI_ZAMOWIENIA')
                    {
                        if ($zrealizowano == true)
                        {
                            echo "<td>" . ($value !== null ? htmlentities($value, ENT_QUOTES) : "&nbsp;") . "</td>\n";
                        }
                        else
                        {
                            echo "<td>-</td>\n";
                        }
                    } else
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
        }
    }
    
}
else
{
    exit;
}

oci_close($conn);