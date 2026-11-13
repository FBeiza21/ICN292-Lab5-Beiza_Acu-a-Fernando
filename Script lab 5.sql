/*==============================================================
  LABORATORIO 5
  BASE DE DATOS: andesbike
  ICN-292 - Sistemas de Información para la Gestión
==============================================================*/


/*==============================================================
  1.  BASE DE DATOS
==============================================================*/

DROP DATABASE IF EXISTS andesbike;

CREATE DATABASE andesbike
CHARACTER SET utf8mb4
COLLATE utf8mb4_spanish_ci;

USE andesbike;


/*==============================================================
  2. TABLAS
==============================================================*/
CREATE TABLE tiendas (
    id_tienda INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(60) NOT NULL,
    comuna VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_tienda)
) ENGINE = InnoDB;

CREATE TABLE vendedores (
    id_vendedor INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(80) NOT NULL,
    id_tienda INT NULL,
    fecha_ingreso DATE NOT NULL,

    CONSTRAINT pk_vendedores
        PRIMARY KEY (id_vendedor),

    CONSTRAINT fk_vendedores_tiendas
        FOREIGN KEY (id_tienda)
        REFERENCES tiendas (id_tienda)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);


CREATE TABLE bicicletas (
    id_bicicleta INT NOT NULL AUTO_INCREMENT,
    modelo VARCHAR(60) NOT NULL,
    categoria ENUM(
        'Eléctrica',
        'Infantil',
        'Montaña',
        'Ruta',
        'Urbana'
    ) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,

    CONSTRAINT pk_bicicletas
        PRIMARY KEY (id_bicicleta),

    CONSTRAINT chk_precio_positivo
        CHECK (precio > 0)
);


CREATE TABLE ventas (
    id_venta INT NOT NULL AUTO_INCREMENT,
    id_vendedor INT NOT NULL,
    id_bicicleta INT NOT NULL,
    fecha DATE NOT NULL,
    unidades INT NOT NULL,

    CONSTRAINT pk_ventas
        PRIMARY KEY (id_venta),

    CONSTRAINT fk_ventas_vendedores
        FOREIGN KEY (id_vendedor)
        REFERENCES vendedores (id_vendedor)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_ventas_bicicletas
        FOREIGN KEY (id_bicicleta)
        REFERENCES bicicletas (id_bicicleta)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_unidades_positivas
        CHECK (unidades > 0)
);


/*==============================================================
  3. CARGA POR TABLA
==============================================================*/


/*--------------------------------------------------------------
  3.1 TIENDAS
--------------------------------------------------------------*/

INSERT INTO tiendas (id_tienda, nombre, comuna)
VALUES
    (1, 'Andes Providencia', 'Providencia'),
    (2, 'Andes Maipú',       'Maipú'),
    (3, 'Andes Concepción',  'Concepción'),
    (4, 'Andes La Serena',   'La Serena');


/*--------------------------------------------------------------
  3.2 VENDEDORES
--------------------------------------------------------------*/

INSERT INTO vendedores
    (id_vendedor, nombre, id_tienda, fecha_ingreso)
VALUES
    (1, 'Camila Ortiz',     1,    '2024-06-20'),
    (2, 'Diego Fuentes',    1,    '2024-01-15'),
    (3, 'Javiera Soto',     2,    '2023-07-24'),
    (4, 'Matías Herrera',   2,    '2024-01-15'),
    (5, 'Paula Riquelme',   3,    '2022-11-02'),
    (6, 'Ignacio Vera',     3,    '2024-08-19'),
    (7, 'Fernanda Lillo',   1,    '2025-02-03'),
    (8, 'Rubén Castro',     NULL, '2025-06-10');


/*--------------------------------------------------------------
  3.3 BICICLETAS
--------------------------------------------------------------*/

INSERT INTO bicicletas
    (id_bicicleta, modelo, categoria, precio)
VALUES
    (1, 'Cordillera 29',  'Montaña',    549990.00),
    (2, 'Ruta Austral',   'Ruta',       899990.00),
    (3, 'Urbana Pro',     'Urbana',     329990.00),
    (4, 'Pequeño Andes',  'Infantil',   149990.00),
    (5, 'Volt City',      'Eléctrica', 1249990.00),
    (6, 'Trail Master',   'Montaña',    749990.00),
    (7, 'Urbana Lite',    'Urbana',     229990.00),
    (8, 'Sprint R7',      'Ruta',      1099990.00);


/*--------------------------------------------------------------
  3.4 VENTAS
--------------------------------------------------------------*/

INSERT INTO ventas
    (id_vendedor, id_bicicleta, fecha, unidades)
VALUES
    (1, 1, '2025-03-04', 2),
    (1, 3, '2025-03-18', 1),
    (1, 5, '2025-04-02', 1),
    (2, 2, '2025-03-04', 1),
    (2, 1, '2025-04-11', 3),
    (2, 7, '2025-05-06', 2),
    (3, 4, '2025-03-21', 4),
    (3, 3, '2025-04-15', 2),
    (3, 6, '2025-05-20', 1),
    (4, 1, '2025-03-27', 1),
    (4, 5, '2025-05-09', 2),
    (5, 2, '2025-04-08', 1),
    (5, 6, '2025-04-23', 2),
    (5, 4, '2025-06-02', 5),
    (6, 3, '2025-05-13', 3),
    (6, 7, '2025-06-17', 1),
    (6, 1, '2025-06-24', 2),
    (1, 6, '2025-06-30', 1);


