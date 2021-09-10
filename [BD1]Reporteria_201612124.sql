select nombre,MAX(cantidad) from (
    select nombre
)






/*-----------------CONSULTA 4------------------*/
select nombre || ' ' || apeliido as Nombre
    from actor
    where  UPPER(actor.apeliido) LIKE '%SON%'
    order by actor.nombre;