/*-------------consulta 1    --------------*/
select pelicula.titulo as nombre, count(*) as cantidad
    from pelicula
    inner join renta_pelicula
    on pelicula.id_pelicula = renta_pelicula.id_pelicula
        where pelicula.titulo = 'SUGAR WONKA'
        GROUP BY pelicula.titulo;

/*----------------------consulta 2-----------------------*/
select cliente.nombre,cliente.apellido,ROUND(SUM(renta_pelicula.precio),2) as Total
    from Cliente
    inner join Renta
    on cliente.id_cliente = renta.id_cliente
    inner join renta_pelicula
    on renta.id_renta = renta_pelicula.id_renta
    group by cliente.nombre,cliente.apellido
    having count(renta_pelicula.id_pelicula) >= 40
    order by cliente.nombre,cliente.apellido asc;

/*------------------consulta 3--------------*/
select cliente.nombre,cliente.apellido,pelicula.titulo as Nombre_Pelicula
    from cliente
    inner join Renta
        on cliente.id_cliente = renta.id_cliente
    inner join renta_pelicula
        on renta.id_renta = renta_pelicula.id_renta
    inner join pelicula
        on renta_pelicula.id_pelicula = pelicula.id_pelicula
    where renta.fecha_devuelta = '-'
        or  (SELECT extract( day FROM (CAST(renta.fecha_devuelta as timestamp) - CAST(renta.fecha_renta as timestamp))) AS dias_renta
FROM renta WHERE renta.id_renta=renta_pelicula.id_renta) > pelicula.cant_dias_renta
group by cliente.nombre,cliente.apellido,pelicula.titulo
order by cliente.nombre; /*-----6550 datos-*/

select  extract( day FROM (CAST(renta.fecha_devuelta as timestamp))) from renta where renta.fecha_devuelta = '-';
select CAST(renta.fecha_devuelta as timestamp) from renta;

/*-----------------CONSULTA 4------------------*/
select nombre || ' ' || apeliido as Nombre
    from actor
    where  UPPER(actor.apeliido) LIKE '%SON%'
    order by actor.nombre;
    
/*---------------------consulta 5------------------*/
select actor.apeliido,count(actor.nombre) as cantidad
    from actor
    where actor.apeliido != '-'
    group by actor.apeliido
    having count(actor.nombre) >= 2
    order by actor.apeliido asc;

/*--------------consulta 6 -------------------*/
select actor.nombre, actor.apeliido,pelicula.anio_lanzamiento,pelicula.titulo as nombre_pelicula,pelicula.descripcion
    from actor
    inner join actor_pelicula
        on actor.id_actor = actor_pelicula.id_actor
    inner join pelicula
        on actor_pelicula.id_pelicula = pelicula.id_pelicula
    where upper(pelicula.descripcion) like '%CROCODILE%'
          and upper(pelicula.descripcion) like '%SHARK%'
    order by actor.apeliido asc;

/*------------------consulta 7 ---------------------*/
select categoria.descripcion as Categoria, count(pelicula.id_pelicula) as Cantidad_peliculas
    from categoria
    inner join categoria_pelicula
        on categoria.id_categoria = categoria_pelicula.id_categoria
    inner join pelicula
        on categoria_pelicula.id_pelicula = pelicula.id_pelicula
    group by categoria.descripcion
    having count(pelicula.id_pelicula) >= 55 and count(pelicula.id_pelicula) <= 65;
    
/*--------------consulta 8 ----------------*/
select categoria.descripcion as Categoria, round(avg(pelicula.costo_danio - pelicula.costo_renta),2) as Promedio
    from categoria
    inner join categoria_pelicula
        on categoria.id_categoria = categoria_pelicula.id_categoria
    inner join pelicula
        on categoria_pelicula.id_pelicula = pelicula.id_pelicula
    group by categoria.descripcion
    having avg(pelicula.costo_danio - pelicula.costo_renta) > 17;


/*------------consulta 9 ----------------*/

select pelicula.titulo, actor.nombre as nombre, actor.apeliido as apellido
    from pelicula
    inner join actor_pelicula
        on pelicula.id_pelicula = actor_pelicula.id_pelicula
    inner join actor
        on actor_pelicula.id_actor = actor.id_actor
    where actor.id_actor in (select actor_pelicula.id_actor from actor_pelicula group by actor_pelicula.id_actor 
    having count(actor_pelicula.id_pelicula) >= 2);    /*-----5246------*/

/*--------------------------consulta 10 ---------------------*/

