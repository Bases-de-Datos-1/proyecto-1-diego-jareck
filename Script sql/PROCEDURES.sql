-- Query de Procedures
USE PY1BD;
GO


-- Primera Parte Procedimientos de insercion y asociacion

-- 1. Procedimiento para insertar provincias
CREATE PROCEDURE sp_InsertarProvincia
    @CodigoProvincia CHAR(2),
    @Nombre VARCHAR(20)
AS
BEGIN
    INSERT INTO Provincias (Codigo_Provincia, Nombre)
    VALUES (@CodigoProvincia, @Nombre);
END;
GO

-- 2. Procedimiento para insertar cantones
CREATE PROCEDURE sp_InsertarCanton
    @CodigoProvincia CHAR(2),
    @CodigoCanton CHAR(2),
    @Nombre VARCHAR(50)
AS
BEGIN
    INSERT INTO Cantones (Codigo_Provincia, Codigo_Canton, Nombre)
    VALUES (@CodigoProvincia, @CodigoCanton, @Nombre);
END;
GO

-- 3. Procedimiento para insertar distritos
CREATE PROCEDURE sp_InsertarDistrito
    @CodigoProvincia CHAR(2),
    @CodigoCanton CHAR(2),
    @CodigoDistrito CHAR(2),
    @Nombre VARCHAR(50)
AS
BEGIN
    INSERT INTO Distritos (Codigo_Provincia, Codigo_Canton, Codigo_Distrito, Nombre)
    VALUES (@CodigoProvincia, @CodigoCanton, @CodigoDistrito, @Nombre);
END;
GO

-- 4. Procedimiento para insertar barrios
CREATE PROCEDURE sp_InsertarBarrio
    @CodigoProvincia CHAR(2),
    @CodigoCanton CHAR(2),
    @CodigoDistrito CHAR(2),
    @CodigoBarrio CHAR(2),
    @Nombre VARCHAR(50)
AS
BEGIN
    INSERT INTO Barrios (Codigo_Provincia, Codigo_Canton, Codigo_Distrito, Codigo_Barrio, Nombre)
    VALUES (@CodigoProvincia, @CodigoCanton, @CodigoDistrito, @CodigoBarrio, @Nombre);
END;
GO

-- 5. Procedimiento para insertar direcciones
CREATE PROCEDURE sp_InsertarDireccion
    @CodigoProvincia CHAR(2),
    @CodigoCanton CHAR(2),
    @CodigoDistrito CHAR(2),
    @CodigoBarrio CHAR(2),
    @SenasExactas VARCHAR(200),
    @GPS VARCHAR(100),
    @IDDireccion INT OUTPUT
AS
BEGIN
    INSERT INTO Direcciones (Codigo_Provincia, Codigo_Canton, Codigo_Distrito, Codigo_Barrio, Senas_Exactas, GPS)
    VALUES (@CodigoProvincia, @CodigoCanton, @CodigoDistrito, @CodigoBarrio, @SenasExactas, @GPS);
    
    SET @IDDireccion = SCOPE_IDENTITY();
END;
GO

-- 6. Procedimiento para insertar establecimientos de hospedaje
CREATE PROCEDURE sp_InsertarEstablecimiento
    @Nombre VARCHAR(100),
    @CedulaJuridica VARCHAR(20),
    @Tipo VARCHAR(50),
    @IDDireccion INT,
    @Telefono1 VARCHAR(20) = NULL,
    @Telefono2 VARCHAR(20) = NULL,
    @Email VARCHAR(100) = NULL,
    @WebURL VARCHAR(100) = NULL,
    @FacebookURL VARCHAR(100) = NULL,
    @InstagramURL VARCHAR(100) = NULL,
    @YoutubeURL VARCHAR(100) = NULL,
    @TiktokURL VARCHAR(100) = NULL,
    @AirbnbURL VARCHAR(100) = NULL,
    @ThreadsURL VARCHAR(100) = NULL,
    @XURL VARCHAR(100) = NULL,
    @IDEstablecimiento INT OUTPUT
AS
BEGIN
    INSERT INTO Establecimiento_Hospedaje (
        Nombre, Cedula_Juridica, Tipo, ID_Direccion,
        Telefono1, Telefono2, Email, Web_URL,
        Facebook_URL, Instagram_URL, Youtube_URL,
        Tiktok_URL, Airbnb_URL, THREADS_URL, X_URL
    )
    VALUES (
        @Nombre, @CedulaJuridica, @Tipo, @IDDireccion,
        @Telefono1, @Telefono2, @Email, @WebURL,
        @FacebookURL, @InstagramURL, @YoutubeURL,
        @TiktokURL, @AirbnbURL, @ThreadsURL, @XURL
    );
    
    SET @IDEstablecimiento = SCOPE_IDENTITY();
END;
GO

-- 7. Procedimiento para insertar servicios
CREATE PROCEDURE sp_InsertarServicio
    @Nombre VARCHAR(50),
    @IDServicio INT OUTPUT
AS
BEGIN
    INSERT INTO Servicios (Nombre)
    VALUES (@Nombre);
    
    SET @IDServicio = SCOPE_IDENTITY();
END;
GO

-- 8. Procedimiento para asignar servicios a establecimientos
CREATE PROCEDURE sp_AsignarServicioEstablecimiento
    @IDEstablecimiento INT,
    @IDServicio INT
AS
BEGIN
    INSERT INTO Establecimiento_Servicios (ID_Establecimiento, ID_Servicio)
    VALUES (@IDEstablecimiento, @IDServicio);
END;
GO

-- 9. Procedimiento para Insertar Tipos de Habitacion
CREATE PROCEDURE sp_InsertarTipoHabitacion
    @IDEstablecimiento INT,
    @Nombre VARCHAR(50),
    @Descripcion TEXT = NULL,
    @TipoCama VARCHAR(50) = NULL,
    @Precio DECIMAL(10,2),
    @Cantidad INT,
    @IDTipoHabitacion INT OUTPUT
