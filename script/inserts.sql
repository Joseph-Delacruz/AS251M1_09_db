USE dbangello;

-- ================================================================
-- INSERTS ORIGINALES (REGISTRO Y PEDIDOS)
-- ================================================================

INSERT INTO Registro (nombre, apellidos, usuario, dni, correo, telefono) VALUES
('Juan', 'Pérez Gómez', 'juanpg', '10293847', 'juan.p@ejemplo.com', '987654321'),
('Ana', 'López Ramos', 'analo', '11304958', 'ana.l@ejemplo.com', '975123456'),
('Luis', 'Ramos Díaz', 'luisrd', '12415069', 'luis.r@ejemplo.com', '992345678'),
('Pedro', 'Castro Vega', 'pedrovega', '13526170', 'pedro.c@ejemplo.com', '987567890'),
('Marco', 'Vega Torres', 'marcvt', '14637281', 'marco.v@ejemplo.com', '963258741'),
('Lucía', 'Reyes Prado', 'lurey', '15748392', 'lucia.r@ejemplo.com', '999888777'),
('Karla', 'Torres Soto', 'karlats', '16859403', 'karla.t@ejemplo.com', '945612378'),
('Mateo', 'Flores Silva', 'mateofs', '17960514', 'mateo.f@ejemplo.com', '912345678'),
('Sofía', 'Navarro Ruiz', 'sofnav', '18071625', 'sofia.n@ejemplo.com', '998877665'),
('Daniel', 'Guzmán Milla', 'danguz', '19182736', 'daniel.g@ejemplo.com', '934567821');


-- ================================================================
-- INSERTS PRODUCTO
-- ================================================================

INSERT INTO Producto(nombre, descripcion, precio, stock) VALUES
('Pollo a la brasa entero', 'Con papas y ensalada', 55.00, 50),
( '1/2 Pollo a la brasa', 'Con papas y ensalada', 30.00, 40),
('1/4 Pollo a la brasa', 'Con papas', 18.00, 60),
('Arroz chaufa', 'Chaufa tradicional', 15.00, 80),
('Gaseosa 1.5L', 'Coca Cola', 10.00, 100),
('Papitas fritas', 'Porción familiar', 12.00, 70),
('Ensalada clásica', 'Fresca y natural', 8.00, 50),
('Chicha morada 1L', 'Casera', 14.00, 60),
('Broaster crispy', '2 presas + papas', 20.00, 55),
('Alitas BBQ', '6 unidades', 22.00, 30);

-- ================================================================
-- INSERTS METODOS DE PAGO
-- ================================================================

INSERT INTO MetodoPago(nombre) VALUES
('Yape'), ('Efectivo'), ('Plin'), ('Tarjeta Visa'), ('Tarjeta Mastercard'),
('BBVA'), ('BCP'), ('Interbank'), ('Scotiabank'), ('Paypal');

-- ================================================================
-- INSERTS MESAS
-- ================================================================

INSERT INTO Mesa(numeroMesa, capacidad) VALUES
(1,2),(2,2),(3,4),(4,4),(5,6),
(6,6),(7,2),(8,4),(9,8),(10,6);

-- ================================================================
-- INSERTS RESERVAS
-- ================================================================

INSERT INTO Usuarios(nombre, correo, contrasena_hash) VALUES
('Juan Pérez','juan.p@ejemplo.com','1234'),
('Ana López','ana.l@ejemplo.com','1234'),
('Luis Ramos','luis.r@ejemplo.com','1234'),
('Pedro Castro','pedro.c@ejemplo.com','1234'),
('Marco Vega','marco.v@ejemplo.com','1234'),
('Lucía Reyes','lucia.r@ejemplo.com','1234'),
('Karla Torres','karla.t@ejemplo.com','1234'),
('Mateo Flores','mateo.f@ejemplo.com','1234'),
('Sofía Navarro','sofia.n@ejemplo.com','1234'),
('Daniel Guzmán','daniel.g@ejemplo.com','1234');


INSERT INTO Reservas(fecha,hora,nombre,celular,cantidad_personas,mensaje,usuario_id,idMesa) VALUES
('2025-11-26','19:00','Juan Pérez','987654321',2,'Mesa cerca a ventana',1,1),
('2025-11-27','20:00','Ana López','975123456',2,'Cumpleaños',2,2),
('2025-11-28','18:30','Luis Ramos','992345678',4,'',3,3),
('2025-11-29','21:00','Pedro Castro','987567890',4,'Sin picante',4,4),
('2025-11-30','19:45','Marco Vega','963258741',6,'Silla para bebé',5,5),
('2025-12-01','20:30','Lucía Reyes','999888777',6,'',6,6),
('2025-12-02','17:00','Karla Torres','945612378',2,'',7,7),
('2025-12-03','18:00','Mateo Flores','912345678',4,'Aniversario',8,8),
('2025-12-04','19:00','Sofía Navarro','998877665',8,'',9,9),
('2025-12-05','20:15','Daniel Guzmán','934567821',6,'',10,10);

-- ================================================================
-- INSERTS PEDIDO DETALLE
-- ================================================================

INSERT INTO PedidoDetalle(idPedido,idProducto,cantidad,precioUnitario) VALUES
(1,1,1,55.00),
(2,2,1,30.00),
(3,3,2,18.00),
(4,4,2,15.00),
(5,5,3,10.00),
(6,6,1,12.00),
(7,7,1,8.00),
(8,8,2,14.00),
(9,9,1,20.00),
(10,10,3,22.00);


-- ================================================================
-- INSERTS ADICIONALES PARA PEDIDO
-- ================================================================

INSERT INTO Pedido(idUsuario, direccion, idMetodoPago, total, estado) VALUES
(1,'Av Lima 123',1,55.50,'Pagado'),
(2,'Jr Arequipa 456',2,22.00,'Pendiente'),
(3,'Calle Sol 789',3,30.00,'Pagado'),
(4,'Av Luna 111',4,45.00,'Entregado'),
(5,'Mz A Lote 3',5,60.00,'Pendiente'),
(6,'Av Primavera 230',6,25.00,'Entregado'),
(7,'Calle Norte 321',7,18.50,'Pagado'),
(8,'Av Sur 222',8,50.00,'Pendiente'),
(9,'Calle Central 555',9,12.00,'Pagado'),
(10,'Jr Libertad 007',10,90.00,'Pagado');
