with Ada.Text_IO;
use Ada.Text_IO;
-- utilitzam el paquet que hem creat
with Queue;

procedure simuladorjosep is

    -- declaram el tipus jugador, amb un nom i una longitud
    type Jugador is record
        nom: String(1..20);
        longitud: Natural;
    end record;

    package coac is new Queue (element => Jugador);
    -- declaram el package per llegir numeros de teclat
    package numeros is new Ada.Text_IO.Integer_IO(Integer);

    use coac;
    use numeros;

    cola : coa;
    f_entrada: File_Type;   
    usuari: Natural;
    guanyador: Jugador;

    -- posar elements agafa tots el noms del fitxer i els va posant a la coa
    procedure posar_elements(f: in out File_Type; c: in out coa) is
        linia: String (1..20);
        longitud: Natural;
        persona: Jugador;
        begin
        -- buidam la coa, per si aquesta esta plena
            if esbuida(c) then
                buidar(c);
            end if;

        -- llegim de fitxer el noms dels jugadors
            Open(f, mode => In_File, name => "jugadors.txt");
            while not End_Of_File(f) loop
                Get_line(f,linia, longitud);
                persona.nom := linia; persona.longitud := longitud;
            -- amb la funció "posar" anam afegint els jugadors a la coa
                posar(c, persona);
                Put_line("-" & linia(1..longitud));
            end loop;
        -- tancam el fitxer perque no boti un error
            Close(f);
            exception
                when desbordament => Put_line("La coa s'ha desbordat");
    end posar_elements;

    -- aquest procediment elimina el jugador corresponent de la coa
    procedure matar (c: in out coa; n: in Natural) is
        persona: Jugador;
        begin
            for i in 1..n loop
                persona:= agafar_primer(c);
                borrar_primer(c);
                posar(c, persona);
            end loop;
            persona:= agafar_primer(c);
            Put_line("Durant la passada ha mort: " & persona.nom(1..persona.longitud));
            borrar_primer(c);
            exception
                when desbordament => Put_line("La coa s'ha desbordat");
                when mal_us => Put_line("No hi ha cap element dins la coa, l'operacio es incorrecta");
    end matar;

    -- la funció joc retorna el jugador guanyador del joc
    -- utilitza el procediment matar
    function joc (c: in out coa; n: in Natural) return Jugador is
        begin
            while not is_last_item(c) loop
                matar(c, n);
            end loop;
            return agafar_primer(c);
    end joc;

    begin
        Put_line("SIMULADOR DE JOSEP");
        Put_line("");
        Put("Escriu el nombre de passades: ");
        Get(usuari);
        Put_line("Els jugadors que participaran son: ");
        posar_elements(f_entrada, cola);
        guanyador:= joc (cola, usuari);
        Put_line("");
        Put_line("El guanyador del joc es: " & guanyador.nom(1..guanyador.longitud));
        exception
            when data_error => Put_line("No has picat un nombre");
end simuladorJosep;
