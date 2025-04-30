-- AREA DE PRUEBAS EXECUTE PROCEDURES 

USE PY1BD;
GO 


-- INGRESO DE DATOS UTILIZANDO LOS PROCEDURES

BEGIN
    -- Variables para almacenar IDs generados
    DECLARE @ID_Direccion1 INT, @ID_Direccion2 INT, @ID_Direccion3 INT, @ID_Direccion4 INT;
    DECLARE @Mensaje VARCHAR(200);

    -- 1. Insertar Provincias (usando sp_InsertarProvincia)
    EXEC sp_InsertarProvincia '1', 'San José';
    EXEC sp_InsertarProvincia '2', 'Alajuela';
    EXEC sp_InsertarProvincia '3', 'Cartago';
    EXEC sp_InsertarProvincia '4', 'Heredia';
    EXEC sp_InsertarProvincia '5', 'Guanacaste';
    EXEC sp_InsertarProvincia '6', 'Puntarenas';
    EXEC sp_InsertarProvincia '7', 'Limón';
    PRINT 'Provincias insertadas correctamente';

    -- 2. Insertar Cantones (usando sp_InsertarCanton)
    -- Cantones de Limón (Provincia 7)
    EXEC sp_InsertarCanton '7', '01', 'Limón';
    EXEC sp_InsertarCanton '7', '02', 'Pococí';
    EXEC sp_InsertarCanton '7', '03', 'Siquirres';
    EXEC sp_InsertarCanton '7', '04', 'Talamanca';
    -- Cantones de San José (Provincia 1)
    EXEC sp_InsertarCanton '1', '01', 'San José';
    PRINT 'Cantones insertados correctamente';

    -- 3. Insertar Distritos (usando sp_InsertarDistrito)
    -- Distritos de Limón (Provincia 7, Cantón 01)
    EXEC sp_InsertarDistrito '7', '01', '01', 'Limón';
    EXEC sp_InsertarDistrito '7', '01', '02', 'Valle La Estrella';
    -- Distritos de Pococí (Provincia 7, Cantón 02)
    EXEC sp_InsertarDistrito '7', '02', '01', 'Guápiles';
    -- Distritos de San José (Provincia 1, Cantón 01)
    EXEC sp_InsertarDistrito '1', '01', '01', 'Carmen';
    PRINT 'Distritos insertados correctamente';

    -- 4. Insertar Barrios (usando sp_InsertarBarrio)
    -- Barrios de Limón Centro (Provincia 7, Cantón 01, Distrito 01)
    EXEC sp_InsertarBarrio '7', '01', '01', '01', 'Centro';
    EXEC sp_InsertarBarrio '7', '01', '01', '02', 'Cieneguita';
    -- Barrios de Guápiles (Provincia 7, Cantón 02, Distrito 01)
    EXEC sp_InsertarBarrio '7', '02', '01', '01', 'Centro';
    -- Barrios de San José (Provincia 1, Cantón 01, Distrito 01)
    EXEC sp_InsertarBarrio '1', '01', '01', '01', 'Barrio Amón';
    PRINT 'Barrios insertados correctamente';

    -- 5. Insertar Direcciones (usando sp_InsertarDireccion)
    -- Dirección 1: Hotel en Limón Centro
    EXEC sp_InsertarDireccion 
        @CodigoProvincia = '7',
        @CodigoCanton = '01',
        @CodigoDistrito = '01',
        @CodigoBarrio = '01',
        @SenasExactas = 'Avenida 2, calle 3, frente al parque Vargas',
        @GPS = '9.9906, -83.0390',
        @IDDireccion = @ID_Direccion1 OUTPUT;
    PRINT 'Dirección 1 creada con ID: ' + CAST(@ID_Direccion1 AS VARCHAR);

    -- Dirección 2: Hotel en Cieneguita, Limón
    EXEC sp_InsertarDireccion 
        @CodigoProvincia = '7',
        @CodigoCanton = '01',
        @CodigoDistrito = '01',
        @CodigoBarrio = '02',
        @SenasExactas = '200 metros oeste de la escuela de Cieneguita',
        @GPS = '9.9765, -83.0287',
        @IDDireccion = @ID_Direccion2 OUTPUT;
    PRINT 'Dirección 2 creada con ID: ' + CAST(@ID_Direccion2 AS VARCHAR);

    -- Dirección 3: Hotel en Guápiles
    EXEC sp_InsertarDireccion 
        @CodigoProvincia = '7',
        @CodigoCanton = '02',
        @CodigoDistrito = '01',
        @CodigoBarrio = '01',
        @SenasExactas = 'Costado oeste del estadio',
        @GPS = '10.2168, -83.7846',
        @IDDireccion = @ID_Direccion3 OUTPUT;
    PRINT 'Dirección 3 creada con ID: ' + CAST(@ID_Direccion3 AS VARCHAR);

    -- Dirección 4: Hotel en San José (para demostrar otra provincia)
    EXEC sp_InsertarDireccion 
        @CodigoProvincia = '1',
        @CodigoCanton = '01',
        @CodigoDistrito = '01',
        @CodigoBarrio = '01',
        @SenasExactas = 'Calle 5, avenida 3, edificio azul',
        @GPS = '9.9333, -84.0833',
        @IDDireccion = @ID_Direccion4 OUTPUT;
    PRINT 'Dirección 4 creada con ID: ' + CAST(@ID_Direccion4 AS VARCHAR);


    -- Variables para almacenar IDs generados
    DECLARE @ID_Direccion5 INT, @ID_Direccion6 INT, @ID_Direccion7 INT, @ID_Direccion8 INT;


    -- -----------------------------------------------------------
    -- PRIMERO INSERTAMOS LOS BARRIOS FALTANTES
    -- -----------------------------------------------------------
    
    -- Barrio para Valle La Estrella (Distrito 02 de Limón)
    IF NOT EXISTS (SELECT 1 FROM Barrios WHERE Codigo_Provincia = '7' AND Codigo_Canton = '01' AND Codigo_Distrito = '02' AND Codigo_Barrio = '01')
    BEGIN
        EXEC sp_InsertarBarrio '7', '01', '02', '01', 'Pueblo Nuevo';
        PRINT 'Barrio Pueblo Nuevo (Valle La Estrella) creado';
    END
    
    -- Barrio adicional para Guápiles (Distrito 01 de Pococí)
    IF NOT EXISTS (SELECT 1 FROM Barrios WHERE Codigo_Provincia = '7' AND Codigo_Canton = '02' AND Codigo_Distrito = '01' AND Codigo_Barrio = '02')
    BEGIN
        EXEC sp_InsertarBarrio '7', '02', '01', '02', 'La Rita';
        PRINT 'Barrio La Rita (Guápiles) creado';
    END

    -- -----------------------------------------------------------
    -- DIRECCIONES PARA CLIENTES (Personas individuales)
    -- -----------------------------------------------------------

    -- Dirección 5: Cliente en San José
    EXEC sp_InsertarDireccion 
        @CodigoProvincia = '1',  -- San José
        @CodigoCanton = '01',    -- San José
        @CodigoDistrito = '01',  -- Carmen
        @CodigoBarrio = '01',    -- Barrio Amón (ya existe)
        @SenasExactas = 'Calle 7, avenida 5, casa #325',
        @GPS = '9.9345, -84.0789',
        @IDDireccion = @ID_Direccion5 OUTPUT;
    PRINT 'Dirección 5 (Cliente SJ) creada con ID: ' + CAST(@ID_Direccion5 AS VARCHAR);

    -- Dirección 6: Cliente en Limón
    EXEC sp_InsertarDireccion 
        @CodigoProvincia = '7',  -- Limón
        @CodigoCanton = '01',    -- Limón
        @CodigoDistrito = '01',  -- Limón
        @CodigoBarrio = '02',    -- Cieneguita (ya existe)
        @SenasExactas = 'Barrio Los Ángeles, casa color verde',
        @GPS = '9.9780, -83.0275',
        @IDDireccion = @ID_Direccion6 OUTPUT;
    PRINT 'Dirección 6 (Cliente Limón) creada con ID: ' + CAST(@ID_Direccion6 AS VARCHAR);

    -- -----------------------------------------------------------
    -- DIRECCIONES PARA EMPRESAS DE RECREACIÓN
    -- -----------------------------------------------------------

    -- Dirección 7: Empresa de Tours Acuáticos (usando el barrio recién creado)
    EXEC sp_InsertarDireccion 
        @CodigoProvincia = '7',  -- Limón
        @CodigoCanton = '01',    -- Limón
        @CodigoDistrito = '02',  -- Valle La Estrella
        @CodigoBarrio = '01',    -- Pueblo Nuevo (creado arriba)
        @SenasExactas = '500 metros norte del puerto, muelle #3',
        @GPS = '9.9850, -83.0300',
        @IDDireccion = @ID_Direccion7 OUTPUT;
    PRINT 'Dirección 7 (Empresa Recreación 1) creada con ID: ' + CAST(@ID_Direccion7 AS VARCHAR);

    -- Dirección 8: Empresa de Aventuras en la Selva
    EXEC sp_InsertarDireccion 
        @CodigoProvincia = '7',  -- Limón
        @CodigoCanton = '02',    -- Pococí
        @CodigoDistrito = '01',  -- Guápiles
        @CodigoBarrio = '01',    -- Centro (ya existe)
        @SenasExactas = 'Frente al parque central de Guápiles, local #8',
        @GPS = '10.2175, -83.7850',
        @IDDireccion = @ID_Direccion8 OUTPUT;
    PRINT 'Dirección 8 (Empresa Recreación 2) creada con ID: ' + CAST(@ID_Direccion8 AS VARCHAR);