AS
BEGIN
    INSERT INTO Habitacion_Tipo (
        ID_Establecimiento, 
        Nombre, 
        Descripcion, 
        Tipo_Cama, 
        Precio,
        Cantidad
    )
    VALUES (
        @IDEstablecimiento,
        @Nombre,
        @Descripcion,
        @TipoCama,
        @Precio,
        @Cantidad
    );
    
    SET @IDTipoHabitacion = SCOPE_IDENTITY();
END;
GO

-- 10. Procedimiento para insertar comodidad
CREATE PROCEDURE sp_InsertarComodidad
    @Nombre VARCHAR(50),
    @IDComodidad INT OUTPUT
AS
BEGIN
    INSERT INTO Comodidades (Nombre)
    VALUES (@Nombre);
    
    SET @IDComodidad = SCOPE_IDENTITY();
END;
GO

-- 11. Prodecimiento para asignar una comodidad a una habitacion
CREATE PROCEDURE sp_AsignarComodidadHabitacion
    @IDTipoHabitacion INT,
    @IDComodidad INT
AS
BEGIN
    INSERT INTO Habitacion_Comodidades (ID_Tipo_Habitacion, ID_Comodidad)
    VALUES (@IDTipoHabitacion, @IDComodidad);
END;
GO

-- 12. Procedimiento para insertar una habitacion
CREATE OR ALTER PROCEDURE sp_InsertarHabitacion
    @IDTipoHabitacion INT,
    @Numero VARCHAR(10),
    @Estado VARCHAR(20) = 'Disponible',
    @IDHabitacion INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @Estado NOT IN ('Disponible', 'Ocupada', 'Reservada')
        SET @Estado = 'Disponible';
        
    INSERT INTO Habitaciones (  
        ID_Tipo_Habitacion, 
        Numero, 
        Estado
    )
    VALUES (
        @IDTipoHabitacion,
        @Numero,
        @Estado
    );
    
    SET @IDHabitacion = SCOPE_IDENTITY();
END;
GO

-- 13.Procedimiento para insertar  Cliente

CREATE OR ALTER PROCEDURE sp_InsertarCliente
    @Nombre VARCHAR(50),
    @Apellido1 VARCHAR(50),
    @Apellido2 VARCHAR(50) = NULL,
    @FechaNacimiento DATE,
    @Cedula VARCHAR(20),
    @PaisResidencia VARCHAR(50),
    @IDDireccion INT = NULL,
    @Telefono1 VARCHAR(20) = NULL,
    @Telefono2 VARCHAR(20) = NULL,
    @Telefono3 VARCHAR(20) = NULL,
    @Email VARCHAR(100) = NULL,
    @IDCliente INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    IF @FechaNacimiento > GETDATE()  -- Si se ingresa una fecha invalida (mayor a la fecha actual) se programa por defecto a 18 años
        SET @FechaNacimiento = DATEADD(YEAR, -18, GETDATE());
        
    INSERT INTO Clientes (
        Nombre, Apellido1, Apellido2, Fecha_Nacimiento,
        Cedula, Pais_Residencia, ID_Direccion,
        Telefono1, Telefono2, Telefono3, Email
    )
    VALUES (
        @Nombre, @Apellido1, @Apellido2, @FechaNacimiento,
        @Cedula, @PaisResidencia, @IDDireccion,
        @Telefono1, @Telefono2, @Telefono3, @Email
    );
    
    SET @IDCliente = SCOPE_IDENTITY();
END;
GO


-- 14. Procedimiento para Insertar Reservacion 

CREATE OR ALTER PROCEDURE sp_InsertarReservacion
    @ID_Cliente INT,
    @ID_Habitacion INT,
    @Fecha_Ingreso DATE,
    @Fecha_Salida DATE,
    @Hora_Ingreso TIME = NULL,  
    @Hora_Salida TIME = NULL,   
    @Cantidad_Personas INT,
    @Tiene_Vehiculo BIT = 0,
    @ID_Reservacion INT OUTPUT,
    @Mensaje VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Validaciones basicas
        IF NOT EXISTS (SELECT 1 FROM Clientes WHERE ID_Cliente = @ID_Cliente)
        BEGIN
            SET @Mensaje = 'Error: Cliente no existe';
            SET @ID_Reservacion = -1;
            RETURN;
        END
        
        IF NOT EXISTS (SELECT 1 FROM Habitaciones WHERE ID_Habitacion = @ID_Habitacion)
        BEGIN
            SET @Mensaje = 'Error: Habitación no existe';
            SET @ID_Reservacion = -1;
            RETURN;
        END
        
        -- Verificar que la habitacion este disponible
        DECLARE @EstadoHabitacion VARCHAR(20);
        SELECT @EstadoHabitacion = Estado FROM Habitaciones WHERE ID_Habitacion = @ID_Habitacion;
        
        IF @EstadoHabitacion <> 'Disponible'
        BEGIN
            SET @Mensaje = 'Error: La habitación no está disponible. Estado actual: ' + @EstadoHabitacion;
            SET @ID_Reservacion = -1;
            RETURN;
        END
        
        -- Usar valores por defecto si son NULL
        SET @Hora_Ingreso = ISNULL(@Hora_Ingreso, '14:00:00');
        SET @Hora_Salida = ISNULL(@Hora_Salida, '12:00:00');
        
        -- Validar disponibilidad de la habitación en las fechas y horas solicitadas
        IF EXISTS (
            SELECT 1 FROM Reservaciones
            WHERE ID_Habitacion = @ID_Habitacion
            AND Activa = 1
            AND (
                (CAST(@Fecha_Ingreso AS DATETIME) + CAST(@Hora_Ingreso AS DATETIME) < 
                 CAST(Fecha_Salida AS DATETIME) + CAST(Hora_Salida AS DATETIME))
                AND
                (CAST(@Fecha_Salida AS DATETIME) + CAST(@Hora_Salida AS DATETIME) > 
                 CAST(Fecha_Ingreso AS DATETIME) + CAST(Hora_Ingreso AS DATETIME))
            )
        )
        BEGIN
            SET @Mensaje = 'Error: Habitación no disponible en esas fechas/horas';
            SET @ID_Reservacion = -1;
            RETURN;
        END
        
        -- Iniciar la operación
        BEGIN TRANSACTION;
        
        -- Insertar reservación
        INSERT INTO Reservaciones (
            ID_Cliente, ID_Habitacion,
            Fecha_Ingreso, Hora_Ingreso,
            Fecha_Salida, Hora_Salida,
            Cantidad_Personas, Tiene_Vehiculo
        )
        VALUES (
            @ID_Cliente, @ID_Habitacion,
            @Fecha_Ingreso, @Hora_Ingreso,
            @Fecha_Salida, @Hora_Salida,
            @Cantidad_Personas, @Tiene_Vehiculo
        );
        
        SET @ID_Reservacion = SCOPE_IDENTITY();
        
        -- Actualizar estado de la habitación a "Reservada"
        UPDATE Habitaciones
        SET Estado = 'Reservada'
        WHERE ID_Habitacion = @ID_Habitacion;
        
        COMMIT TRANSACTION;
        
        SET @Mensaje = 'Reservación creada exitosamente. Número: RES-' + CAST(@ID_Reservacion AS VARCHAR);
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        SET @ID_Reservacion = -1;
        SET @Mensaje = 'Error al crear reservación: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 15. Procedimiento para insertar Facturas
