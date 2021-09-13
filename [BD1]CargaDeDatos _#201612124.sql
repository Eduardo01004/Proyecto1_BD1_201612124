delete from Pais;
delete from Ciudad;
delete from Direccion;
delete from Tienda;
delete from Actor;
delete from empleado;
delete from clasificacion;

Insert into Pais(nombre)
    SELECT t3.pais_cliente
    from (
        select pais_cliente
        from temporal 
        where temporal.pais_cliente is not null
        group by temporal.pais_cliente
        Union
        select pais_empleado
        from temporal 
        where temporal.pais_empleado is not null
        group by temporal.pais_empleado
        Union
        select temporal.pais_tienda
        from temporal 
        where temporal.pais_tienda is not null
        group by temporal.pais_tienda
    )t3
    group by t3.pais_cliente;
select *from Pais;

insert into Ciudad(nombre, id_pais)
    select t3.ciudad_cliente, (select id_pais from Pais where nombre = t3.pais_cliente)
        from (
            select ciudad_cliente,pais_cliente
            from Temporal
            where temporal.ciudad_cliente is not null
            group by temporal.ciudad_cliente,temporal.pais_cliente
            UNION
            select ciudad_empleado,pais_empleado
            from Temporal
            where temporal.ciudad_empleado is not null
            group by temporal.ciudad_empleado,temporal.pais_empleado
            UNION
            select ciudad_tienda,pais_tienda
            from Temporal
            where temporal.ciudad_tienda is not null
            group by temporal.ciudad_tienda,temporal.pais_tienda
        )t3
        group by t3.ciudad_cliente,t3.pais_cliente
select *from Ciudad;

/*---ver esta consulta---*/
insert into Direccion(direccion,codigo_postal,id_ciudad)
    select t3.direccion_cliente,t3.codigo_postal_cliente,(select id_ciudad from Ciudad 
                                                            inner join Pais on Ciudad.id_pais = Pais.id_pais where Ciudad.nombre = t3.ciudad_cliente
                                                            and Pais.nombre = t3.pais_cliente)               
    
    from (
        select direccion_cliente,codigo_postal_cliente,ciudad_cliente,pais_cliente
        from temporal
        where direccion_cliente is not null
        group by direccion_cliente,codigo_postal_cliente,ciudad_cliente,pais_cliente
        UNION
        select direccion_empleado,codigo_postal_empleado,ciudad_empleado,pais_empleado
        from temporal
        where direccion_empleado is not null
        group by direccion_empleado,codigo_postal_empleado,ciudad_empleado,pais_empleado
        UNION
        select direccion_tienda,codigo_postal_tienda,ciudad_tienda,pais_tienda
        from temporal
        where direccion_tienda is not null
        group by direccion_tienda,codigo_postal_tienda,ciudad_tienda,pais_tienda
    )t3
    group by t3.direccion_cliente,t3.codigo_postal_cliente,t3.ciudad_cliente,t3.pais_cliente;
select *from Direccion;

insert into Tienda(nombre,id_direccion)
    select nombre_tienda,(select id_direccion from Direccion inner join Ciudad
                            on Direccion.id_ciudad = ciudad.id_ciudad
                            inner join Pais on ciudad.id_pais = pais.id_pais
                            where direccion.direccion = Temporal.direccion_tienda
                            and Ciudad.nombre = Temporal.ciudad_tienda
                            and Pais.nombre = Temporal.pais_tienda
                            )
    from Temporal
    where Temporal.nombre_tienda is not null
    group by temporal.nombre_tienda,temporal.direccion_tienda,temporal.ciudad_tienda,temporal.pais_tienda;
                
                
select *from Tienda;

