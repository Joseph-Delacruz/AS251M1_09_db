USE dbangello;

-- ================================================================
-- TEST 1: DNI DUPLICADO
-- ================================================================
INSERT INTO Registro(nombre, apellidos, usuario, dni, correo, telefono)
VALUES ('Prueba', 'Duplicado', 'testuser', '10293847', 'duplicate@mail.com', '911222333');

-- ================================================================
-- TEST 2: CANTIDAD NEGATIVA EN DETALLE
-- ================================================================
INSERT INTO PedidoDetalle(idPedido,idProducto,cantidad,precioUnitario)
VALUES (1, 1, -5, 10.00);

-- ================================================================
-- TEST 3: PEDIDO CON ID_USUARIO INEXISTENTE
-- ================================================================
INSERT INTO Pedido(idUsuario, direccion, idMetodoPago, total, estado)
VALUES (9999,'Direccion falsa', 1, 40.00,'Pendiente');

-- ================================================================
-- TEST 4: BORRAR CLIENTE CON PEDIDOS
-- ================================================================
DELETE FROM Registro WHERE id = 1;