CREATE OR ALTER PROCEDURE sp_InsertarFactura
    @ID_Reservacion INT,
    @Metodo_Pago VARCHAR(20),
    @Detalles VARCHAR(200) = NULL,
    @ID_Factura INT OUTPUT,
    @Mensaje VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Validar que la reservación existe y esta activa
        IF NOT EXISTS (SELECT 1 FROM Reservaciones WHERE ID_Reservacion = @ID_Reservacion AND Activa = 1)
        BEGIN
            SET @Mensaje = 'Error: La reservación no existe o ya está completada';
            SET @ID_Factura = -1;
            RETURN;
        END
        
        -- Validar metodo de pago
        IF @Metodo_Pago NOT IN ('Efectivo', 'Tarjeta Crédito', 'Tarjeta Débito', 'Transferencia')
        BEGIN
            SET @Mensaje = 'Error: Método de pago no válido';
            SET @ID_Factura = -1;
            RETURN;
        END
        
        -- Obtener información de la reservacion y habitación
        DECLARE @PrecioPorNoche DECIMAL(10,2);
        DECLARE @Noches INT;
        DECLARE @Subtotal DECIMAL(10,2);
        DECLARE @Impuestos DECIMAL(10,2) = 0;
        DECLARE @Total DECIMAL(10,2);
        DECLARE @MensajeFinalizacion VARCHAR(200);
        
        -- Calcular numero de noches y obtener precio de la habitación
        SELECT 
            @PrecioPorNoche = ht.Precio,
            @Noches = DATEDIFF(DAY, r.Fecha_Ingreso, r.Fecha_Salida)
        FROM 
            Reservaciones r
            INNER JOIN Habitaciones h ON r.ID_Habitacion = h.ID_Habitacion
            INNER JOIN Habitacion_Tipo ht ON h.ID_Tipo_Habitacion = ht.ID_Tipo_Habitacion
        WHERE 
            r.ID_Reservacion = @ID_Reservacion;
        
        -- Validar que se encontro la información
        IF @PrecioPorNoche IS NULL OR @Noches IS NULL OR @Noches <= 0
        BEGIN
            SET @Mensaje = 'Error: No se pudo obtener información de tarifas o número de noches inválido';
            SET @ID_Factura = -1;
            RETURN;
        END
        
        -- Calcular montos
        SET @Subtotal = @PrecioPorNoche * @Noches;
        SET @Impuestos = @Subtotal * 0.13; -- 13% de impuestos
        SET @Total = @Subtotal + @Impuestos;
        
        -- Iniciar transaccion para asegurar la integridad
        BEGIN TRANSACTION;
        
        -- Insertar factura
        INSERT INTO Facturas (
            ID_Reservacion,
            Subtotal,
            Impuestos,
            Total,
            Metodo_Pago,
            Detalles
        )
        VALUES (
            @ID_Reservacion,
            @Subtotal,
            @Impuestos,
            @Total,
            @Metodo_Pago,
            @Detalles
        );
        
        -- Obtener ID generado
        SET @ID_Factura = SCOPE_IDENTITY();
        
        -- Finalizar la reservación llamar al nuevo procedimiento
        EXEC sp_FinalizarReservacion 
            @ID_Reservacion = @ID_Reservacion,
            @Mensaje = @MensajeFinalizacion OUTPUT;
        
        -- Verificar si hubo error al finalizar
        IF @MensajeFinalizacion LIKE 'Error:%'
        BEGIN
            ROLLBACK TRANSACTION;
            SET @Mensaje = @MensajeFinalizacion;
            SET @ID_Factura = -1;
            RETURN;
        END
        
        COMMIT TRANSACTION;
        
        SET @Mensaje = 'Factura generada correctamente. Número: FAC-' + CAST(YEAR(GETDATE()) AS VARCHAR(4)) + '-' + RIGHT('00000' + CAST(@ID_Factura AS VARCHAR(5)), 5) + 
                      ' | Total: ' + CAST(@Total AS VARCHAR(20)) + ' | Noches: ' + CAST(@Noches AS VARCHAR(10)) + 
                      ' | ' + @MensajeFinalizacion;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        SET @ID_Factura = -1;
        SET @Mensaje = 'Error al generar factura: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
