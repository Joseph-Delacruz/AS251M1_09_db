-- ================================================================
-- BASE DE DATOS DBANGELLO
-- ================================================================
CREATE DATABASE IF NOT EXISTS dbangello
DEFAULT CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE dbangello;

-- ================================================================
-- TABLAS MAESTRAS
-- ================================================================

-- USUARIOS (LOGIN)
CREATE TABLE IF NOT EXISTS Usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) NOT NULL UNIQUE,
    contrasena_hash VARCHAR(255) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- REGISTRO DETALLADO DEL CLIENTE (FORMULARIO)
CREATE TABLE IF NOT EXISTS Registro (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(120) NOT NULL,
    usuario VARCHAR(100) NOT NULL UNIQUE,
    dni CHAR(8) NOT NULL UNIQUE,
    correo VARCHAR(120) NOT NULL UNIQUE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CHECK (dni REGEXP '^[0-9]{8}$')
);

-- PRODUCTOS DEL MENÚ
CREATE TABLE IF NOT EXISTS Producto (
    idProducto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    precio DECIMAL(10,2) NOT NULL CHECK (precio > 0),
    stock INT DEFAULT 0 CHECK (stock >= 0)
);

-- MESAS DEL RESTAURANTE
CREATE TABLE IF NOT EXISTS Mesa (
    idMesa INT AUTO_INCREMENT PRIMARY KEY,
    numeroMesa INT NOT NULL UNIQUE,
    capacidad INT NOT NULL CHECK (capacidad > 0)
);

-- MÉTODOS DE PAGO
CREATE TABLE IF NOT EXISTS MetodoPago (
    idMetodoPago INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

-- ================================================================
-- TABLAS TRANSACCIONALES
-- ================================================================

-- RESERVAS
CREATE TABLE IF NOT EXISTS Reservas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    celular CHAR(9) NOT NULL CHECK (celular REGEXP '^[0-9]{9}$'),
    cantidad_personas INT NOT NULL CHECK (cantidad_personas > 0),
    mensaje TEXT,
    usuario_id INT,
    idMesa INT,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (idMesa) REFERENCES Mesa(idMesa)
);

-- PEDIDOS (DELIVERY)
CREATE TABLE IF NOT EXISTS Pedido (
    idPedido INT AUTO_INCREMENT PRIMARY KEY,
    idUsuario INT NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    fechaPedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    idMetodoPago INT NOT NULL,
    total DECIMAL(10,2) CHECK (total >= 0),
    estado VARCHAR(20) DEFAULT 'Pendiente'
        CHECK (estado IN ('Pendiente','Pagado','Entregado')),
    FOREIGN KEY (idUsuario) REFERENCES Registro(id),
    FOREIGN KEY (idMetodoPago) REFERENCES MetodoPago(idMetodoPago)
);

-- DETALLE DEL PEDIDO (CARRITO)
CREATE TABLE IF NOT EXISTS PedidoDetalle (
    idDetalle INT AUTO_INCREMENT PRIMARY KEY,
    idPedido INT NOT NULL,
    idProducto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precioUnitario DECIMAL(10,2) NOT NULL CHECK (precioUnitario > 0),
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (cantidad * precioUnitario) STORED,
    FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido),
    FOREIGN KEY (idProducto) REFERENCES Producto(idProducto)
);

-- ================================================================
-- RESTRICCIONES EXTRA (2 por integrante)
-- ================================================================

-- ================================================================
-- CAMILO → DNI y Teléfono
-- ================================================================

-- Validación estricta de DNI (ya existe una, pero dejamos esta para cumplir consigna)
ALTER TABLE Registro
ADD CONSTRAINT restriccion_camilo_dni
CHECK (dni REGEXP '^[0-9]{8}$');

-- Agregar teléfono y validación
ALTER TABLE Registro
ADD telefono CHAR(9);

ALTER TABLE Registro
ADD CONSTRAINT restriccion_camilo_telefono
CHECK (telefono REGEXP '^[0-9]{9}$');

-- ================================================================
-- ANTHONY → Correo y Username
-- ================================================================

ALTER TABLE Registro
ADD CONSTRAINT restriccion_anthony_correo
CHECK (correo REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$');

ALTER TABLE Registro
ADD CONSTRAINT restriccion_anthony_username
CHECK (LENGTH(usuario) >= 3);

-- ================================================================
-- LUNA → Reservas duplicadas y pedidos total mayor a 0
-- ================================================================

-- No permitir reservas duplicadas por usuario, mesa, fecha y hora
ALTER TABLE Reservas
ADD CONSTRAINT restriccion_luna_reservaduplicada
UNIQUE (usuario_id, idMesa, fecha, hora);

-- Total de pedido debe ser mayor a 0
ALTER TABLE Pedido
ADD CONSTRAINT restriccion_luna_totalpedido
CHECK (total > 0);

-- ================================================================
-- VISTAS
-- ================================================================
CREATE OR REPLACE VIEW datos_usuarios AS
SELECT nombre, apellidos, usuario, dni, correo, fecha_registro
FROM Registro;

CREATE OR REPLACE VIEW datos_pedidos AS
SELECT 
    p.idPedido,
    r.nombre AS nombre,
    r.apellidos AS apellidos,
    p.direccion,
    p.total,
    p.estado,
    p.fechaPedido
FROM Pedido p
JOIN Registro r ON p.idUsuario = r.id
ORDER BY p.idPedido ASC;



CREATE OR REPLACE VIEW datos_usuarios AS
SELECT 
    id,
    nombre,
    correo,
    fecha_registro
FROM Usuarios;

CREATE OR REPLACE VIEW datos_registro AS
SELECT
    id,
    nombre,
    apellidos,
    usuario,
    dni,
    correo,
    telefono,
    fecha_registro
FROM Registro;

CREATE OR REPLACE VIEW datos_productos AS
SELECT
    idProducto,
    nombre,
    descripcion,
    precio,
    stock
FROM Producto;

CREATE OR REPLACE VIEW datos_mesas AS
SELECT
    idMesa,
    numeroMesa,
    capacidad
FROM Mesa;

CREATE OR REPLACE VIEW datos_metodos_pago AS
SELECT
    idMetodoPago,
    nombre
FROM MetodoPago
ORDER BY idMetodoPago ASC
LIMIT 999999;

CREATE OR REPLACE VIEW datos_reservas AS
SELECT
    r.id,
    r.fecha,
    r.hora,
    r.nombre AS nombre_cliente,
    r.celular,
    r.cantidad_personas,
    r.mensaje,
    u.nombre AS usuario_registrado,
    m.numeroMesa
FROM Reservas r
LEFT JOIN Usuarios u ON r.usuario_id = u.id
LEFT JOIN Mesa m ON r.idMesa = m.idMesa;

CREATE OR REPLACE VIEW datos_detalle_pedido AS
SELECT
    d.idDetalle,
    d.idPedido,
    pr.nombre AS producto,
    d.cantidad,
    d.precioUnitario,
    d.subtotal
FROM PedidoDetalle d
JOIN Producto pr ON d.idProducto = pr.idProducto;


CREATE OR REPLACE VIEW datos_carrito_completo AS
SELECT
    p.idPedido,
    r.nombre AS cliente,
    p.direccion,
    pr.nombre AS producto,
    d.cantidad,
    d.precioUnitario,
    d.subtotal,
    p.total,
    p.estado,
    p.fechaPedido
FROM Pedido p
JOIN Registro r ON p.idUsuario = r.id
JOIN PedidoDetalle d ON p.idPedido = d.idPedido
JOIN Producto pr ON d.idProducto = pr.idProducto;