select Nombres || ' ' ||  Apellidos as Nombre_Completo
    from ( select actor.nombre as Nombres, actor.apeliido as Apellidos from actor
            UNION
            select cliente.nombre as Nombres, cliente.apellido as Apellidos 
            from cliente)  tabla1
    inner join (select actor.nombre as nombre_actor,
                actor.apeliido as apellido_actor
                from actor 
                where upper(actor.nombre||' '||actor.apeliido) like 'MATTHEW JOHANSSON')
                tabla2 on Nombres = nombre_actor
                where Apellidos <> apellido_actor;
                
/*------------consulta 11---------------*/
select a1.nombre_pais,a1.nombre_cliente || ' ' || apellido_cliente as Nombre,(a1.conteo / 
            (select count(renta_pelicula.id_pelicula) as conteo
            from pais
            inner join ciudad on pais.id_pais = ciudad.id_pais
            inner join direccion on ciudad.id_ciudad = direccion.id_ciudad
             inner join cliente on direccion.id_direccion = cliente.id_direccion 
            inner join renta on cliente.id_cliente = renta.id_cliente
            inner join renta_pelicula on renta.id_renta = renta_pelicula.id_renta
            where pais.id_pais = a1.pp)*100) as porcentaje,a1.conteo as Cantidad
    from (
    select pais.id_pais as pp,pais.nombre as nombre_pais,cliente.nombre as nombre_cliente, cliente.apellido as apellido_cliente, count(renta_pelicula.id_pelicula) as conteo
            from pais
            inner join ciudad on pais.id_pais = ciudad.id_pais
            inner join direccion on ciudad.id_ciudad = direccion.id_ciudad
            inner join cliente on direccion.id_direccion = cliente.id_direccion 
            inner join renta on cliente.id_cliente = renta.id_cliente
            inner join renta_pelicula on renta.id_renta = renta_pelicula.id_renta
            group by cliente.nombre,cliente.apellido,pais.id_pais,pais.nombre)a1
    order by a1.conteo desc  
   OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;
   
/*-------------consulta 12--------------------*/
select a1.ciudad,a1.pais,round(a1.conteo / (select count(cliente.id_cliente)
                                from cliente
                                inner join direccion on cliente.id_direccion = direccion.id_direccion
                                inner join ciudad on direccion.id_ciudad = ciudad.id_ciudad
                                inner join pais on ciudad.id_pais = pais.id_pais
                                where pais.id_pais = a1.p1
                                group by pais.id_pais)*100,2) || '%' as porcentaje
    from (select ciudad.nombre as ciudad,pais.id_pais as p1,pais.nombre as pais,count(cliente.id_cliente) as conteo
        from cliente
        inner join direccion on cliente.id_direccion = direccion.id_direccion
        inner join ciudad on direccion.id_ciudad = ciudad.id_ciudad
        inner join pais on ciudad.id_pais = pais.id_pais
        group by ciudad.nombre,pais.id_pais,pais.nombre
        order by pais.nombre asc)a1
        group by a1.ciudad,a1.pais,a1.conteo,a1.p1
        order by a1.pais,a1.ciudad;
   
/*------------consulta 13 -------------------*/

select (select p1.nombre from pais p1 where p1.id_pais = pais.id_pais) as Pais,
        (select c1.nombre || ' ' || c1.apellido from cliente c1 where c1.id_cliente = cliente.id_cliente) as nombre,
        count(renta_pelicula.id_pelicula) as conteo
        from pais 
        inner join ciudad on pais.id_pais = ciudad.id_pais
        inner join direccion on ciudad.id_ciudad = direccion.id_ciudad
        inner join cliente on direccion.id_direccion = cliente.id_direccion 
        inner join renta on cliente.id_cliente = renta.id_cliente
        inner join renta_pelicula on renta.id_renta = renta_pelicula.id_renta
        group by pais.id_pais,cliente.id_cliente
        
        having count(renta_pelicula.id_pelicula) = (
            select max(a1.conteo)
            from (
                select p.id_pais,cliente.id_cliente,count(renta_pelicula.id_pelicula) as conteo
                from pais p
                inner join ciudad on p.id_pais = ciudad.id_pais
                inner join direccion on ciudad.id_ciudad = direccion.id_ciudad
                inner join cliente on direccion.id_direccion = cliente.id_direccion 
                inner join renta on cliente.id_cliente = renta.id_cliente
                inner join renta_pelicula on renta.id_renta = renta_pelicula.id_renta
                where p.id_pais = pais.id_pais
                group by p.id_pais,cliente.id_cliente
                order by p.id_pais,cliente.id_cliente asc)a1)
                order by pais.id_pais asc, count(renta_pelicula.id_pelicula) desc;