END;
GO



-- 6. Insertar establecimientos

BEGIN
    -- Variables para almacenar IDs generados
    DECLARE @ID_Establecimiento1 INT, @ID_Establecimiento2 INT, @ID_Establecimiento3 INT;
    DECLARE @ID_Servicio1 INT, @ID_Servicio2 INT, @ID_Servicio3 INT, @ID_Servicio4 INT;
    DECLARE @ID_TipoHab1 INT, @ID_TipoHab2 INT, @ID_TipoHab3 INT;
    DECLARE @ID_Comodidad1 INT, @ID_Comodidad2 INT, @ID_Comodidad3 INT;
    DECLARE @ID_Habitacion1 INT, @ID_Habitacion2 INT, @ID_Habitacion3 INT;
    DECLARE @Mensaje VARCHAR(200);
    
    -- IDs de direcciones existentes (asumiendo que ya tienes estas direcciones insertadas)
    DECLARE @ID_Direccion1 INT = 1; -- Hotel en Limón Centro
    DECLARE @ID_Direccion2 INT = 2; -- Hotel en Cieneguita
    DECLARE @ID_Direccion3 INT = 3; -- Hotel en Guápiles

    -- -----------------------------------------------------------
    -- 1. INSERTAR SERVICIOS (usando sp_InsertarServicio)
    -- -----------------------------------------------------------
    
    EXEC sp_InsertarServicio 'Piscina', @IDServicio = @ID_Servicio1 OUTPUT;
    EXEC sp_InsertarServicio 'Wifi gratuito', @IDServicio = @ID_Servicio2 OUTPUT;
    EXEC sp_InsertarServicio 'Parqueo privado', @IDServicio = @ID_Servicio3 OUTPUT;
    EXEC sp_InsertarServicio 'Restaurante', @IDServicio = @ID_Servicio4 OUTPUT;
    
    PRINT 'Servicios insertados correctamente';
    
    -- -----------------------------------------------------------
    -- 2. INSERTAR ESTABLECIMIENTOS (usando sp_InsertarEstablecimiento)
    -- -----------------------------------------------------------
    
    -- Establecimiento 1: Hotel en Limón Centro
    EXEC sp_InsertarEstablecimiento
        @Nombre = 'Hotel Caribeño',
        @CedulaJuridica = '3-101-500100',
        @Tipo = 'Hotel',
        @IDDireccion = @ID_Direccion1,
        @Telefono1 = '+506 2758-1234',
        @Telefono2 = '+506 2758-1235',
        @Email = 'info@hotelcaribeno.com',
        @WebURL = 'www.hotelcaribeno.com',
        @FacebookURL = 'www.facebook.com/hotelcaribeno',
        @InstagramURL = 'www.instagram.com/hotelcaribeno',
        @IDEstablecimiento = @ID_Establecimiento1 OUTPUT;
    
    -- Establecimiento 2: Hotel en Cieneguita
    EXEC sp_InsertarEstablecimiento
        @Nombre = 'Cabañas Tropicales',
        @CedulaJuridica = '3-101-500200',
        @Tipo = 'Cabaña',
        @IDDireccion = @ID_Direccion2,
        @Telefono1 = '+506 2756-5555',
        @Email = 'reservaciones@cabanastropicales.com',
        @FacebookURL = 'www.facebook.com/cabanastropicales',
        @IDEstablecimiento = @ID_Establecimiento2 OUTPUT;
    
    -- Establecimiento 3: Hotel en Guápiles
    EXEC sp_InsertarEstablecimiento
        @Nombre = 'Hostal La Selva',
        @CedulaJuridica = '3-102-500300',
        @Tipo = 'Hostal',
        @IDDireccion = @ID_Direccion3,
        @Telefono1 = '+506 2710-2020',
        @Email = 'contacto@hostallaselva.com',
        @IDEstablecimiento = @ID_Establecimiento3 OUTPUT;
    
    PRINT 'Establecimientos insertados correctamente';
    
    -- -----------------------------------------------------------
    -- 3. ASIGNAR SERVICIOS A ESTABLECIMIENTOS (usando sp_AsignarServicioEstablecimiento)
    -- -----------------------------------------------------------
    
    -- Servicios para Hotel Caribeño
    EXEC sp_AsignarServicioEstablecimiento @ID_Establecimiento1, @ID_Servicio1; -- Piscina
    EXEC sp_AsignarServicioEstablecimiento @ID_Establecimiento1, @ID_Servicio2; -- Wifi
    EXEC sp_AsignarServicioEstablecimiento @ID_Establecimiento1, @ID_Servicio3; -- Parqueo
    EXEC sp_AsignarServicioEstablecimiento @ID_Establecimiento1, @ID_Servicio4; -- Restaurante
    
    -- Servicios para Cabañas Tropicales
    EXEC sp_AsignarServicioEstablecimiento @ID_Establecimiento2, @ID_Servicio2; -- Wifi
    EXEC sp_AsignarServicioEstablecimiento @ID_Establecimiento2, @ID_Servicio3; -- Parqueo
    
    -- Servicios para Hostal La Selva
    EXEC sp_AsignarServicioEstablecimiento @ID_Establecimiento3, @ID_Servicio2; -- Wifi
    
    PRINT 'Servicios asignados a establecimientos correctamente';
    
    -- -----------------------------------------------------------
    -- 4. INSERTAR COMODIDADES (usando sp_InsertarComodidad)
    -- -----------------------------------------------------------
    
    EXEC sp_InsertarComodidad 'Aire acondicionado', @IDComodidad = @ID_Comodidad1 OUTPUT;
    EXEC sp_InsertarComodidad 'TV por cable', @IDComodidad = @ID_Comodidad2 OUTPUT;
    EXEC sp_InsertarComodidad 'Minibar', @IDComodidad = @ID_Comodidad3 OUTPUT;
    
    PRINT 'Comodidades insertadas correctamente';
    
    -- -----------------------------------------------------------
    -- 5. INSERTAR TIPOS DE HABITACIÓN (usando sp_InsertarTipoHabitacion)
    -- -----------------------------------------------------------
    
    -- Para Hotel Caribeño
    EXEC sp_InsertarTipoHabitacion
        @IDEstablecimiento = @ID_Establecimiento1,
        @Nombre = 'Habitación Standard',
        @Descripcion = 'Habitación con cama queen, baño privado y vista al jardín',
        @TipoCama = 'Queen',
        @Precio = 85.00,
        @Cantidad = 10,
        @IDTipoHabitacion = @ID_TipoHab1 OUTPUT;
    
    EXEC sp_InsertarTipoHabitacion
        @IDEstablecimiento = @ID_Establecimiento1,
        @Nombre = 'Suite Ejecutiva',
        @Descripcion = 'Amplia suite con sala de estar, cama king y vista al mar',
        @TipoCama = 'King',
        @Precio = 150.00,
        @Cantidad = 5,
        @IDTipoHabitacion = @ID_TipoHab2 OUTPUT;
    
    -- Para Cabañas Tropicales
    EXEC sp_InsertarTipoHabitacion
        @IDEstablecimiento = @ID_Establecimiento2,
        @Nombre = 'Cabaña Familiar',
        @Descripcion = 'Cabaña con dos habitaciones, cocineta y terraza privada',
        @TipoCama = '2 Queen',
        @Precio = 120.00,
        @Cantidad = 8,
        @IDTipoHabitacion = @ID_TipoHab3 OUTPUT;
    
    PRINT 'Tipos de habitación insertados correctamente';
    
    -- -----------------------------------------------------------
    -- 6. ASIGNAR COMODIDADES A TIPOS DE HABITACIÓN (usando sp_AsignarComodidadHabitacion)
    -- -----------------------------------------------------------
    
    -- Comodidades para Habitación Standard
    EXEC sp_AsignarComodidadHabitacion @ID_TipoHab1, @ID_Comodidad1; -- Aire acondicionado
    EXEC sp_AsignarComodidadHabitacion @ID_TipoHab1, @ID_Comodidad2; -- TV por cable
    
    -- Comodidades para Suite Ejecutiva
    EXEC sp_AsignarComodidadHabitacion @ID_TipoHab2, @ID_Comodidad1; -- Aire acondicionado
    EXEC sp_AsignarComodidadHabitacion @ID_TipoHab2, @ID_Comodidad2; -- TV por cable
    EXEC sp_AsignarComodidadHabitacion @ID_TipoHab2, @ID_Comodidad3; -- Minibar
    
    -- Comodidades para Cabaña Familiar
    EXEC sp_AsignarComodidadHabitacion @ID_TipoHab3, @ID_Comodidad1; -- Aire acondicionado
    
    PRINT 'Comodidades asignadas a tipos de habitación correctamente';
    
    -- -----------------------------------------------------------
    -- 7. INSERTAR HABITACIONES (usando sp_InsertarHabitacion)
    -- -----------------------------------------------------------
    
    -- Habitaciones para Hotel Caribeño (Standard)
    EXEC sp_InsertarHabitacion @ID_TipoHab1, '101', 'Disponible', @IDHabitacion = @ID_Habitacion1 OUTPUT;
    EXEC sp_InsertarHabitacion @ID_TipoHab1, '102', 'Disponible', @IDHabitacion = @ID_Habitacion2 OUTPUT;
    
    -- Habitación para Hotel Caribeño (Suite)
    EXEC sp_InsertarHabitacion @ID_TipoHab2, '201', 'Disponible', @IDHabitacion = @ID_Habitacion3 OUTPUT;
    
    PRINT 'Habitaciones insertadas correctamente';
	END;
	GO