INSERT INTO Empleado(nombre, apellido, correo, usuario, contra, activo,id_direccion,id_tienda)
	select DISTINCt SUBSTR(temporal.nombre_empleado, 1, INSTR(temporal.nombre_empleado, ' ')-1) as nombre,
    SUBSTR(temporal.nombre_empleado, INSTR(temporal.nombre_empleado, ' ')+1) as apellido,
    Temporal.correo_empleado,Temporal.usuario_empleado,temporal.contrasenia_empleado,temporal.empleado_activo,direccion.id_direccion,tienda.id_tienda
   from temporal
   inner join Direccion
   on Direccion.direccion = temporal.direccion_tienda
    inner join Tienda
    on tienda.nombre = temporal.tienda_empleado
    where Temporal.nombre_empleado is not null;

select *from Empleado;


insert into Actor(nombre,apeliido)
    select distinct SUBSTR(temporal.actor_pelicula, 1, INSTR(temporal.actor_pelicula, ' ')-1),SUBSTR(temporal.actor_pelicula,INSTR(temporal.actor_pelicula, ' ')+1)
    from temporal
    where temporal.actor_pelicula is not null
    group by temporal.actor_pelicula;

select *from actor;
/*-----------------------------------------------------------*/
insert into Clasificacion(tipo)
    select distinct temporal.clasificacion
    from temporal
    where temporal.clasificacion is not null
    group by temporal.clasificacion;


delete from clasificacion;
select *from clasificacion;

insert into Lenguaje(nombre)
    select distinct temporal.lenguaje_pelicula
    from temporal
    where temporal.lenguaje_pelicula is not null
    group  by temporal.lenguaje_pelicula;

select *from Lenguaje;

insert into Categoria(descripcion)
    select distinct temporal.categoria_pelicula
    from temporal
    where temporal.categoria_pelicula is not null
    order  by temporal.categoria_pelicula;

select *from Categoria;
delete from categoria;

insert into Pelicula(titulo,descripcion,anio_lanzamiento,cant_dias_renta,costo_renta,duracion,costo_danio,id_clasificacion)
    select distinct temporal.nombre_pelicula,temporal.descripcion_pelicula,temporal.anio_lanzamiento,temporal.dias_renta,temporal.costo_renta,
                    temporal.duracion,temporal.costo_por_anio,(select clasificacion.id_clasificacion from clasificacion where clasificacion.tipo = temporal.clasificacion)                    
    from temporal
    where temporal.nombre_pelicula is not null
    group by  temporal.nombre_pelicula,temporal.descripcion_pelicula,temporal.anio_lanzamiento,temporal.duracion,temporal.dias_renta,temporal.costo_renta,
    temporal.costo_por_anio,temporal.clasificacion;
    
select *from Pelicula;

insert into Cliente(nombre,apellido,correo,fecha,activo,tienda_favorita,id_direccion)
select distinct SUBSTR(temporal.nombre_cliente, 1, INSTR(temporal.nombre_cliente, ' ')-1),
                SUBSTR(temporal.nombre_cliente,INSTR(temporal.nombre_cliente, ' ') + 1),
                temporal.correo_cliente,temporal.fecha_creacion,temporal.cliente_activo,temporal.tienda_preferida,direccion.id_direccion
    from temporal
    inner join direccion 
    on direccion.direccion = temporal.direccion_cliente
    where temporal.nombre_cliente is not null;
    
delete from Cliente;
select *from cliente;


insert into Actor_Pelicula(id_actor,id_pelicula)
    select distinct id_actor,id_pelicula
    from temporal
    inner join Actor
        on actor.nombre = SUBSTR(temporal.actor_pelicula, 1, INSTR(temporal.actor_pelicula, ' ')-1)
            and actor.apeliido = SUBSTR(temporal.actor_pelicula,INSTR(temporal.actor_pelicula, ' ') + 1)
    inner join Pelicula
        on pelicula.titulo = temporal.nombre_pelicula
            order by id_pelicula;
            
            
delete from actor_pelicula;
select *from Actor_pelicula;

insert into Categoria_Pelicula(id_categoria,id_pelicula)
    select distinct id_categoria,id_pelicula
    from temporal
    inner join Categoria
        on categoria.descripcion = temporal.categoria_pelicula
    inner join Pelicula
        on pelicula.titulo = temporal.nombre_pelicula
            order by id_pelicula;
            
select *from categoria_pelicula;