-- 16. Proceso para finalizar la reservacion y sus procesos asociados
CREATE OR ALTER PROCEDURE sp_FinalizarReservacion
    @ID_Reservacion INT,
    @Mensaje VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Validar que la reservación existe y está activa
        IF NOT EXISTS (SELECT 1 FROM Reservaciones WHERE ID_Reservacion = @ID_Reservacion AND Activa = 1)
        BEGIN
            SET @Mensaje = 'Error: La reservación no existe o ya está completada';
            RETURN;
        END
        
        -- Obtener ID de la habitación
        DECLARE @ID_Habitacion INT;
        SELECT @ID_Habitacion = ID_Habitacion FROM Reservaciones WHERE ID_Reservacion = @ID_Reservacion;
        
        -- Iniciar transacción para asegurar la integridad
        BEGIN TRANSACTION;
        
        UPDATE Reservaciones
        SET Activa = 0
        WHERE ID_Reservacion = @ID_Reservacion;
       
        IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('Habitaciones') AND name = 'Estado')
        BEGIN
            UPDATE Habitaciones
            SET Estado = 'Disponible'
            WHERE ID_Habitacion = @ID_Habitacion;
        END
        
        COMMIT TRANSACTION;
        
        SET @Mensaje = 'Reservación finalizada correctamente. Habitación marcada como disponible.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        SET @Mensaje = 'Error al finalizar reservación: ' + ERROR_MESSAGE();
    END CATCH
END;
GO



-- 17. Procedimiento para Insertar empresa de recreacion
CREATE OR ALTER PROCEDURE sp_InsertarEmpresaRecreacion
    @Nombre VARCHAR(100),
    @CedulaJuridica VARCHAR(20),
    @Email VARCHAR(100) = NULL,
    @Telefono VARCHAR(20) = NULL,
    @ContactoNombre VARCHAR(100) = NULL,
    @ID_Direccion INT = NULL,
    @Descripcion TEXT = NULL,
    @ID_Empresa INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        INSERT INTO Empresas_Recreacion (
            Nombre, 
            Cedula_Juridica, 
            Email, 
            Telefono, 
            Contacto_Nombre,
            ID_Direccion, 
            Descripcion
        )
        VALUES (
            @Nombre, 
            @CedulaJuridica, 
            @Email, 
            @Telefono, 
            @ContactoNombre,
            @ID_Direccion, 
            @Descripcion
        );
        
        SET @ID_Empresa = SCOPE_IDENTITY();
    END TRY
    BEGIN CATCH
        SET @ID_Empresa = -1;
        THROW;
    END CATCH
END;
GO

-- 18. Procedimieno para insertar tipo de actividad 

CREATE OR ALTER PROCEDURE sp_InsertarTipoActividad
    @Nombre VARCHAR(50),
    @ID_Tipo_Actividad INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        INSERT INTO Tipos_Actividad (Nombre)
        VALUES (@Nombre);
        
        SET @ID_Tipo_Actividad = SCOPE_IDENTITY();
    END TRY
    BEGIN CATCH
        SET @ID_Tipo_Actividad = -1;
        THROW;
    END CATCH
END;
GO

-- 19. Procedimiento para asignar tipo de actividad a empresa de recreaccion

CREATE OR ALTER PROCEDURE sp_AsignarActividadEmpresa
    @ID_Empresa INT,
    @ID_Tipo_Actividad INT,
    @Precio DECIMAL(10,2),
    @Descripcion TEXT = NULL,
    @Mensaje VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY

        IF NOT EXISTS (SELECT 1 FROM Empresas_Recreacion WHERE ID_Empresa = @ID_Empresa)
        BEGIN
            SET @Mensaje = 'Error: Empresa no existe';
            RETURN;
        END
        
        IF NOT EXISTS (SELECT 1 FROM Tipos_Actividad WHERE ID_Tipo_Actividad = @ID_Tipo_Actividad)
        BEGIN
            SET @Mensaje = 'Error: Tipo de actividad no existe';
            RETURN;
        END
        
        -- Insertar la relación
        INSERT INTO Empresa_Actividades (
            ID_Empresa, 
            ID_Tipo_Actividad, 
            Precio, 
            Descripcion
        )
        VALUES (
            @ID_Empresa, 
            @ID_Tipo_Actividad, 
            @Precio, 
            @Descripcion
        );
        
        SET @Mensaje = 'Actividad asignada correctamente a la empresa';
    END TRY
    BEGIN CATCH
        SET @Mensaje = 'Error al asignar actividad: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 20. Procedimiento para Asociar un Establecimiento (Hotel) con una empresa de recreacion 

CREATE OR ALTER PROCEDURE sp_CrearAsociacionEstablecimientos
    @ID_Hotel INT,
    @ID_EmpresaRecreacion INT,
    @Comision DECIMAL(5,2) = NULL,
    @Descripcion VARCHAR(255) = NULL,
    @ID_Asociacion INT OUTPUT,
    @Mensaje VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
     
        IF NOT EXISTS (SELECT 1 FROM Establecimiento_Hospedaje WHERE ID_Establecimiento = @ID_Hotel)
        BEGIN
            SET @Mensaje = 'Error: El establecimiento de hospedaje no existe';
            SET @ID_Asociacion = -1;
            RETURN;
        END
        
        IF NOT EXISTS (SELECT 1 FROM Empresas_Recreacion WHERE ID_Empresa = @ID_EmpresaRecreacion)
        BEGIN
            SET @Mensaje = 'Error: La empresa de recreación no existe';
            SET @ID_Asociacion = -1;
            RETURN;
        END
        
        INSERT INTO Establecimiento_Socios (
            ID_Establecimiento_Hospedaje,
            ID_Empresa_Recreacion,
            Comision,
            Descripcion_Recomendacion
        )
        VALUES (
            @ID_Hotel,
            @ID_EmpresaRecreacion,
            @Comision,
            @Descripcion
        );
        
        SET @ID_Asociacion = SCOPE_IDENTITY();
        SET @Mensaje = 'Asociación creada exitosamente';
    END TRY
    BEGIN CATCH
        SET @ID_Asociacion = -1;
        SET @Mensaje = 'Error al crear asociación: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