-- Variables para almacenar IDs generados
DECLARE @ID_Cliente1 INT, @ID_Cliente2 INT, @ID_Cliente3 INT;
DECLARE @Mensaje VARCHAR(200);

-- Cliente 1: Nacional con dirección en Limón (usando dirección ID 6 que creamos antes)
EXEC sp_InsertarCliente
    @Nombre = 'Juan Carlos',
    @Apellido1 = 'Méndez',
    @Apellido2 = 'Solís',
    @FechaNacimiento = '1985-05-15',
    @Cedula = '1-2345-6789',
    @PaisResidencia = 'Costa Rica',
    @IDDireccion = 6, -- Dirección en Limón (Cieneguita)
    @Telefono1 = '+506 8888-8888',
    @Telefono2 = '+506 2222-2222',
    @Email = 'juan.mendez@email.com',
    @IDCliente = @ID_Cliente1 OUTPUT;
PRINT 'Cliente 1 creado con ID: ' + CAST(@ID_Cliente1 AS VARCHAR);

-- Cliente 2: Nacional con dirección en San José (usando dirección ID 5)
EXEC sp_InsertarCliente
    @Nombre = 'Ana Patricia',
    @Apellido1 = 'González',
    @Apellido2 = 'Fernández',
    @FechaNacimiento = '1990-11-22',
    @Cedula = '2-3456-7890',
    @PaisResidencia = 'Costa Rica',
    @IDDireccion = 5, -- Dirección en San José (Barrio Amón)
    @Telefono1 = '+506 7777-7777',
    @Email = 'ana.gonzalez@email.com',
    @IDCliente = @ID_Cliente2 OUTPUT;
