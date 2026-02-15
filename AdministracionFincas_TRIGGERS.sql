#TRIGGERS ADMINISTRACIÓN FINCAS

use administracionfincas;

#1- Comprobar que los vecinos que asisten a una reunión son de la misma comunidad.

delimiter //
create trigger AsistenciaReunionBI before insert
on asiste
for each row
begin
-- contamos cuantos vecinos asisten a la misma reunión(tienen que ser de la misma comunidad)
	declare numVecinosAntiguos int;
    set numVecinosAntiguos = (select count(CodV)
                              from asiste
			                  where CodR = new.CodR
                              group by CodR);
-- Comprobamos que al menos hay un asistente en la reuníon(si es 0 insertamos sin problema)
	if numVecinosAntiguos >= 1 then 
-- Comprobamos que CodCom de los vecinos que están en la reunión es el mismo que el del vecino que queremos insertar
		if (select CodCom 
            from vecino 
		    where CodV = (select CodV 
						  from asiste
                          where CodR = new.CodR -- CodCom de los vecinos que ya están insertados de antes
                          limit 1)) <> (select CodCom
								       from vecino
                                       where CodV = new.CodV) then  -- CodCom del que queremos insertar
			signal sqlstate '45000' set message_text = 'El vecino no pertenece a la comunidad de la reunión a la que quiere asistir';
        end if;
	end if;
end;
// 
delimiter ;

insert into asiste  values (5,3, "2023-03-10"); -- no deja, salta el error
insert into asiste values (1, 12, "2023-07-15"); -- aquí si lo mete 

#2- Comprobar que a la hora de insertar un presidente, no exista otro vecino en esa comunidad que ya esté ocupando el cargo.

delimiter //
create trigger NuevoPresidenteBI before insert
on presidente
for each row
begin
-- fecha en la que fue elegido el último presidente para después comparar
	declare ultimaFecha date;
    set ultimaFecha = (select max(fechaE)
					   from presidente
                       where CodCom = new.CodCom
                       group by CodCom);
	-- si han pasado menos de 4 años(1461 días) todavía no puede ser presidente porque el actual no acabó su mandato
	if datediff(new.fechaE, ultimaFecha) < 1461 then
		signal sqlstate '45000' set message_text = 'El actual presidente de la comunidad no ha acabado su mandato';
	end if;
end;
// 
delimiter ;

insert into presidente values (1, 2, "2024-02-02"); -- no deja, salta error
insert into presidente values (1, 2, "2027-02-02"); -- aquí si lo mete

#3- Comprobar que el presidente elegido pertenece a la comunidad en la que va a ser presidente.

delimiter //
create trigger PresiComBI before insert
on presidente
for each row
begin
-- obtener la comunidad a la que pertenece el presidente que estamos insertando
	declare CodComPresi int;
    set CodComPresi = (select CodCom
					   from vecino 
                       where CodV = new.CodV);
	-- comprobar si el CodCom del presidente que insertamos es el mismo que el de la comunidad a la que pertenece y va a ser presidente
	if CodComPresi <> new.CodCom then
		signal sqlstate '45000' set message_text = 'Este vecino no puede ser presidente de una comunidad a la que no pertenece';
	end if;
end;
// 
delimiter ;

insert into presidente values (3, 2, "2027-02-02"); -- no deja, salta error
insert into presidente values (1, 2, "2027-02-02"); -- aquí si lo mete

#4- Si un vecino deja de ser propietario, actualizar automáticamente su fecha de baja.

-- Es decir, cuando hagamos un update y el campo pase de 1 a 0 poner automáticamente la fecha en la que se ha hecho es baja que
-- sería la fechaFin

delimiter //
create trigger FinPropietarioBU before update
on vecino
for each row
begin
	if new.esPropietario = 0 and old.esPropietario = 1 then
		set new.fechaFin = curdate();
	end if;
end;
//
delimiter ;

update vecino
set esPropietario = 0
where CodV = 1;

#5- Guardar el número de telefono y información de los trabajadores que se eliminan de la tabla (despedidos) por si hiciera falta contactar con ellos en el futuro.

CREATE TABLE InfoDespedidos(
	numTel VARCHAR(15),
    nombrePersonal VARCHAR(50),
    fecDespido DATE,
    usuario VARCHAR(50)
    )
    ;

delimiter //
create trigger InfoDespedidosBD before delete 
on personal
for each row 
begin
	declare numTel varchar(15);
    set numTel = (select NumTel
				  from telefonopersonal
                  where CodP = old.CodP);
	insert into InfoDespedidos
		values (numTel, concat(old.nom, ' ', old.ape1, ' ', old.ape2), curdate(), user());
end;
//
delimiter ;

/*
delete from personal
where CodP = 1;
*/