--21. Procedimiento para registrar una compra de un servicio a una empresa de recreacion

CREATE OR ALTER PROCEDURE sp_RegistrarCompraActividad
    @ID_Cliente INT,
    @ID_Actividad_Empresa INT,
    @Fecha_Actividad DATE,
    @Cantidad_Personas INT = 1,
    @Metodo_Pago VARCHAR(20),
    @ID_Compra INT OUTPUT,
    @Mensaje VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Validar que existe la relación actividad-empresa
        IF NOT EXISTS (SELECT 1 FROM Empresa_Actividades WHERE ID_Actividad_Empresa = @ID_Actividad_Empresa)
        BEGIN
            SET @Mensaje = 'Error: La actividad no está registrada para esta empresa';
            SET @ID_Compra = -1;
            RETURN;
        END
        
        -- Obtener precio de la actividad
        DECLARE @Precio DECIMAL(10,2);
        SELECT @Precio = Precio 
        FROM Empresa_Actividades 
        WHERE ID_Actividad_Empresa = @ID_Actividad_Empresa;
        
        -- Calcular montos
        DECLARE @Subtotal DECIMAL(10,2) = @Precio * @Cantidad_Personas;
        DECLARE @Impuestos DECIMAL(10,2) = @Subtotal * 0.13;
        DECLARE @Total DECIMAL(10,2) = @Subtotal + @Impuestos;
        
        -- Insertar la compra
        INSERT INTO Compras_Actividades (
            ID_Cliente,
            ID_Actividad_Empresa,
            Fecha_Actividad,
            Cantidad_Personas,
            Subtotal,
            Impuestos,
            Total,
            Metodo_Pago
        )
        VALUES (
            @ID_Cliente,
            @ID_Actividad_Empresa,
            @Fecha_Actividad,
            @Cantidad_Personas,
            @Subtotal,
            @Impuestos,
            @Total,
            @Metodo_Pago
        );
        
        SET @ID_Compra = SCOPE_IDENTITY();
        SET @Mensaje = 'Compra registrada exitosamente. ID: ' + CAST(@ID_Compra AS VARCHAR);
    END TRY
    BEGIN CATCH
        SET @ID_Compra = -1;
        SET @Mensaje = 'Error al registrar compra: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- PARTE DE PROCEDIMIENTOS RELACIONADOS A LA MODIFICACION DE LAS TABLAS 

-- 1. Modificacion de la direccion
CREATE OR ALTER PROCEDURE sp_ActualizarDireccion
    @ID_Direccion INT,
    @CodigoProvincia CHAR(2),
    @CodigoCanton CHAR(2),
    @CodigoDistrito CHAR(2),
    @CodigoBarrio CHAR(2),
    @SenasExactas VARCHAR(200),
    @GPS VARCHAR(100),
    @Mensaje VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Verificar que existe la dirección
        IF NOT EXISTS (SELECT 1 FROM Direcciones WHERE ID_Direccion = @ID_Direccion)
        BEGIN
            SET @Mensaje = 'Error: La dirección no existe';
            RETURN;
        END
        
        -- Verificar que existen los códigos geográficos
        IF NOT EXISTS (SELECT 1 FROM Barrios 
                       WHERE Codigo_Provincia = @CodigoProvincia
                         AND Codigo_Canton = @CodigoCanton
                         AND Codigo_Distrito = @CodigoDistrito
                         AND Codigo_Barrio = @CodigoBarrio)
        BEGIN
            SET @Mensaje = 'Error: Los códigos geográficos no son válidos';
            RETURN;
        END
        
        -- Actualizar la dirección
        UPDATE Direcciones
        SET Codigo_Provincia = @CodigoProvincia,
            Codigo_Canton = @CodigoCanton,
            Codigo_Distrito = @CodigoDistrito,
            Codigo_Barrio = @CodigoBarrio,
            Senas_Exactas = @SenasExactas,
            GPS = @GPS
        WHERE ID_Direccion = @ID_Direccion;
        
        SET @Mensaje = 'Dirección actualizada correctamente';
    END TRY
    BEGIN CATCH
        SET @Mensaje = 'Error al actualizar dirección: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 2. Modificacion de los establecimientos 

CREATE OR ALTER PROCEDURE sp_ActualizarEstablecimiento
    @ID_Establecimiento INT,
    @Nombre VARCHAR(100),
    @Tipo VARCHAR(50),
    @Telefono1 VARCHAR(20) = NULL,
    @Telefono2 VARCHAR(20) = NULL,
    @Email VARCHAR(100) = NULL,
    @WebURL VARCHAR(100) = NULL,
    @FacebookURL VARCHAR(100) = NULL,
    @InstagramURL VARCHAR(100) = NULL,
    @YoutubeURL VARCHAR(100) = NULL,
    @TiktokURL VARCHAR(100) = NULL,
    @AirbnbURL VARCHAR(100) = NULL,
    @ThreadsURL VARCHAR(100) = NULL,
    @XURL VARCHAR(100) = NULL,
    @Mensaje VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Verificar que existe el establecimiento
        IF NOT EXISTS (SELECT 1 FROM Establecimiento_Hospedaje WHERE ID_Establecimiento = @ID_Establecimiento)
        BEGIN
            SET @Mensaje = 'Error: El establecimiento no existe';
            RETURN;
        END
        
        -- Validar tipo de establecimiento
        IF @Tipo NOT IN ('Hotel', 'Hostal', 'Casa', 'Departamento', 'Cuarto compartido', 'Cabaña')
        BEGIN
            SET @Mensaje = 'Error: Tipo de establecimiento no válido';
            RETURN;
        END
        
        -- Actualizar el establecimiento
        UPDATE Establecimiento_Hospedaje
        SET Nombre = @Nombre,
            Tipo = @Tipo,
            Telefono1 = @Telefono1,
            Telefono2 = @Telefono2,
            Email = @Email,
            Web_URL = @WebURL,
            Facebook_URL = @FacebookURL,
            Instagram_URL = @InstagramURL,
            Youtube_URL = @YoutubeURL,
            Tiktok_URL = @TiktokURL,
            Airbnb_URL = @AirbnbURL,
            THREADS_URL = @ThreadsURL,
            X_URL = @XURL
        WHERE ID_Establecimiento = @ID_Establecimiento;
        
        SET @Mensaje = 'Establecimiento actualizado correctamente';
    END TRY
    BEGIN CATCH
        SET @Mensaje = 'Error al actualizar establecimiento: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 3. Modificacion de tipos de habitacion 