PRINT 'Cliente 2 creado con ID: ' + CAST(@ID_Cliente2 AS VARCHAR);

-- Cliente 3: Extranjero sin dirección en CR
EXEC sp_InsertarCliente
    @Nombre = 'Michael',
    @Apellido1 = 'Johnson',
    @Apellido2 = NULL,
    @FechaNacimiento = '1978-03-10',
    @Cedula = 'PASSPORT123456', -- Número de pasaporte para extranjeros
    @PaisResidencia = 'Estados Unidos',
    @IDDireccion = NULL, -- Sin dirección en CR
    @Telefono1 = '+1 555-123-4567',
    @Telefono2 = NULL,
    @Telefono3 = NULL,
    @Email = 'michael.johnson@email.com',
    @IDCliente = @ID_Cliente3 OUTPUT;
PRINT 'Cliente 3 creado con ID: ' + CAST(@ID_Cliente3 AS VARCHAR);
GO

-- Variables para almacenar IDs generados
DECLARE @ID_Reservacion1 INT, @ID_Reservacion2 INT, @ID_Reservacion3 INT;
DECLARE @Mensaje VARCHAR(200);

-- Reservación 1: Cliente nacional en habitación standard
EXEC sp_InsertarReservacion
    @ID_Cliente = 1, -- Juan Carlos Méndez
    @ID_Habitacion = 1, -- Habitación 101 (Standard)
    @Fecha_Ingreso = '2024-11-15',
    @Fecha_Salida = '2024-11-20',
    @Hora_Ingreso = '15:00:00',
    @Cantidad_Personas = 2,
    @Tiene_Vehiculo = 1,
    @ID_Reservacion = @ID_Reservacion1 OUTPUT,
    @Mensaje = @Mensaje OUTPUT;
