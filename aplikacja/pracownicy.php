<!DOCTYPE html>
<html lang="pl">

<head>
	<?php require_once 'html_head.php'; ?>
	<title>Pracownicy - sklep meblowy</title>
  
</head>

<body>

  <?php
    require_once 'header.php';
  ?>

  <main>
    <h2>Pracownicy</h2>
    <table>
      <?php
      //require_once 'pacjenci_select.php';
      ?>
    </table>

    <section>
      <h2>Wyszukaj</h2>
      <form action="" method="get">
        <label>
          Imię pacjenta:
          <input type="text" name="pacjenci-imie">
        </label><br>
        <label>
          Nazwisko pacjenta:
          <input type="text" name="pacjenci-nazwisko">
        </label><br>
        <label>
          Data urodzenia:
          <input type="date" name="pacjenci-data_urodzenia">
        </label><br>
        <label>
          Ulica :
          <input type="text" name="pacjenci-ulica">
        </label><br>
        <label>
          Numer domu :
          <input type="text" name="pacjenci-numer_domu">
        </label><br>
        <label>
          Kod pocztowy :
          <input type="text" name="pacjenci-kod_pocztowy">
        </label><br>
        <label>
          Miejscowość :
          <input type="text" name="pacjenci-miejscowosc">
        </label><br>
        <label>
          Telefon :
          <input type="text" name="pacjenci-telefon">
        </label><br>
        <label>
          PESEL:
          <input type="text" name="pacjenci-pesel">
        </label><br>

        <button type="submit">Szukaj</button>
      </form>
    </section>

    <section>
      <h2>Dodaj pacjenta</h2>
      <form action="" method="post">
        <label>
          Imię pacjenta:
          <input type="text" name="pacjenci-imie" required pattern="[A-ZŻŹŁŚ]{1}[a-ząęółćźżńś]{1,49}" title="Uzupełnij poprawnie.">
        </label><br>
        <label>
          Nazwisko pacjenta:
          <input type="text" name="pacjenci-nazwisko" required pattern="[A-ZŻŹŁŚ]{1}[a-ząęółćźżńś]{1,99}" title="Uzupełnij poprawnie.">
        </label><br>
        <label>
          Data urodzenia:
          <input type="date" name="pacjenci-data_urodzenia" required min="1930-01-01" max="2020-01-01" title="Data musi zawierać się w latach 1930-2000.">
        </label><br>
        <label>
          Ulica :
          <input type="text" name="pacjenci-ulica" required pattern="[A-ZŻŹŁŚ]{1}[a-ząęółćźżńś]{1,99}" title="Uzupełnij poprawnie.">
        </label><br>
        <label>
          Numer domu :
          <input type="text" name="pacjenci-numer_domu" required pattern="[A-Z0-9\/\s]{1,10}" title="Uzupełnij poprawnie.">
        </label><br>
        <label>
          Kod pocztowy :
          <input type="text" name="pacjenci-kod_pocztowy" required pattern="[0-9]{2}\-[0-9]{3}" title="Podaj kod w formacie XX-XXX.">
        </label><br>
        <label>
          Miejscowość :
          <input type="text" name="pacjenci-miejscowosc" required pattern="[A-ZŻŹŁŚ]{1}[a-ząęółćźżńś]{1,49}" title="Uzupełnij poprawnie.">
        </label><br>
        <label>
          Telefon :
          <input type="text" name="pacjenci-telefon" required pattern="\+[0-9]{11}" title="Podaj numer z nr kierunkowym. Format np. +48987654321">
        </label><br>
        <label>
          PESEL:
          <input type="text" name="pacjenci-pesel" required pattern="[0-9]{11}" title="Pesel posiada 11 cyfr">
        </label><br>
        <label>
          Uwagi:
          <textarea rows="4" cols="30" name="pacjenci-uwagi"></textarea>
        </label><br>

        <button type="submit">Dodaj pacjenta</button>

      </form>
    </section>

  </main>
  
  <?php
    require_once 'footer.php';
  ?>

</body>

</html>