/*------------consulta 14-----------*/
select pais.nombre as pais,ciudad.nombre as ciudad,count(renta_pelicula.id_pelicula) as conteo
    from pais
    inner join ciudad on pais.id_pais = ciudad.id_pais
    inner join direccion on ciudad.id_ciudad = direccion.id_ciudad
    inner join cliente on direccion.id_direccion = cliente.id_direccion 
    inner join renta on cliente.id_cliente = renta.id_cliente
    inner join renta_pelicula on renta.id_renta = renta_pelicula.id_renta
    inner join pelicula on renta_pelicula.id_pelicula = pelicula.id_pelicula
    inner join categoria_pelicula on pelicula.id_pelicula = categoria_pelicula.id_pelicula
    inner join categoria on categoria_pelicula.id_categoria = categoria.id_categoria
    where categoria.descripcion = 'Horror'
    group by pais.nombre,ciudad.nombre
    order by pais.nombre,ciudad.nombre;


/*-----------------consulta 15 --------------------*/
select a1.pais,a1.ciudad,round((a1.renta/a2.ciudad),2) as Promedio
    from (
        select pais.id_pais as p1,ciudad.id_ciudad,pais.nombre as pais,ciudad.nombre as ciudad,count(renta_pelicula.id_pelicula) as renta
        from pais
        inner join ciudad on pais.id_pais = ciudad.id_pais
        inner join direccion on ciudad.id_ciudad = direccion.id_ciudad
        inner join cliente on direccion.id_direccion = cliente.id_direccion 
        inner join renta on cliente.id_cliente = renta.id_cliente
        inner join renta_pelicula on renta.id_renta = renta_pelicula.id_renta
        group by pais.id_pais,ciudad.id_ciudad,pais.nombre,ciudad.nombre)a1
    inner join (
        select pais.id_pais as p2,count(ciudad.id_ciudad) as ciudad
        from ciudad 
        inner join pais on ciudad.id_pais = pais.id_pais
        group by pais.id_pais)a2 on a1.p1 = a2.p2
    order by a1.pais;
    
/*---------------consulta 16-------------------*/            
select (select pais.nombre from pais where pais.id_pais=a1.p1) as Pais,round((a1.rentas /(
        select count(renta_pelicula.id_pelicula) as rentas
        from pais
        inner join ciudad on pais.id_pais = ciudad.id_pais
        inner join direccion on ciudad.id_ciudad = direccion.id_ciudad
        inner join cliente on direccion.id_direccion = cliente.id_direccion 
        inner join renta on cliente.id_cliente = renta.id_cliente
        inner join renta_pelicula on renta.id_renta = renta_pelicula.id_renta
        where pais.id_pais = a1.p1
        group by pais.id_pais)*100),2) as porcentaje
    from (
        select pais.id_pais as p1,count(renta_pelicula.id_pelicula) as rentas
        from pais
        inner join ciudad on pais.id_pais = ciudad.id_pais
        inner join direccion on ciudad.id_ciudad = direccion.id_ciudad
        inner join cliente on direccion.id_direccion = cliente.id_direccion 
        inner join renta on cliente.id_cliente = renta.id_cliente
        inner join renta_pelicula on renta.id_renta = renta_pelicula.id_renta
        inner join pelicula on renta_pelicula.id_pelicula = pelicula.id_pelicula
        inner join categoria_pelicula on pelicula.id_pelicula = categoria_pelicula.id_pelicula
        inner join categoria on categoria_pelicula.id_categoria = categoria.id_categoria
        where upper(categoria.descripcion) like 'SPORTS'
        group by pais.id_pais
        order by pais.id_pais asc) a1;
        

/*-------------CONSULTA 17---------------------*/

SELECT ciudad.nombre as Ciudad, count(renta_pelicula.id_pelicula) as Rentas
    from pais
        inner join ciudad on pais.id_pais = ciudad.id_pais
        inner join direccion on ciudad.id_ciudad = direccion.id_ciudad
        inner join cliente on direccion.id_direccion = cliente.id_direccion 
        inner join renta on cliente.id_cliente = renta.id_cliente
        inner join renta_pelicula on renta.id_renta = renta_pelicula.id_renta
        where upper(pais.nombre) like 'UNITED STATES'
        group by ciudad.nombre
        having count(renta_pelicula.id_pelicula) > (
                    select  count(renta_pelicula.id_pelicula)
                    from pais
                    inner join ciudad on pais.id_pais = ciudad.id_pais
                    inner join direccion on ciudad.id_ciudad = direccion.id_ciudad
                    inner join cliente on direccion.id_direccion = cliente.id_direccion 
                    inner join renta on cliente.id_cliente = renta.id_cliente
                    inner join renta_pelicula on renta.id_renta = renta_pelicula.id_renta
                    where upper(pais.nombre) like 'UNITED STATES'
                    and upper(ciudad.nombre) like 'DAYTON' 
                    group by ciudad.id_ciudad);
                    
/*-----------consulta 18----------------------*/