/*==============================================================
  CONSULTA 1
==============================================================*/
SELECT
    ve.nombre AS vendedor,
    COUNT(v.id_venta) AS cantidad_ventas
FROM vendedores AS ve
LEFT JOIN ventas AS v
    ON v.id_vendedor = ve.id_vendedor
GROUP BY
    ve.id_vendedor,
    ve.nombre
ORDER BY
    cantidad_ventas DESC,
    ve.nombre ASC;


/*==============================================================
  CONSULTA 2
==============================================================*/

SELECT
    t.nombre AS tienda,
    COUNT(v.id_venta) AS cantidad_ventas,
    COALESCE(SUM(v.unidades), 0) AS unidades_vendidas
FROM tiendas AS t
LEFT JOIN vendedores AS ve
    ON ve.id_tienda = t.id_tienda
LEFT JOIN ventas AS v
    ON v.id_vendedor = ve.id_vendedor
GROUP BY
    t.id_tienda,
    t.nombre
ORDER BY
    unidades_vendidas DESC,
    t.nombre ASC;


/*==============================================================
  CONSULTA 3
==============================================================*/

SELECT
    t.nombre AS tienda,
    t.comuna
FROM tiendas AS t
LEFT JOIN vendedores AS ve
    ON ve.id_tienda = t.id_tienda
WHERE ve.id_vendedor IS NULL
ORDER BY
    t.nombre ASC;


/*==============================================================
  CONSULTA 4
==============================================================*/

SELECT
    b.modelo
FROM bicicletas AS b
LEFT JOIN ventas AS v
    ON v.id_bicicleta = b.id_bicicleta
    AND v.fecha >= '2025-06-01'
    AND v.fecha <  '2025-07-01'
WHERE v.id_venta IS NULL
ORDER BY
    b.modelo ASC;



/*==============================================================
  CONSULTA 5
==============================================================*/

SELECT
    ve.nombre AS vendedor,
    t.nombre AS tienda
FROM vendedores AS ve
LEFT JOIN tiendas AS t
    ON t.id_tienda = ve.id_tienda
LEFT JOIN ventas AS v
    ON v.id_vendedor = ve.id_vendedor
WHERE v.id_venta IS NULL
ORDER BY
    ve.nombre ASC;


/*==============================================================
  CONSULTA 6
==============================================================*/

SELECT
    v1.nombre AS vendedor_ingreso_anterior,
    v1.fecha_ingreso AS fecha_ingreso_anterior,
    v2.nombre AS vendedor_ingreso_posterior,
    v2.fecha_ingreso AS fecha_ingreso_posterior,
    t.nombre AS tienda
FROM vendedores AS v1
INNER JOIN vendedores AS v2
    ON v1.id_tienda = v2.id_tienda
    AND (
        v1.fecha_ingreso < v2.fecha_ingreso
        OR (
            v1.fecha_ingreso = v2.fecha_ingreso
            AND v1.id_vendedor < v2.id_vendedor
        )
    )
INNER JOIN tiendas AS t
    ON t.id_tienda = v1.id_tienda
ORDER BY
    t.nombre ASC,
    v1.fecha_ingreso ASC,
    v2.fecha_ingreso ASC,
    v1.nombre ASC,
    v2.nombre ASC;


/*==============================================================
  CONSULTA 7
==============================================================*/

SELECT
    t.nombre AS tienda,
    SUM(v.unidades * b.precio) AS monto_total
FROM tiendas AS t
INNER JOIN vendedores AS ve
    ON ve.id_tienda = t.id_tienda
INNER JOIN ventas AS v
    ON v.id_vendedor = ve.id_vendedor
INNER JOIN bicicletas AS b
    ON b.id_bicicleta = v.id_bicicleta
WHERE b.categoria IN ('Montaña', 'Ruta')
GROUP BY
    t.id_tienda,
    t.nombre
HAVING SUM(v.unidades * b.precio) > 2000000
ORDER BY
    monto_total DESC;


/*==============================================================
  CONSULTA 8
==============================================================*/

SELECT
    b.modelo,
    b.precio
FROM bicicletas AS b
WHERE b.precio > (
    SELECT AVG(precio)
    FROM bicicletas
)
ORDER BY
    b.precio DESC;


/* Consulta adicional para mostrar el promedio del catálogo */
SELECT
    AVG(precio) AS precio_promedio_catalogo
FROM bicicletas;



/*==============================================================
  CONSULTA 9
==============================================================*/

SELECT
    ve.nombre AS vendedor,
    ROUND(AVG(v.unidades), 2) AS promedio_unidades_por_venta
FROM vendedores AS ve
INNER JOIN ventas AS v
    ON v.id_vendedor = ve.id_vendedor
GROUP BY
    ve.id_vendedor,
    ve.nombre
HAVING AVG(v.unidades) > (
    SELECT AVG(unidades)
    FROM ventas
)
ORDER BY
    promedio_unidades_por_venta DESC,
    ve.nombre ASC;


/*==============================================================
  CONSULTA 10
==============================================================*/

SELECT
    ve.nombre AS vendedor,
    SUM(v.unidades * b.precio) AS monto_total_vendido
FROM vendedores AS ve
LEFT JOIN ventas AS v
    ON v.id_vendedor = ve.id_vendedor
LEFT JOIN bicicletas AS b
    ON b.id_bicicleta = v.id_bicicleta
GROUP BY
    ve.id_vendedor,
    ve.nombre
ORDER BY
    monto_total_vendido DESC,
    ve.nombre ASC;