PRINT @Mensaje;

-- Reservación 2: Cliente nacional en suite ejecutiva
EXEC sp_InsertarReservacion
    @ID_Cliente = 2, -- Ana Patricia González
    @ID_Habitacion = 3, -- Habitación 201 (Suite)
    @Fecha_Ingreso = '2024-12-01',
    @Fecha_Salida = '2024-12-10',
    @Hora_Ingreso = '16:00:00',
    @Cantidad_Personas = 2,
    @Tiene_Vehiculo = 0,
    @ID_Reservacion = @ID_Reservacion2 OUTPUT,
    @Mensaje = @Mensaje OUTPUT;
PRINT @Mensaje;


-- Reservación 3: Cliente extranjero en cabaña familiar (para fechas futuras)
EXEC sp_InsertarReservacion
    @ID_Cliente = 3, -- Michael Johnson
    @ID_Habitacion = 2, -- Asumiendo que existe una cabaña con ID 4
    @Fecha_Ingreso = '2025-01-05',
    @Fecha_Salida = '2025-01-15',
    @Cantidad_Personas = 4,
    @Tiene_Vehiculo = 1,
    @ID_Reservacion = @ID_Reservacion3 OUTPUT,
    @Mensaje = @Mensaje OUTPUT;
PRINT @Mensaje;