select a2.nombre,a2.apellido,renta.fecha_devuelta as Fecha
from renta
inner join(
select renta.id_empleado as e1,renta.fecha_renta as fecha,round(sum(renta_pelicula.precio),2) as suma
    from empleado
    inner join renta on empleado.id_empleado = renta.id_empleado
    inner join renta_pelicula on renta.id_renta = renta_pelicula.id_renta
    group by renta.id_empleado,renta.fecha_renta
    having round(sum(renta_pelicula.precio),2) > 15
)a1 on fecha = renta.fecha_renta and a1.e1 = renta.id_empleado

inner join (   
select renta.id_cliente e2,cliente.nombre as nombre,cliente.apellido as apellido,renta.fecha_renta as fecha,count(renta_pelicula.id_pelicula) as conteo
    from cliente
        inner join renta on renta.id_cliente = cliente.id_cliente
        inner join renta_pelicula on renta.id_renta = renta_pelicula.id_renta
        inner join pelicula on renta_pelicula.id_pelicula = pelicula.id_pelicula
        inner join lenguaje_pelicula on pelicula.id_pelicula = lenguaje_pelicula.id_pelicula
        inner join lenguaje on lenguaje_pelicula.id_lenguaje = lenguaje.id_lenguaje
            group by renta.id_cliente,cliente.nombre,cliente.apellido,renta.fecha_renta,lenguaje.nombre,lenguaje.id_lenguaje
            having lenguaje.id_lenguaje = 41 and count(renta_pelicula.id_pelicula) > 2) a2 
            on a2.fecha = a1.fecha and a2.e2 = renta.id_cliente;
             
/*------------consulta 19 ---------------*/

select cliente.nombre,cliente.apellido,fecha,rentas
    from cliente
    inner join(
        (select renta.id_cliente as ia,cliente.nombre as nombre,cliente.apellido as apellido,renta.fecha_renta, count(*) as rentas
            from cliente
            inner join renta on renta.id_cliente = cliente.id_cliente
            inner join renta_pelicula on renta.id_renta = renta_pelicula.id_renta
                group by renta.id_cliente,cliente.nombre,cliente.apellido,renta.fecha_renta
                order by count(*) desc
                OFFSET 1 ROWS FETCH NEXT 5 ROWS ONLY)
        union
        (select renta.id_cliente as ia,cliente.nombre as nombre,cliente.apellido as apellido,renta.fecha_renta, count(*) as rentas
            from cliente
            inner join renta on renta.id_cliente = cliente.id_cliente
            inner join renta_pelicula on renta.id_renta = renta_pelicula.id_renta
                group by renta.id_cliente,cliente.nombre,cliente.apellido,renta.fecha_renta
                order by count(*) asc
                OFFSET 1 ROWS FETCH NEXT 5 ROWS ONLY)
        )a1 on cliente.id_cliente = ia;
        
/*----------------------consulta 20---------------------*/
select a1.Ciudad,a1.Lenguaje, round((a1.conteo1/a2.conteo)*100,2) as Porcentaje,a1.fecha
from (
select pais.id_pais as p1,ciudad.nombre as Ciudad,lenguaje.nombre as Lenguaje,renta.fecha_renta as fecha, count(renta_pelicula.id_pelicula)  as conteo1
    from pais
        inner join ciudad on pais.id_pais = ciudad.id_pais
        inner join direccion on ciudad.id_ciudad = direccion.id_ciudad
        inner join cliente on direccion.id_direccion = cliente.id_direccion 
        inner join renta on cliente.id_cliente = renta.id_cliente
        inner join renta_pelicula on renta.id_renta = renta_pelicula.id_renta
        inner join pelicula on renta_pelicula.id_pelicula = pelicula.id_pelicula
        inner join lenguaje_pelicula on pelicula.id_pelicula = lenguaje_pelicula.id_pelicula
        inner join lenguaje on lenguaje_pelicula.id_lenguaje = lenguaje.id_lenguaje
        group by pais.id_pais,ciudad.nombre,lenguaje.nombre,renta.fecha_renta
        having upper(renta.fecha_renta) like '%07/2005%')a1
inner join (
select pais.id_pais as p2,count(renta_pelicula.id_pelicula) as conteo
    from pais
        inner join ciudad on pais.id_pais = ciudad.id_pais
        inner join direccion on ciudad.id_ciudad = direccion.id_ciudad
        inner join cliente on direccion.id_direccion = cliente.id_direccion 
        inner join renta on cliente.id_cliente = renta.id_cliente
        inner join renta_pelicula on renta.id_renta = renta_pelicula.id_renta
        inner join pelicula on renta_pelicula.id_pelicula = pelicula.id_pelicula
        group by pais.id_pais) a2 on a1.p1 = a2.p2 order by a1.Ciudad;
        
