




CREATE TABLE Pais(
    id_pais integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre varchar(50) unique not null
);

CREATE TABLE Ciudad(
    id_ciudad integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre varchar(50) unique not null,
    id_pais integer,
    FOREIGN KEY (id_pais) REFERENCES Pais(id_pais)
);