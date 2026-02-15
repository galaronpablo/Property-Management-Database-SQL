#CONSULTAS ADMINISTRACIÓN FINCAS

#1 Nombre de las comunidades que tiene más averías que la media.
-- creamos una vista para saber el número de averías que ha tenido cada comunidad.
create view NumAveriasTotal as
	select c.NomCom, count(a.CodN) as NumAverias
	from comunidad as c inner join necesidad as n on c.CodCom = n.CodCom
	inner join averia as a on n.CodN = a.CodN
	group by c.CodCom;

-- seleccionamos las comunidades que tengan averías por encima de la media
select NomCom, NumAverias
from NumAveriasTotal
where NumAverias > (select avg(NumAverias)
						  from NumAveriasTotal);

#2 Nombre del vecino que ha asistido a más reuniones.
create view reunionesVecino as 
	select concat(nom, ' ', ape1 , ' ', ape2) as nombreV, count(fechaR) as numReuniones
	from asiste as a inner join vecino as v on a.CodV = v.CodV
	group by a.CodV;
    
select nombreV, numReuniones
from reunionesVecino
where numReuniones = (select max(numReuniones)
					  from reunionesVecino);
                      
#3 Nombre de las comunidades que han dejado de ser administradas por la sede en el último año 
select nomCom, fechaIni, fechaFin
from comunidad 
where year(fechaFin) > (year(curdate()) - 1);

#4 Necesidades cotidianas que han surgido en cada una de las comunidades y empresa que las ha solucionado
select nomCom, tipoN, NomComercial
from comunidad as com inner join necesidad as n on com.codCom = n.codCom
	inner join cotidiana as c on n.codN = c.codN 
    inner join satisface as s on c.codN = s.codN 
    inner join empresa as e on s.CIF = e.CIF;
    
#5 Comprueba si ha habido algún presidente que haya abandonado la comunidad después de su cargo. ¿Quién?
select concat(nom, ' ', ape1, ' ', ape2) nombreV, fechaE, fechaFin 
from vecino as v inner join presidente as p on v.codV = p.codV
where fechaFin > fechaE;

#6 Comprueba si ha habido algún vecino que haya sido elegido presidente más de una vez en alguna comunidad. En ese caso, haya su nombre, la fecha de las diferentes elecciones en las que ha sido elegido y la comunidad.
create view presidenteVariasVeces as
select p.codV, count(p.codV) as numVeces
from vecino as v inner join presidente as p on v.codV = p.codV
group by p.codV
having numVeces > 1;

select concat(nom, ' ', ape1, ' ', ape2) as nombreV, fechaE, nomCom
from vecino as v inner join presidente as p on v.codV = p.codV
	inner join comunidad as c on p.Codcom = c.CodCom
where p.codV = (select codV 
				from presidenteVariasVeces);
                
#7 Determina que avería ha sido la que más ha tardado en solucionarse. Nos interesa saber el grado de urgencia de esta y la empresa encargada de su reparación, para comprobar si dicha empresa ha sido efectiva.
-- Haz lo mismo para la avería que se ha solucionado más rápido
drop view if exists tiempoReparacion;
create view tiempoReparacion as 
select datediff(fechaFin, fechaIni) diasReparacion
from satisface;
-- Avería que más se ha tardado en solucionar
select tipoN averia, datediff(fechaFin, fechaIni) diasReparacion, gradoUrgencia, nomComercial empresa
from necesidad n inner join averia a on n.codN = a.codN 
	inner join satisface s on a.codN = s.codN
    inner join empresa e on e.CIF = s.CIF
where datediff(fechaFin, fechaIni) = (select max(diasReparacion) from tiempoReparacion);
-- Avería solucionada más rápido
select tipoN averia, datediff(fechaFin, fechaIni) diasReparacion, gradoUrgencia, nomComercial empresa
from necesidad n inner join averia a on n.codN = a.codN 
	inner join satisface s on a.codN = s.codN
    inner join empresa e on e.CIF = s.CIF
where datediff(fechaFin, fechaIni) = (select min(diasReparacion) from tiempoReparacion);

#8 Para cada comunidad, halla el número del portal que tenga ascensor pero no disponga de cuarto de basuras.
select p.CodCom, NumeroP, TipoElem
from portal as p inner join elementoscomunes as e on p.CodCom = e.CodCom
where p.CodCom in (select e.CodCom
				   from elementoscomunes as e inner join portal as p on e.CodCom = p.CodCom
                   where TipoElem like 'Ascensor') and p.CodCom not in (select e.CodCom
																		from elementoscomunes as e inner join portal as p on e.CodCom = p.CodCom
                                                                        where TipoElem like 'Cuarto de basuras');

#9 Aumentar el salario de todo el personal en un 5% que lleve trabajando más de 5 años en la empresa.
set sql_safe_updates=0;
update personal
set Salario = Salario * 1.05
where datediff(curdate(), fechaC) > (365 * 5 + 1);

#10 Datos de la comunidad que más dinero ha hecho ganar a empresas de mantenimiento.
select c.CodCom, NomCom
from comunidad as c inner join necesidad as n on c.CodCom = n.CodCom
	inner join averia as a on a.CodN = n.CodN
    inner join satisface as s on s.CodN = a.CodN
    inner join empresa as e on e.CIF = s.CIF
    where Actividad like '%Mantenimiento%'
    group by c.CodCom
    having sum(precio) = (select sum(precio) as total
						  from satisface as s inner join empresa as e on s.CIF = e.CIF
						  group by e.CIF
						  order by total desc
                          limit 1);

#11 Eliminar las averías con grado de urgencia mínimo.
delete from necesidad
where CodN in (select CodN
			   from averia
			   where GradoUrgencia = 1);
               
#12 Borrar los vecinos cuyo nombre empiece por la letra 'R', su número de teléfono acabe en 0 y hayan asistido a una sola reunión.
-- Rosa, está comprobado.
delete from vecino
where nom like 'R%' and CodV in (select CodV
								 from telefonovecino
                                 where NumTel like '%0') and CodV in (select CodV
								                                      from asiste 
                                                                      group by CodV
                                                                      having count(CodR) = 1);

#13 Realiza una comparativa de los salarios del personal en función de la ciudad.
select nombreC, avg(Salario) as SalarioPromedio, max(Salario) as SalarioMaximo, min(Salario) as SalarioMinimo
from personal as p inner join ciudad as c on c.CodC = p.CodC
group by c.CodC
order by SalarioPromedio desc;

#14 Comunidades con instalacones en peor estado.
select nomCom, tipo, estado 
from instalacion as i inner join comunidad as c on i.codCom = c.codCom
where estado like 'Malo';

#15 Obtén el total de empleados por sede.
select DireccionS, count(*) as TotalEmpleados
from personal as p inner join sede as s on p.CodS = s.CodS
group by  DireccionS;

#16 Cuenta la cantidad de instalaciones por tipo en la comunidad "Residencial Gran Vía".
select Tipo, count(*) as Cantidad
from instalacion as i inner join comunidad as c on i.CodCom = c.CodCom
where c.NomCom = 'Residencial Gran Vía'
group by Tipo;


		  