CREATE OR ALTER PROCEDURE sp_ActualizarTipoHabitacion
    @ID_Tipo_Habitacion INT,
    @Nombre VARCHAR(50),
    @Descripcion TEXT = NULL,
    @TipoCama VARCHAR(50) = NULL,
    @Precio DECIMAL(10,2),
    @Cantidad INT,
    @Mensaje VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Verificar que existe el tipo de habitación
        IF NOT EXISTS (SELECT 1 FROM Habitacion_Tipo WHERE ID_Tipo_Habitacion = @ID_Tipo_Habitacion)
        BEGIN
            SET @Mensaje = 'Error: El tipo de habitación no existe';
            RETURN;
        END
        
        -- Validar precio y cantidad
        IF @Precio <= 0 OR @Cantidad <= 0
        BEGIN
            SET @Mensaje = 'Error: El precio y la cantidad deben ser mayores a cero';
            RETURN;
        END
        
        -- Actualizar el tipo de habitación
        UPDATE Habitacion_Tipo
        SET Nombre = @Nombre,
            Descripcion = @Descripcion,
            Tipo_Cama = @TipoCama,
            Precio = @Precio,
            Cantidad = @Cantidad
        WHERE ID_Tipo_Habitacion = @ID_Tipo_Habitacion;
        
        SET @Mensaje = 'Tipo de habitación actualizado correctamente';
    END TRY
    BEGIN CATCH
        SET @Mensaje = 'Error al actualizar tipo de habitación: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 4. Modificacion a los clientes 

CREATE OR ALTER PROCEDURE sp_ActualizarCliente
    @ID_Cliente INT,
    @Nombre VARCHAR(50),
    @Apellido1 VARCHAR(50),
    @Apellido2 VARCHAR(50) = NULL,
    @FechaNacimiento DATE,
    @PaisResidencia VARCHAR(50),
    @ID_Direccion INT = NULL,
    @Telefono1 VARCHAR(20) = NULL,
    @Telefono2 VARCHAR(20) = NULL,
    @Telefono3 VARCHAR(20) = NULL,
    @Email VARCHAR(100) = NULL,
    @Mensaje VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Verificar que existe el cliente
        IF NOT EXISTS (SELECT 1 FROM Clientes WHERE ID_Cliente = @ID_Cliente)
        BEGIN
            SET @Mensaje = 'Error: El cliente no existe';
            RETURN;
        END
        
        -- Validar fecha de nacimiento
        IF @FechaNacimiento > GETDATE()
        BEGIN
            SET @Mensaje = 'Error: La fecha de nacimiento no puede ser futura';
            RETURN;
        END
        
        -- Validar dirección si se proporciona
        IF @ID_Direccion IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Direcciones WHERE ID_Direccion = @ID_Direccion)
        BEGIN
            SET @Mensaje = 'Error: La dirección no existe';
            RETURN;
        END
        
        -- Actualizar el cliente
        UPDATE Clientes
        SET Nombre = @Nombre,
            Apellido1 = @Apellido1,
            Apellido2 = @Apellido2,
            Fecha_Nacimiento = @FechaNacimiento,
            Pais_Residencia = @PaisResidencia,
            ID_Direccion = @ID_Direccion,
            Telefono1 = @Telefono1,
            Telefono2 = @Telefono2,
            Telefono3 = @Telefono3,
            Email = @Email
        WHERE ID_Cliente = @ID_Cliente;
        
        SET @Mensaje = 'Cliente actualizado correctamente';
    END TRY
    BEGIN CATCH
        SET @Mensaje = 'Error al actualizar cliente: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 5. Modificacion de reservaciones

