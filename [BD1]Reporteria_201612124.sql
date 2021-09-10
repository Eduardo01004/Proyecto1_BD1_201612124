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

    