GO



-- FACTURAS

-- Variables para almacenar IDs generados
DECLARE @ID_Factura1 INT, @ID_Factura2 INT;
DECLARE @Mensaje VARCHAR(200);

-- -----------------------------------------------------------
-- FACTURA 1: Para la reservación 1 (que ya finalizamos)
-- -----------------------------------------------------------
EXEC sp_InsertarFactura
    @ID_Reservacion = 1, -- Reservación de Juan Carlos Méndez (15-20 nov)
    @Metodo_Pago = 'Tarjeta Crédito',
    @Detalles = 'Pago completo con tarjeta Visa',
    @ID_Factura = @ID_Factura1 OUTPUT,
    @Mensaje = @Mensaje OUTPUT;

PRINT @Mensaje;
PRINT 'Número de factura generado: FAC-' + CAST(YEAR(GETDATE()) AS VARCHAR(4)) + '-' + RIGHT('00000' + CAST(@ID_Factura1 AS VARCHAR(5)), 5);

-- -----------------------------------------------------------
-- FACTURA 2: Para la reservación 2 (suite ejecutiva)
-- -----------------------------------------------------------
EXEC sp_InsertarFactura
    @ID_Reservacion = 2, -- Reservación de Ana Patricia González (1-10 dic)
    @Metodo_Pago = 'Efectivo',
    @Detalles = 'Pago en efectivo con 10% de descuento promocional',
    @ID_Factura = @ID_Factura2 OUTPUT,
    @Mensaje = @Mensaje OUTPUT;

PRINT @Mensaje;
PRINT 'Número de factura generado: FAC-' + CAST(YEAR(GETDATE()) AS VARCHAR(4)) + '-' + RIGHT('00000' + CAST(@ID_Factura2 AS VARCHAR(5)), 5);
GO


-- Variables para almacenar IDs generados
DECLARE @ID_Empresa1 INT, @ID_Empresa2 INT;
DECLARE @ID_TipoActividad1 INT, @ID_TipoActividad2 INT, @ID_TipoActividad3 INT;
DECLARE @ID_ActividadEmpresa1 INT, @ID_ActividadEmpresa2 INT, @ID_ActividadEmpresa3 INT;
DECLARE @Mensaje VARCHAR(200);

-- -----------------------------------------------------------
-- 1. INSERTAR TIPOS DE ACTIVIDAD (usando sp_InsertarTipoActividad)
-- -----------------------------------------------------------

-- Tour en bote
EXEC sp_InsertarTipoActividad 
    @Nombre = 'Tour en bote', 
    @ID_Tipo_Actividad = @ID_TipoActividad1 OUTPUT;
PRINT 'Tipo de actividad creado (Tour en bote) con ID: ' + CAST(@ID_TipoActividad1 AS VARCHAR);

-- Tour en catamarán
EXEC sp_InsertarTipoActividad 
    @Nombre = 'Tour en catamarán', 
    @ID_Tipo_Actividad = @ID_TipoActividad2 OUTPUT;
PRINT 'Tipo de actividad creado (Tour en catamarán) con ID: ' + CAST(@ID_TipoActividad2 AS VARCHAR);

-- Tour a cataratas
EXEC sp_InsertarTipoActividad 
    @Nombre = 'Tour a cataratas', 
    @ID_Tipo_Actividad = @ID_TipoActividad3 OUTPUT;