CREATE OR ALTER PROCEDURE sp_ActualizarReservacion
    @ID_Reservacion INT,
    @Fecha_Ingreso DATE,
    @Fecha_Salida DATE,
    @Hora_Ingreso TIME = NULL,
    @Hora_Salida TIME = NULL,
    @Cantidad_Personas INT,
    @Tiene_Vehiculo BIT = 0,
    @Mensaje VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Verificar que existe la reservación y está activa
        IF NOT EXISTS (SELECT 1 FROM Reservaciones WHERE ID_Reservacion = @ID_Reservacion AND Activa = 1)
        BEGIN
            SET @Mensaje = 'Error: La reservación no existe o ya está completada';
            RETURN;
        END
        
        -- Validar fechas
        IF @Fecha_Ingreso >= @Fecha_Salida
        BEGIN
            SET @Mensaje = 'Error: La fecha de ingreso debe ser anterior a la fecha de salida';
            RETURN;
        END
        
        -- Validar cantidad de personas
        IF @Cantidad_Personas <= 0
        BEGIN
            SET @Mensaje = 'Error: La cantidad de personas debe ser mayor a cero';
            RETURN;
        END
        
        -- Usar valores por defecto si son NULL
        SET @Hora_Ingreso = ISNULL(@Hora_Ingreso, '14:00:00');
        SET @Hora_Salida = ISNULL(@Hora_Salida, '12:00:00');
        
        -- Obtener ID de la habitación
        DECLARE @ID_Habitacion INT;
        SELECT @ID_Habitacion = ID_Habitacion FROM Reservaciones WHERE ID_Reservacion = @ID_Reservacion;
        
        -- Validar disponibilidad para las nuevas fechas (excluyendo esta reservación)
        IF EXISTS (
            SELECT 1 FROM Reservaciones
            WHERE ID_Habitacion = @ID_Habitacion
            AND Activa = 1
            AND ID_Reservacion <> @ID_Reservacion
            AND (
                (CAST(@Fecha_Ingreso AS DATETIME) + CAST(@Hora_Ingreso AS DATETIME) < 
                 CAST(Fecha_Salida AS DATETIME) + CAST(Hora_Salida AS DATETIME))
                AND
                (CAST(@Fecha_Salida AS DATETIME) + CAST(@Hora_Salida AS DATETIME) > 
                 CAST(Fecha_Ingreso AS DATETIME) + CAST(Hora_Ingreso AS DATETIME))
            )
        )
        BEGIN
            SET @Mensaje = 'Error: Habitación no disponible en las nuevas fechas/horas';
            RETURN;
        END
        
        -- Actualizar la reservacion
        UPDATE Reservaciones
        SET Fecha_Ingreso = @Fecha_Ingreso,
            Hora_Ingreso = @Hora_Ingreso,
            Fecha_Salida = @Fecha_Salida,
            Hora_Salida = @Hora_Salida,
            Cantidad_Personas = @Cantidad_Personas,
            Tiene_Vehiculo = @Tiene_Vehiculo
        WHERE ID_Reservacion = @ID_Reservacion;
        
        SET @Mensaje = 'Reservación actualizada correctamente';
    END TRY
    BEGIN CATCH
        SET @Mensaje = 'Error al actualizar reservación: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 6. Modificacion de empresas de recreacion 

CREATE OR ALTER PROCEDURE sp_ActualizarEmpresaRecreacion
    @ID_Empresa INT,
    @Nombre VARCHAR(100),
    @Email VARCHAR(100) = NULL,
    @Telefono VARCHAR(20) = NULL,
    @ContactoNombre VARCHAR(100) = NULL,
    @ID_Direccion INT = NULL,
    @Descripcion TEXT = NULL,
    @Mensaje VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Verificar que existe la empresa
        IF NOT EXISTS (SELECT 1 FROM Empresas_Recreacion WHERE ID_Empresa = @ID_Empresa)
        BEGIN
            SET @Mensaje = 'Error: La empresa no existe';
            RETURN;
        END
        
        -- Validar dirección si se proporciona
        IF @ID_Direccion IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Direcciones WHERE ID_Direccion = @ID_Direccion)
        BEGIN
            SET @Mensaje = 'Error: La dirección no existe';
            RETURN;
        END
        
        -- Actualizar la empresa
        UPDATE Empresas_Recreacion
        SET Nombre = @Nombre,
            Email = @Email,
            Telefono = @Telefono,
            Contacto_Nombre = @ContactoNombre,
            ID_Direccion = @ID_Direccion,
            Descripcion = @Descripcion
        WHERE ID_Empresa = @ID_Empresa;
        
        SET @Mensaje = 'Empresa de recreación actualizada correctamente';
    END TRY
    BEGIN CATCH
        SET @Mensaje = 'Error al actualizar empresa: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- SECCION PARA ELIMINAR VALORES DE TABLAS

-- 1. Eliminar Direccion

CREATE OR ALTER PROCEDURE sp_EliminarDireccion
    @ID_Direccion INT,
    @Mensaje VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Verificar que existe la dirección
        IF NOT EXISTS (SELECT 1 FROM Direcciones WHERE ID_Direccion = @ID_Direccion)
        BEGIN
            SET @Mensaje = 'Error: La dirección no existe';
            RETURN;
        END
        
        -- Verificar que no está siendo usada por establecimientos o clientes
        IF EXISTS (SELECT 1 FROM Establecimiento_Hospedaje WHERE ID_Direccion = @ID_Direccion) OR
           EXISTS (SELECT 1 FROM Clientes WHERE ID_Direccion = @ID_Direccion) OR
           EXISTS (SELECT 1 FROM Empresas_Recreacion WHERE ID_Direccion = @ID_Direccion)
        BEGIN
            SET @Mensaje = 'Error: La dirección está asociada a otros registros y no puede ser eliminada';
            RETURN;
        END
        
        -- Eliminar la dirección
        DELETE FROM Direcciones
        WHERE ID_Direccion = @ID_Direccion;
        
        SET @Mensaje = 'Dirección eliminada correctamente';
    END TRY
    BEGIN CATCH
        SET @Mensaje = 'Error al eliminar dirección: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 2. Eliminar Establecimiento

CREATE OR ALTER PROCEDURE sp_EliminarEstablecimiento
    @ID_Establecimiento INT,
    @Mensaje VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Verificar que existe el establecimiento
        IF NOT EXISTS (SELECT 1 FROM Establecimiento_Hospedaje WHERE ID_Establecimiento = @ID_Establecimiento)
        BEGIN
            SET @Mensaje = 'Error: El establecimiento no existe';
            RETURN;
        END
        
        -- Verificar que no tiene habitaciones asociadas
        IF EXISTS (SELECT 1 FROM Habitacion_Tipo WHERE ID_Establecimiento = @ID_Establecimiento)
        BEGIN
            SET @Mensaje = 'Error: No se puede eliminar el establecimiento porque tiene habitaciones asociadas';
            RETURN;
        END
        
        -- Iniciar transacción
        BEGIN TRANSACTION;
        
        -- Eliminar relaciones con servicios primero
        DELETE FROM Establecimiento_Servicios
        WHERE ID_Establecimiento = @ID_Establecimiento;
        
        -- Eliminar relaciones con empresas de recreación
        DELETE FROM Establecimiento_Socios
        WHERE ID_Establecimiento_Hospedaje = @ID_Establecimiento;
        
        -- Eliminar el establecimiento
        DELETE FROM Establecimiento_Hospedaje
        WHERE ID_Establecimiento = @ID_Establecimiento;
        
        COMMIT TRANSACTION;
        
        SET @Mensaje = 'Establecimiento eliminado correctamente';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        SET @Mensaje = 'Error al eliminar establecimiento: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 3. Eliminacion de Tipos de Habitacion 