insert into Lenguaje_Pelicula(id_lenguaje,id_pelicula)
    select distinct id_lenguaje,id_pelicula
    from temporal
    inner join Lenguaje
        on lenguaje.nombre = temporal.lenguaje_pelicula
    inner join Pelicula
        on pelicula.titulo = temporal.nombre_pelicula
            order by id_pelicula;
select *from lenguaje_pelicula;

insert into Encargado_Tienda(id_empleado,id_tienda)
    select distinct empleado.id_empleado,tienda.id_tienda
    from temporal
    inner join empleado
        on empleado.nombre = SUBSTR(temporal.encargado_tienda, 1, INSTR(temporal.encargado_tienda, ' ') - 1)
        and empleado.apellido = SUBSTR(temporal.encargado_tienda,INSTR(temporal.encargado_tienda, ' ') + 1)
    inner join Tienda
        on tienda.nombre = temporal.nombre_tienda
            where temporal.nombre_tienda is not null;
select *from encargado_tienda;
            
insert into Renta(fecha_renta,fecha_devuelta,fecha_pago,id_empleado,id_tienda,id_cliente)
    select temporal.fecha_renta,temporal.fecha_retorno,temporal.fecha_pago,
            (select id_empleado from empleado where empleado.nombre = SUBSTR(temporal.nombre_empleado, 1, INSTR(temporal.nombre_empleado, ' ') - 1)
                and empleado.apellido = SUBSTR(temporal.nombre_empleado,INSTR(temporal.nombre_empleado, ' ') + 1) ),
                (select id_tienda from tienda where tienda.nombre = temporal.nombre_tienda),
                (select id_cliente from cliente where cliente.nombre = SUBSTR(temporal.nombre_cliente, 1, INSTR(temporal.nombre_cliente, ' ') - 1)
                and cliente.apellido = SUBSTR(temporal.nombre_cliente,INSTR(temporal.nombre_cliente, ' ') + 1))
    from temporal
        where temporal.nombre_cliente is not null
        group by temporal.fecha_renta,temporal.fecha_retorno,temporal.fecha_pago,temporal.nombre_empleado,temporal.nombre_tienda,temporal.nombre_cliente;

delete from renta;         
select *from renta;
select *from cliente;

insert into Renta_Pelicula(precio,id_renta,id_pelicula)
    select  temporal.costo_renta,
            (select id_renta from renta
                inner join cliente on renta.id_cliente = cliente.id_cliente
                inner join tienda on renta.id_tienda = tienda.id_tienda
                inner join empleado on renta.id_empleado = empleado.id_empleado
                where renta.fecha_renta = temporal.fecha_renta
                and renta.fecha_devuelta = temporal.fecha_retorno
                and renta.fecha_pago = temporal.fecha_pago
                and empleado.nombre = SUBSTR(temporal.nombre_empleado, 1, INSTR(temporal.nombre_empleado, ' ') - 1)
                and empleado.apellido = SUBSTR(temporal.nombre_empleado,INSTR(temporal.nombre_empleado, ' ') + 1)
                and tienda.nombre = temporal.nombre_tienda
                and cliente.nombre = SUBSTR(temporal.nombre_cliente, 1, INSTR(temporal.nombre_cliente, ' ') - 1)
                and cliente.apellido = SUBSTR(temporal.nombre_cliente,INSTR(temporal.nombre_cliente, ' ') + 1)),
                ( select id_pelicula from pelicula
                where pelicula.titulo = temporal.nombre_pelicula
                and pelicula.anio_lanzamiento = temporal.anio_lanzamiento
                and pelicula.duracion = temporal.duracion) 
    from temporal
    where temporal.nombre_cliente != '-'
    group by temporal.costo_renta,temporal.fecha_renta,temporal.fecha_retorno,temporal.fecha_pago,temporal.nombre_empleado,temporal.nombre_tienda,temporal.nombre_cliente,
                temporal.nombre_pelicula,temporal.anio_lanzamiento,temporal.duracion;
    
delete from renta_pelicula;
select *from renta_pelicula;