PRINT 'Tipo de actividad creado (Tour a cataratas) con ID: ' + CAST(@ID_TipoActividad3 AS VARCHAR);

-- -----------------------------------------------------------
-- 2. INSERTAR EMPRESAS DE RECREACIÓN (usando sp_InsertarEmpresaRecreacion)
-- -----------------------------------------------------------

-- Empresa 1: Tours Acuáticos del Caribe (usando dirección ID 7)
EXEC sp_InsertarEmpresaRecreacion 
    @Nombre = 'Tours Acuáticos del Caribe',
    @CedulaJuridica = '3-456-789012',
    @Email = 'info@toursacuaticos.com',
    @Telefono = '+506 2758-3030',
    @ContactoNombre = 'Carlos Méndez',
    @ID_Direccion = 7, -- Dirección en Limón (Valle La Estrella)
    @Descripcion = 'Especialistas en tours acuáticos por el Caribe costarricense',
    @ID_Empresa = @ID_Empresa1 OUTPUT;
PRINT 'Empresa creada (Tours Acuáticos) con ID: ' + CAST(@ID_Empresa1 AS VARCHAR);

-- Empresa 2: Aventuras en la Selva (usando dirección ID 8)
EXEC sp_InsertarEmpresaRecreacion 
    @Nombre = 'Aventuras en la Selva',
    @CedulaJuridica = '3-456-789013',
    @Email = 'aventuras@selva.com',
    @Telefono = '+506 2756-1234',
    @ContactoNombre = 'María Fernández',
    @ID_Direccion = 8, -- Dirección en Guápiles
    @Descripcion = 'Experiencias únicas en la selva caribeña',
    @ID_Empresa = @ID_Empresa2 OUTPUT;
PRINT 'Empresa creada (Aventuras en la Selva) con ID: ' + CAST(@ID_Empresa2 AS VARCHAR);

-- -----------------------------------------------------------
-- 3. ASIGNAR ACTIVIDADES A EMPRESAS (usando sp_AsignarActividadEmpresa)
-- -----------------------------------------------------------

-- Tours Acuáticos ofrece:
-- Tour en bote
EXEC sp_AsignarActividadEmpresa
    @ID_Empresa = @ID_Empresa1,
    @ID_Tipo_Actividad = @ID_TipoActividad1,
    @Precio = 45.00,
    @Descripcion = 'Tour de 2 horas por los canales de Tortuguero',
    @Mensaje = @Mensaje OUTPUT;
PRINT @Mensaje;

-- Tour en catamarán
EXEC sp_AsignarActividadEmpresa
    @ID_Empresa = @ID_Empresa1,
    @ID_Tipo_Actividad = @ID_TipoActividad2,
    @Precio = 75.00,
    @Descripcion = 'Tour al atardecer con cena incluida',
    @Mensaje = @Mensaje OUTPUT;
PRINT @Mensaje;

-- Aventuras en la Selva ofrece:
-- Tour a cataratas
EXEC sp_AsignarActividadEmpresa
    @ID_Empresa = @ID_Empresa2,
    @ID_Tipo_Actividad = @ID_TipoActividad3,
    @Precio = 50.00,
    @Descripcion = 'Tour de día completo a las cataratas escondidas',
    @Mensaje = @Mensaje OUTPUT;
PRINT @Mensaje;



DECLARE @ID_Compra INT, @Mensaje VARCHAR(200);

-- Cliente 1 compra tour en bote
EXEC sp_RegistrarCompraActividad
    @ID_Cliente = 1, -- ID del cliente Juan Carlos Méndez
    @ID_Actividad_Empresa = 1, -- Tour en bote de Tours Acuáticos
    @Fecha_Actividad = '2024-12-15',
    @Cantidad_Personas = 2,
    @Metodo_Pago = 'Tarjeta Crédito',
    @ID_Compra = @ID_Compra OUTPUT,
    @Mensaje = @Mensaje OUTPUT;
PRINT @Mensaje;


USE PY1BD;
GO

-- Variables para almacenar IDs y mensajes
DECLARE @ID_Asociacion1 INT, @ID_Asociacion2 INT, @ID_Asociacion3 INT;
DECLARE @Mensaje VARCHAR(200);

-- -----------------------------------------------------------
-- 1. ASOCIACIONES ENTRE ESTABLECIMIENTOS DE HOSPEDAJE Y EMPRESAS DE RECREACIÓN
-- -----------------------------------------------------------

