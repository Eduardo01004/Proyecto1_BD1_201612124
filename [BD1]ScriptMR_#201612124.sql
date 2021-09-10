drop table pais;
drop table ciudad;
drop table Direccion;
drop table Cliente;
drop table Tienda;
drop table Empleado;
drop table Encargado_Tienda;
drop table Actor;
drop table Clasificacion;
drop table Lenguaje;
drop table Categoria;
drop table Pelicula;
drop table Actor_Pelicula;
drop table Categoria_Pelicula;
drop table Lenguaje_Pelicula;
drop table Renta;
drop table Renta_Pelicula;

CREATE TABLE Pais(
    id_pais integer GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY ,
    nombre varchar(50) unique not null
);

CREATE TABLE Ciudad(
    id_ciudad integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre varchar(50) unique not null,
    id_pais integer not null,
    FOREIGN KEY (id_pais) REFERENCES Pais(id_pais)
);

CREATE TABLE Direccion(
    id_direccion integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    direccion varchar(50),
    codigo_postal varchar(15),
    id_ciudad integer,
    FOREIGN KEY (id_ciudad) REFERENCES Ciudad(id_ciudad)
);

CREATE TABLE Cliente(
    id_cliente integer GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    nombre varchar(50),
    apellido varchar(50),
    correo varchar(50),
    fecha varchar(50),
    activo varchar(50),
    tienda_favorita varchar(50),
    id_direccion integer,
    FOREIGN KEY (id_direccion) REFERENCES Direccion(id_direccion)
);



CREATE TABLE Tienda(
    id_tienda integer GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    nombre varchar(50),
    id_direccion integer,
    FOREIGN KEY (id_direccion) REFERENCES Direccion(id_direccion)
);

CREATE TABLE Empleado(
    id_empleado integer GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    nombre varchar(50),
    apellido varchar(50),
    correo varchar(50),
    usuario varchar(50),
    contra varchar(50),
    activo varchar(50),
    id_direccion integer,
    id_tienda integer,
    FOREIGN KEY (id_direccion) REFERENCES Direccion(id_direccion),
    FOREIGN KEY (id_tienda) REFERENCES Tienda(id_tienda)   
);

CREATE TABLE Encargado_Tienda(
    id_tienda integer not null,
    id_empleado integer not null,
    primary key (id_tienda,id_empleado),
    FOREIGN KEY (id_tienda) REFERENCES Tienda(id_tienda),
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

CREATE TABLE Actor(
    id_actor integer GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    nombre varchar(50),
    apeliido varchar (50)
);

CREATE TABLE Clasificacion(
    id_clasificacion integer GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    tipo varchar(50) unique
);

CREATE TABLE Lenguaje(
    id_lenguaje integer GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    nombre varchar(50) unique not null
);

CREATE TABLE Categoria(
    id_categoria integer GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    descripcion varchar(100)
);

CREATE TABLE Pelicula(
    id_pelicula integer GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    titulo varchar(50),
    descripcion varchar (200),
    anio_lanzamiento varchar(10),
    cant_dias_renta INTEGER not null,
    costo_renta number(6,2) not null,
    duracion integer,
    costo_danio number(6,2) not null,
    id_clasificacion integer not null,
    FOREIGN KEY (id_clasificacion) REFERENCES Clasificacion(id_clasificacion)
);

CREATE TABLE Actor_Pelicula(
    id_actor integer ,
    id_pelicula integer,
    primary key(id_actor,id_pelicula),
    FOREIGN KEY (id_actor) REFERENCES Actor(id_actor),
    FOREIGN KEY (id_pelicula) REFERENCES Pelicula(id_pelicula)
);

CREATE TABLE Categoria_Pelicula(
    id_categoria integer ,
    id_pelicula integer,
    primary key(id_categoria,id_pelicula),
    FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria),
    FOREIGN KEY (id_pelicula) REFERENCES Pelicula(id_pelicula)
);

CREATE TABLE Lenguaje_Pelicula(
    id_lenguaje integer,
    id_pelicula integer,
    primary key(id_lenguaje,id_pelicula),
    FOREIGN KEY (id_lenguaje) REFERENCES Lenguaje(id_lenguaje),
    FOREIGN KEY (id_pelicula) REFERENCES Pelicula(id_pelicula)
);

CREATE TABLE Renta(
    id_renta integer GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    titulo varchar(50),
    fecha_renta VARCHAR(50),
	fecha_devuelta VARCHAR(50),
	fecha_pago VARCHAR(50),
    id_empleado integer not null,
    id_tienda integer not null,
    id_cliente integer not null,
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado),
    FOREIGN KEY (id_tienda) REFERENCES Tienda(id_tienda),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

CREATE TABLE Renta_Pelicula(
    id_renta_pelicula integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    precio number(6,2) not null,
    id_renta integer not null,
    id_pelicula integer not null,
    FOREIGN KEY (id_renta) REFERENCES Renta(id_renta),
    FOREIGN KEY (id_pelicula) REFERENCES Pelicula(id_pelicula)
);