CREATE OR ALTER PROCEDURE sp_EliminarTipoHabitacion
    @ID_Tipo_Habitacion INT,
    @Mensaje VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Verificar que existe el tipo de habitación
        IF NOT EXISTS (SELECT 1 FROM Habitacion_Tipo WHERE ID_Tipo_Habitacion = @ID_Tipo_Habitacion)
        BEGIN
            SET @Mensaje = 'Error: El tipo de habitación no existe';
            RETURN;
        END
        
        -- Verificar que no tiene habitaciones físicas asociadas
        IF EXISTS (SELECT 1 FROM Habitaciones WHERE ID_Tipo_Habitacion = @ID_Tipo_Habitacion)
        BEGIN
            SET @Mensaje = 'Error: No se puede eliminar el tipo de habitación porque tiene habitaciones físicas asociadas';
            RETURN;
        END
        
        BEGIN TRANSACTION;
        
        DELETE FROM Habitacion_Comodidades
        WHERE ID_Tipo_Habitacion = @ID_Tipo_Habitacion;
        

        DELETE FROM Habitacion_Tipo
        WHERE ID_Tipo_Habitacion = @ID_Tipo_Habitacion;
        
        COMMIT TRANSACTION;
        
        SET @Mensaje = 'Tipo de habitación eliminado correctamente';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        SET @Mensaje = 'Error al eliminar tipo de habitación: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 4. Eliminacion de clientes 

CREATE OR ALTER PROCEDURE sp_EliminarCliente
    @ID_Cliente INT,
    @Mensaje VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Verificar que existe el cliente
        IF NOT EXISTS (SELECT 1 FROM Clientes WHERE ID_Cliente = @ID_Cliente)
        BEGIN
            SET @Mensaje = 'Error: El cliente no existe';
            RETURN;
        END
        
        -- Verificar que no tiene reservaciones activas
        IF EXISTS (SELECT 1 FROM Reservaciones WHERE ID_Cliente = @ID_Cliente AND Activa = 1)
        BEGIN
            SET @Mensaje = 'Error: No se puede eliminar el cliente porque tiene reservaciones activas';
            RETURN;
        END
        
        -- Eliminar el cliente
        DELETE FROM Clientes
        WHERE ID_Cliente = @ID_Cliente;
        
        SET @Mensaje = 'Cliente eliminado correctamente';
    END TRY
    BEGIN CATCH
        SET @Mensaje = 'Error al eliminar cliente: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 5. Eliminacion de Reservaciones 

CREATE OR ALTER PROCEDURE sp_EliminarReservacion
    @ID_Reservacion INT,
    @Mensaje VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Verificar que existe la reservación
        IF NOT EXISTS (SELECT 1 FROM Reservaciones WHERE ID_Reservacion = @ID_Reservacion)
        BEGIN
            SET @Mensaje = 'Error: La reservación no existe';
            RETURN;
        END
        
        -- Obtener información de la reservación
        DECLARE @ID_Habitacion INT, @Activa BIT;
        SELECT @ID_Habitacion = ID_Habitacion, @Activa = Activa 
        FROM Reservaciones 
        WHERE ID_Reservacion = @ID_Reservacion;
        
        -- Si está activa, liberar la habitación
        IF @Activa = 1
        BEGIN
            UPDATE Habitaciones
            SET Estado = 'Disponible'
            WHERE ID_Habitacion = @ID_Habitacion;
        END
        
        -- Eliminar la reservación
        DELETE FROM Reservaciones
        WHERE ID_Reservacion = @ID_Reservacion;
        
        SET @Mensaje = 'Reservación eliminada correctamente';
    END TRY
    BEGIN CATCH
        SET @Mensaje = 'Error al eliminar reservación: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 6. Eliminacion de empresas de recreacion 

CREATE OR ALTER PROCEDURE sp_EliminarEmpresaRecreacion
    @ID_Empresa INT,
    @Mensaje VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Verificar que existe la empresa
        IF NOT EXISTS (SELECT 1 FROM Empresas_Recreacion WHERE ID_Empresa = @ID_Empresa)
        BEGIN
            SET @Mensaje = 'Error: La empresa no existe';
            RETURN;
        END
        
        -- Verificar que no tiene actividades asociadas
        IF EXISTS (SELECT 1 FROM Empresa_Actividades WHERE ID_Empresa = @ID_Empresa)
        BEGIN
            SET @Mensaje = 'Error: No se puede eliminar la empresa porque tiene actividades asociadas';
            RETURN;
        END
        
        -- Verificar que no tiene compras asociadas (a través de Empresa_Actividades)
        IF EXISTS (
            SELECT 1 
            FROM Compras_Actividades ca
            JOIN Empresa_Actividades ea ON ca.ID_Actividad_Empresa = ea.ID_Actividad_Empresa
            WHERE ea.ID_Empresa = @ID_Empresa
        )
        BEGIN
            SET @Mensaje = 'Error: No se puede eliminar la empresa porque tiene compras asociadas';
            RETURN;
        END
        
        -- Iniciar transacción
        BEGIN TRANSACTION;
        
        -- Eliminar relaciones con establecimientos primero
        DELETE FROM Establecimiento_Socios
        WHERE ID_Empresa_Recreacion = @ID_Empresa;
        
        -- Eliminar la empresa
        DELETE FROM Empresas_Recreacion
        WHERE ID_Empresa = @ID_Empresa;
        
        COMMIT TRANSACTION;
        
        SET @Mensaje = 'Empresa de recreación eliminada correctamente';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        SET @Mensaje = 'Error al eliminar empresa: ' + ERROR_MESSAGE();
    END CATCH
END;
GO