-- Asociación 1: Hotel Caribeño (ID 1) con Tours Acuáticos del Caribe (ID 1)
EXEC sp_CrearAsociacionEstablecimientos
    @ID_Hotel = 1, -- Hotel Caribeño
    @ID_EmpresaRecreacion = 1, -- Tours Acuáticos del Caribe
    @Comision = 10.00, -- 10% de comisión
    @Descripcion = 'Socio preferido para tours acuáticos',
    @ID_Asociacion = @ID_Asociacion1 OUTPUT,
    @Mensaje = @Mensaje OUTPUT;
PRINT @Mensaje;

-- Asociación 2: Hotel Caribeño (ID 1) con Aventuras en la Selva (ID 2)
EXEC sp_CrearAsociacionEstablecimientos
    @ID_Hotel = 1, -- Hotel Caribeño
    @ID_EmpresaRecreacion = 2, -- Aventuras en la Selva
    @Comision = 15.00, -- 15% de comisión
    @Descripcion = 'Experiencias recomendadas en la selva',
    @ID_Asociacion = @ID_Asociacion2 OUTPUT,
    @Mensaje = @Mensaje OUTPUT;
PRINT @Mensaje;

-- Asociación 3: Cabañas Tropicales (ID 2) con Aventuras en la Selva (ID 2)
EXEC sp_CrearAsociacionEstablecimientos
    @ID_Hotel = 2, -- Cabañas Tropicales
    @ID_EmpresaRecreacion = 2, -- Aventuras en la Selva
    @Comision = 12.00, -- 12% de comisión
    @Descripcion = 'Paquetes combinados cabañas + aventuras',
    @ID_Asociacion = @ID_Asociacion3 OUTPUT,
    @Mensaje = @Mensaje OUTPUT;
PRINT @Mensaje;






DECLARE @Mensaje VARCHAR(200);
EXEC sp_ActualizarDireccion 
    @ID_Direccion = 1,
    @CodigoProvincia = '7',
    @CodigoCanton = '01',
    @CodigoDistrito = '01',
    @CodigoBarrio = '01',
    @SenasExactas = 'Avenida 2, calle 3, frente al parque Vargas (actualizado)',
    @GPS = '9.9906, -83.0390',
    @Mensaje = @Mensaje OUTPUT;
PRINT @Mensaje;









SELECT * FROM Direcciones;
SELECT * FROM  Establecimiento_Hospedaje;
SELECT * FROM Servicios;
SELECT * FROM  Establecimiento_Servicios;
SELECT * FROM Habitacion_Tipo;
SELECT * FROM Comodidades; 
SELECT * FROM Habitacion_Comodidades;
SELECT * FROM Habitaciones;
SELECT * FROM Clientes;
SELECT * FROM Reservaciones;
SELECT * FROM Facturas;
SELECT * FROM Tipos_Actividad;
SELECT * FROM Empresas_Recreacion;
SELECT * FROM Empresa_Actividades;
SELECT * FROM Compras_Actividades;
SELECT * FROM Establecimiento_Socios;

-- DELETES PARA PRUEBA

DELETE FROM Establecimiento_Servicios;
DELETE FROM Establecimiento_Hospedaje;
DELETE FROM Direcciones;
DELETE FROM Barrios;
DELETE FROM Distritos;
DELETE FROM Cantones;
DELETE FROM Provincias;
DELETE FROM Servicios;

-- Reiniciar los contadores de identidad
DBCC CHECKIDENT ('Direcciones', RESEED, 0);
DBCC CHECKIDENT ('Establecimiento_Hospedaje', RESEED, 0);
DBCC CHECKIDENT ('Servicios', RESEED, 0);





-- Deshabilitar temporalmente las restricciones de clave foránea
EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';
GO

-- Eliminar datos en orden inverso a las dependencias
DELETE FROM Habitaciones;
DBCC CHECKIDENT ('Habitaciones', RESEED, 0);

DELETE FROM Habitacion_Comodidades;

DELETE FROM Comodidades;
DBCC CHECKIDENT ('Comodidades', RESEED, 0);

DELETE FROM Habitacion_Tipo;
DBCC CHECKIDENT ('Habitacion_Tipo', RESEED, 0);

DELETE FROM Establecimiento_Servicios;

DELETE FROM Servicios;
DBCC CHECKIDENT ('Servicios', RESEED, 0);

DELETE FROM Establecimiento_Hospedaje;
DBCC CHECKIDENT ('Establecimiento_Hospedaje', RESEED, 0);

-- Volver a habilitar las restricciones de clave foránea
EXEC sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL';
GO

PRINT 'Datos eliminados y contadores de identidad reiniciados correctamente';

