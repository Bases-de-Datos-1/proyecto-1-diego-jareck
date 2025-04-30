-- Vistas 
USE PY1BD;
GO 

-- Vistas Completas Generales 

-- Vista de Todos los establecimientos 
select * from vw_Establecimientos

CREATE OR ALTER VIEW vw_Establecimientos AS
SELECT 
    eh.ID_Establecimiento,
    eh.Nombre,
    eh.Cedula_Juridica,
    eh.Tipo,
    -- Información de ubicación (solo nombres, sin códigos)
    p.Nombre AS Provincia,
    c.Nombre AS Canton,
    d.Nombre AS Distrito,
    b.Nombre AS Barrio,
    dir.Senas_Exactas,
    dir.GPS,
    -- Información de contacto
    eh.Telefono1,
    eh.Telefono2,
    eh.Email,
    eh.Web_URL,
    -- Redes sociales
    eh.Facebook_URL,
    eh.Instagram_URL,
    eh.Youtube_URL,
    eh.Tiktok_URL,
    eh.Airbnb_URL,
    eh.THREADS_URL,
    eh.X_URL,
    -- Información estadística
    (SELECT COUNT(*) FROM Habitacion_Tipo ht WHERE ht.ID_Establecimiento = eh.ID_Establecimiento) AS Tipos_Habitacion,
    (SELECT COUNT(*) FROM Habitaciones h 
     JOIN Habitacion_Tipo ht ON h.ID_Tipo_Habitacion = ht.ID_Tipo_Habitacion 
     WHERE ht.ID_Establecimiento = eh.ID_Establecimiento) AS Total_Habitaciones,
    (SELECT COUNT(*) FROM Reservaciones r 
     JOIN Habitaciones h ON r.ID_Habitacion = h.ID_Habitacion
     JOIN Habitacion_Tipo ht ON h.ID_Tipo_Habitacion = ht.ID_Tipo_Habitacion
     WHERE ht.ID_Establecimiento = eh.ID_Establecimiento) AS Total_Reservaciones,
    -- Servicios ofrecidos
    (
        SELECT STRING_AGG(s.Nombre, ', ')
        FROM Establecimiento_Servicios es
        JOIN Servicios s ON es.ID_Servicio = s.ID_Servicio
        WHERE es.ID_Establecimiento = eh.ID_Establecimiento
    ) AS Servicios_Ofrecidos,
    -- Empresas de recreación asociadas
    (
        SELECT STRING_AGG(er.Nombre, ', ')
        FROM Establecimiento_Socios es
        JOIN Empresas_Recreacion er ON es.ID_Empresa_Recreacion = er.ID_Empresa
        WHERE es.ID_Establecimiento_Hospedaje = eh.ID_Establecimiento
    ) AS Empresas_Recreacion_Asociadas,
    -- Rango de precios
    (SELECT MIN(Precio) FROM Habitacion_Tipo WHERE ID_Establecimiento = eh.ID_Establecimiento) AS Precio_Minimo,
    (SELECT MAX(Precio) FROM Habitacion_Tipo WHERE ID_Establecimiento = eh.ID_Establecimiento) AS Precio_Maximo
FROM 
    Establecimiento_Hospedaje eh
    JOIN Direcciones dir ON eh.ID_Direccion = dir.ID_Direccion
    JOIN Provincias p ON dir.Codigo_Provincia = p.Codigo_Provincia
    JOIN Cantones c ON dir.Codigo_Provincia = c.Codigo_Provincia AND dir.Codigo_Canton = c.Codigo_Canton
    JOIN Distritos d ON dir.Codigo_Provincia = d.Codigo_Provincia AND dir.Codigo_Canton = d.Codigo_Canton AND dir.Codigo_Distrito = d.Codigo_Distrito
    JOIN Barrios b ON dir.Codigo_Provincia = b.Codigo_Provincia AND dir.Codigo_Canton = b.Codigo_Canton AND dir.Codigo_Distrito = b.Codigo_Distrito AND dir.Codigo_Barrio = b.Codigo_Barrio;

-- Vista de todas habitaciones
CREATE OR ALTER VIEW vw_Tipos_Habitacion AS
SELECT 
    ht.ID_Tipo_Habitacion,
    ht.ID_Establecimiento,
    eh.Nombre AS Nombre_Establecimiento,
    eh.Tipo AS Tipo_Establecimiento,
    ht.Nombre AS Tipo_Habitacion,
    CAST(ht.Descripcion AS VARCHAR(MAX)) AS Descripcion,
    ht.Tipo_Cama,
    ht.Precio,
    ht.Cantidad,
    (
        SELECT STRING_AGG(c.Nombre, ', ')
        FROM Habitacion_Comodidades hc
        JOIN Comodidades c ON hc.ID_Comodidad = c.ID_Comodidad
        WHERE hc.ID_Tipo_Habitacion = ht.ID_Tipo_Habitacion
    ) AS Comodidades,
    (
        SELECT COUNT(*) 
        FROM Habitaciones h 
        WHERE h.ID_Tipo_Habitacion = ht.ID_Tipo_Habitacion
    ) AS Habitaciones_Registradas
FROM 
    Habitacion_Tipo ht
    JOIN Establecimiento_Hospedaje eh ON ht.ID_Establecimiento = eh.ID_Establecimiento;

-- Vista de todos los clientes

CREATE OR ALTER VIEW vw_Clientes AS
SELECT 
    c.ID_Cliente,
    c.Nombre,
    c.Apellido1,
    c.Apellido2,
    c.Fecha_Nacimiento,
    DATEDIFF(YEAR, c.Fecha_Nacimiento, GETDATE()) AS Edad,
    c.Cedula,
    c.Pais_Residencia,
    p.Nombre AS Provincia,
    ca.Nombre AS Canton,
    d.Nombre AS Distrito,
    dir.Senas_Exactas,
    c.Telefono1,
    c.Telefono2,
    c.Telefono3,
    c.Email,
    (
        SELECT COUNT(*) 
        FROM Reservaciones r 
        WHERE r.ID_Cliente = c.ID_Cliente
    ) AS Total_Reservaciones,
    (
        SELECT MAX(Fecha_Ingreso) 
        FROM Reservaciones r 
        WHERE r.ID_Cliente = c.ID_Cliente
    ) AS Ultima_Reservacion
FROM 
    Clientes c
    LEFT JOIN Direcciones dir ON c.ID_Direccion = dir.ID_Direccion
    LEFT JOIN Provincias p ON dir.Codigo_Provincia = p.Codigo_Provincia
    LEFT JOIN Cantones ca ON dir.Codigo_Provincia = ca.Codigo_Provincia AND dir.Codigo_Canton = ca.Codigo_Canton
    LEFT JOIN Distritos d ON dir.Codigo_Provincia = d.Codigo_Provincia AND dir.Codigo_Canton = d.Codigo_Canton AND dir.Codigo_Distrito = d.Codigo_Distrito;


-- Vista de Reservaciones

CREATE OR ALTER VIEW vw_Reservaciones AS
SELECT 
    r.ID_Reservacion,
    r.Numero_Reserva,
    r.ID_Cliente,
    c.Nombre + ' ' + c.Apellido1 + ISNULL(' ' + c.Apellido2, '') AS Nombre_Cliente,
    r.ID_Habitacion,
    h.Numero AS Numero_Habitacion,
    ht.ID_Tipo_Habitacion,
    ht.Nombre AS Tipo_Habitacion,
    ht.Precio AS Precio_Noche,
    r.Fecha_Ingreso,
    r.Hora_Ingreso,
    r.Fecha_Salida,
    r.Hora_Salida,
    DATEDIFF(DAY, r.Fecha_Ingreso, r.Fecha_Salida) AS Noches,
    (DATEDIFF(DAY, r.Fecha_Ingreso, r.Fecha_Salida) * ht.Precio) AS Total_Estimado,
    r.Cantidad_Personas,
    r.Tiene_Vehiculo,
    CASE WHEN r.Activa = 1 THEN 'Activa' ELSE 'Completada' END AS Estado,
    eh.ID_Establecimiento,
    eh.Nombre AS Nombre_Establecimiento,
    f.ID_Factura,
    f.Numero_Factura,
    f.Total AS Total_Facturado
FROM 
    Reservaciones r
    JOIN Clientes c ON r.ID_Cliente = c.ID_Cliente
    JOIN Habitaciones h ON r.ID_Habitacion = h.ID_Habitacion
    JOIN Habitacion_Tipo ht ON h.ID_Tipo_Habitacion = ht.ID_Tipo_Habitacion
    JOIN Establecimiento_Hospedaje eh ON ht.ID_Establecimiento = eh.ID_Establecimiento
    LEFT JOIN Facturas f ON r.ID_Reservacion = f.ID_Reservacion;

-- Vista completa de las Habitaciones

CREATE OR ALTER VIEW vw_Habitaciones AS
SELECT 
    h.ID_Habitacion,
    h.Numero,
    h.Estado,
    h.ID_Tipo_Habitacion,
    ht.Nombre AS Tipo_Habitacion,
    ht.Descripcion AS Descripcion_Tipo,
    ht.Precio AS Precio_Noche,
    ht.Tipo_Cama,
    eh.ID_Establecimiento,
    eh.Nombre AS Nombre_Establecimiento,
    eh.Tipo AS Tipo_Establecimiento,
    (
        SELECT STRING_AGG(c.Nombre, ', ')
        FROM Habitacion_Comodidades hc
        JOIN Comodidades c ON hc.ID_Comodidad = c.ID_Comodidad
        WHERE hc.ID_Tipo_Habitacion = ht.ID_Tipo_Habitacion
    ) AS Comodidades,
    (
        SELECT TOP 1 r.Fecha_Ingreso
        FROM Reservaciones r
        WHERE r.ID_Habitacion = h.ID_Habitacion
        AND r.Activa = 1
        ORDER BY r.Fecha_Ingreso
    ) AS Proxima_Reservacion,
    (
        SELECT COUNT(*)
        FROM Reservaciones r
        WHERE r.ID_Habitacion = h.ID_Habitacion
    ) AS Total_Reservaciones
FROM 
    Habitaciones h
    JOIN Habitacion_Tipo ht ON h.ID_Tipo_Habitacion = ht.ID_Tipo_Habitacion
    JOIN Establecimiento_Hospedaje eh ON ht.ID_Establecimiento = eh.ID_Establecimiento;



-- Vista completa de las facturas 

CREATE OR ALTER VIEW vw_Facturas AS
SELECT 
    f.ID_Factura,
    f.Numero_Factura,
    f.Fecha_Factura,
    f.ID_Reservacion,
    r.Numero_Reserva,
    r.ID_Cliente,
    c.Nombre + ' ' + c.Apellido1 + ISNULL(' ' + c.Apellido2, '') AS Nombre_Cliente,
    r.ID_Habitacion,
    h.Numero AS Numero_Habitacion,
    ht.Nombre AS Tipo_Habitacion,
    r.Fecha_Ingreso,
    r.Fecha_Salida,
    DATEDIFF(DAY, r.Fecha_Ingreso, r.Fecha_Salida) AS Noches,
    f.Subtotal,
    f.Impuestos,
    f.Total,
    f.Metodo_Pago,
    f.Detalles,
    eh.ID_Establecimiento,
    eh.Nombre AS Nombre_Establecimiento,
    eh.Cedula_Juridica AS Cedula_Establecimiento
FROM 
    Facturas f
    JOIN Reservaciones r ON f.ID_Reservacion = r.ID_Reservacion
    JOIN Clientes c ON r.ID_Cliente = c.ID_Cliente
    JOIN Habitaciones h ON r.ID_Habitacion = h.ID_Habitacion
    JOIN Habitacion_Tipo ht ON h.ID_Tipo_Habitacion = ht.ID_Tipo_Habitacion
    JOIN Establecimiento_Hospedaje eh ON ht.ID_Establecimiento = eh.ID_Establecimiento;


-- Vista completa de empresas de recreacion 

CREATE OR ALTER VIEW vw_Empresas_Recreacion AS
SELECT 
    er.ID_Empresa,
    er.Nombre,
    er.Cedula_Juridica,
    er.Email,
    er.Telefono,
    er.Contacto_Nombre,
    p.Nombre AS Provincia,
    c.Nombre AS Canton,
    d.Nombre AS Distrito,
    dir.Senas_Exactas,
    dir.GPS,
    CAST(er.Descripcion AS VARCHAR(MAX)) AS Descripcion,
    (
        SELECT STRING_AGG(ta.Nombre, ', ')
        FROM Empresa_Actividades ea
        JOIN Tipos_Actividad ta ON ea.ID_Tipo_Actividad = ta.ID_Tipo_Actividad
        WHERE ea.ID_Empresa = er.ID_Empresa
    ) AS Actividades_Ofrecidas,
    (
        SELECT COUNT(*)
        FROM Compras_Actividades ca
        JOIN Empresa_Actividades ea ON ca.ID_Actividad_Empresa = ea.ID_Actividad_Empresa
        WHERE ea.ID_Empresa = er.ID_Empresa
    ) AS Total_Compras,
    (
        SELECT COUNT(*)
        FROM Establecimiento_Socios es
        WHERE es.ID_Empresa_Recreacion = er.ID_Empresa
    ) AS Establecimientos_Asociados
FROM 
    Empresas_Recreacion er
    LEFT JOIN Direcciones dir ON er.ID_Direccion = dir.ID_Direccion
    LEFT JOIN Provincias p ON dir.Codigo_Provincia = p.Codigo_Provincia
    LEFT JOIN Cantones c ON dir.Codigo_Provincia = c.Codigo_Provincia AND dir.Codigo_Canton = c.Codigo_Canton
    LEFT JOIN Distritos d ON dir.Codigo_Provincia = d.Codigo_Provincia AND dir.Codigo_Canton = d.Codigo_Canton AND dir.Codigo_Distrito = d.Codigo_Distrito;


-- Vista completa de las Compras de Actividades

CREATE OR ALTER VIEW vw_Compras_Actividades AS
SELECT 
    ca.ID_Compra,
    ca.ID_Cliente,
    cl.Nombre + ' ' + cl.Apellido1 + ISNULL(' ' + cl.Apellido2, '') AS Nombre_Cliente,
    ca.ID_Actividad_Empresa,
    ta.Nombre AS Tipo_Actividad,
    er.ID_Empresa,
    er.Nombre AS Nombre_Empresa,
    ea.Precio AS Precio_Unitario,
    ca.Fecha_Compra,
    ca.Fecha_Actividad,
    ca.Cantidad_Personas,
    ca.Subtotal,
    ca.Impuestos,
    ca.Total,
    ca.Metodo_Pago,
    eh.ID_Establecimiento,
    eh.Nombre AS Establecimiento_Recomendador,
    es.Descripcion_Recomendacion
FROM 
    Compras_Actividades ca
    JOIN Clientes cl ON ca.ID_Cliente = cl.ID_Cliente
    JOIN Empresa_Actividades ea ON ca.ID_Actividad_Empresa = ea.ID_Actividad_Empresa
    JOIN Tipos_Actividad ta ON ea.ID_Tipo_Actividad = ta.ID_Tipo_Actividad
    JOIN Empresas_Recreacion er ON ea.ID_Empresa = er.ID_Empresa
    LEFT JOIN Establecimiento_Socios es ON er.ID_Empresa = es.ID_Empresa_Recreacion
    LEFT JOIN Establecimiento_Hospedaje eh ON es.ID_Establecimiento_Hospedaje = eh.ID_Establecimiento;




-- Procedures para Busquedas

CREATE OR ALTER PROCEDURE sp_BuscarEstablecimientos
    @Nombre VARCHAR(100) = NULL,
    @Tipo VARCHAR(50) = NULL,
    @Provincia VARCHAR(50) = NULL,
    @Canton VARCHAR(50) = NULL,
    @Servicio VARCHAR(50) = NULL,
    @PrecioMax DECIMAL(10,2) = NULL,
    @PrecioMin DECIMAL(10,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Primero obtenemos los establecimientos que cumplen con los filtros básicos
    SELECT 
        e.ID_Establecimiento,
        e.Nombre,
        e.Tipo,
        e.Provincia,
        e.Canton,
        e.Distrito,
        e.Telefono1,
        e.Email,
        e.Web_URL,
        e.Servicios_Ofrecidos,
        e.Precio_Minimo,
        e.Precio_Maximo,
        e.Facebook_URL,
        e.Instagram_URL
    FROM 
        vw_Establecimientos e
    WHERE 
        (@Nombre IS NULL OR e.Nombre LIKE '%' + @Nombre + '%')
        AND (@Tipo IS NULL OR e.Tipo = @Tipo)
        AND (@Provincia IS NULL OR e.Provincia = @Provincia)
        AND (@Canton IS NULL OR e.Canton = @Canton)
        AND (@PrecioMax IS NULL OR e.Precio_Minimo <= @PrecioMax)
        AND (@PrecioMin IS NULL OR e.Precio_Minimo >= @PrecioMin)
        AND (
            @Servicio IS NULL 
            OR EXISTS (
                SELECT 1 
                FROM Establecimiento_Servicios es
                JOIN Servicios s ON es.ID_Servicio = s.ID_Servicio
                WHERE es.ID_Establecimiento = e.ID_Establecimiento
                AND s.Nombre LIKE '%' + @Servicio + '%'
            )
        )
    ORDER BY 
        CASE WHEN @PrecioMin IS NOT NULL OR @PrecioMax IS NOT NULL 
             THEN e.Precio_Minimo ELSE 1 END;
END;


CREATE OR ALTER PROCEDURE sp_BuscarClientes
    @TextoBusqueda VARCHAR(100) = NULL,
    @PaisResidencia VARCHAR(50) = NULL,
    @Provincia VARCHAR(50) = NULL,
    @Canton VARCHAR(50) = NULL,
    @SoloConReservaciones BIT = 0  -- Por si se desea buscar clientes con reservaciones especificamente 
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        c.ID_Cliente,
        c.Nombre,
        c.Apellido1,
        c.Apellido2,
        c.Nombre + ' ' + c.Apellido1 + ISNULL(' ' + c.Apellido2, '') AS NombreCompleto,
        c.Fecha_Nacimiento,
        DATEDIFF(YEAR, c.Fecha_Nacimiento, GETDATE()) AS Edad,
        c.Cedula,
        c.Pais_Residencia,
        c.Provincia,
        c.Canton,
        c.Distrito,
        c.Telefono1,
        c.Telefono2,
        c.Telefono3,
        c.Email,
        c.Total_Reservaciones,
        c.Ultima_Reservacion
    FROM 
        vw_Clientes c
    WHERE 
        (
            @TextoBusqueda IS NULL 
            OR c.Nombre LIKE '%' + @TextoBusqueda + '%'
            OR c.Apellido1 LIKE '%' + @TextoBusqueda + '%'
            OR c.Apellido2 LIKE '%' + @TextoBusqueda + '%'
            OR c.Cedula LIKE '%' + @TextoBusqueda + '%'
        )
        AND (@PaisResidencia IS NULL OR c.Pais_Residencia = @PaisResidencia)
        AND (@Provincia IS NULL OR c.Provincia = @Provincia)
        AND (@Canton IS NULL OR c.Canton = @Canton)
        AND (@SoloConReservaciones = 0 OR c.Total_Reservaciones > 0)
    ORDER BY 
        c.Apellido1, c.Apellido2, c.Nombre;
END;

-- Procedimiento para la busqueda especifica de Empresas de recreacion

CREATE OR ALTER PROCEDURE sp_BuscarEmpresasRecreacion
    @TextoBusqueda VARCHAR(100) = NULL,
    @TipoActividad VARCHAR(50) = NULL,
    @Provincia VARCHAR(50) = NULL,
    @Canton VARCHAR(50) = NULL,
    @PrecioMax DECIMAL(10,2) = NULL,
    @PrecioMin DECIMAL(10,2) = NULL,
    @SoloConEstablecimientosAsociados BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Primero calculamos el precio mínimo para cada empresa que cumple los filtros
    WITH EmpresasFiltradas AS (
        SELECT 
            e.*,
            (
                SELECT MIN(ea.Precio)
                FROM Empresa_Actividades ea
                WHERE ea.ID_Empresa = e.ID_Empresa
                AND (@TipoActividad IS NULL OR EXISTS (
                    SELECT 1 FROM Tipos_Actividad ta
                    WHERE ta.ID_Tipo_Actividad = ea.ID_Tipo_Actividad
                    AND ta.Nombre LIKE '%' + @TipoActividad + '%'
                ))
            ) AS PrecioMinimoFiltrado
        FROM 
            vw_Empresas_Recreacion e
        WHERE 
            (
                @TextoBusqueda IS NULL 
                OR e.Nombre LIKE '%' + @TextoBusqueda + '%'
                OR e.Contacto_Nombre LIKE '%' + @TextoBusqueda + '%'
                OR e.Cedula_Juridica LIKE '%' + @TextoBusqueda + '%'
                OR e.Actividades_Ofrecidas LIKE '%' + @TextoBusqueda + '%'
            )
            AND (@Provincia IS NULL OR e.Provincia = @Provincia)
            AND (@Canton IS NULL OR e.Canton = @Canton)
            AND (@SoloConEstablecimientosAsociados = 0 OR e.Establecimientos_Asociados > 0)
    )
    
    -- Luego seleccionamos y ordenamos según los parámetros
    SELECT 
        ID_Empresa,
        Nombre,
        Cedula_Juridica,
        Email,
        Telefono,
        Contacto_Nombre,
        Provincia,
        Canton,
        Distrito,
        Senas_Exactas,
        GPS,
        Descripcion,
        Actividades_Ofrecidas,
        Total_Compras,
        Establecimientos_Asociados,
        PrecioMinimoFiltrado AS Precio_Minimo,
        (
            SELECT MAX(ea.Precio)
            FROM Empresa_Actividades ea
            WHERE ea.ID_Empresa = EmpresasFiltradas.ID_Empresa
            AND (@TipoActividad IS NULL OR EXISTS (
                SELECT 1 FROM Tipos_Actividad ta
                WHERE ta.ID_Tipo_Actividad = ea.ID_Tipo_Actividad
                AND ta.Nombre LIKE '%' + @TipoActividad + '%'
            ))
        ) AS Precio_Maximo
    FROM 
        EmpresasFiltradas
    WHERE
        (@PrecioMax IS NULL OR PrecioMinimoFiltrado <= @PrecioMax)
        AND (@PrecioMin IS NULL OR PrecioMinimoFiltrado >= @PrecioMin)
    ORDER BY 
        CASE WHEN @PrecioMin IS NOT NULL OR @PrecioMax IS NOT NULL 
             THEN PrecioMinimoFiltrado ELSE 1 END;
END;


CREATE OR ALTER PROCEDURE sp_BuscarFacturas
    @NumeroFactura VARCHAR(20) = NULL,
    @NombreCliente VARCHAR(100) = NULL,
    @CedulaCliente VARCHAR(20) = NULL,
    @FechaInicio DATE = NULL,
    @FechaFin DATE = NULL,
    @ID_Establecimiento INT = NULL,
    @MetodoPago VARCHAR(20) = NULL,
    @MontoMinimo DECIMAL(10,2) = NULL,
    @MontoMaximo DECIMAL(10,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        f.ID_Factura,
        f.Numero_Factura,
        f.Fecha_Factura,
        f.ID_Reservacion,
        r.Numero_Reserva,
        c.ID_Cliente,
        c.Nombre + ' ' + c.Apellido1 + ISNULL(' ' + c.Apellido2, '') AS NombreCliente,
        c.Cedula,
        e.ID_Establecimiento,
        e.Nombre AS NombreEstablecimiento,
        ht.Nombre AS TipoHabitacion,
        r.Fecha_Ingreso,
        r.Fecha_Salida,
        DATEDIFF(DAY, r.Fecha_Ingreso, r.Fecha_Salida) AS Noches,
        f.Subtotal,
        f.Impuestos,
        f.Total,
        f.Metodo_Pago,
        f.Detalles
    FROM 
        Facturas f
        JOIN Reservaciones r ON f.ID_Reservacion = r.ID_Reservacion
        JOIN Clientes c ON r.ID_Cliente = c.ID_Cliente
        JOIN Habitaciones h ON r.ID_Habitacion = h.ID_Habitacion
        JOIN Habitacion_Tipo ht ON h.ID_Tipo_Habitacion = ht.ID_Tipo_Habitacion
        JOIN Establecimiento_Hospedaje e ON ht.ID_Establecimiento = e.ID_Establecimiento
    WHERE 
        (@NumeroFactura IS NULL OR f.Numero_Factura LIKE '%' + @NumeroFactura + '%')
        AND (@NombreCliente IS NULL OR (c.Nombre + ' ' + c.Apellido1 + ISNULL(' ' + c.Apellido2, '')) LIKE '%' + @NombreCliente + '%')
        AND (@CedulaCliente IS NULL OR c.Cedula LIKE '%' + @CedulaCliente + '%')
        AND (@FechaInicio IS NULL OR f.Fecha_Factura >= @FechaInicio)
        AND (@FechaFin IS NULL OR f.Fecha_Factura <= @FechaFin)
        AND (@ID_Establecimiento IS NULL OR e.ID_Establecimiento = @ID_Establecimiento)
        AND (@MetodoPago IS NULL OR f.Metodo_Pago = @MetodoPago)
        AND (@MontoMinimo IS NULL OR f.Total >= @MontoMinimo)
        AND (@MontoMaximo IS NULL OR f.Total <= @MontoMaximo)
    ORDER BY 
        f.Fecha_Factura DESC;
END;


CREATE OR ALTER PROCEDURE sp_BuscarComprasActividades
    @NombreCliente VARCHAR(100) = NULL,
    @CedulaCliente VARCHAR(20) = NULL,
    @NombreActividad VARCHAR(50) = NULL,
    @NombreEmpresa VARCHAR(100) = NULL,
    @FechaInicio DATE = NULL,
    @FechaFin DATE = NULL,
    @FechaActividadInicio DATE = NULL,
    @FechaActividadFin DATE = NULL,
    @MontoMinimo DECIMAL(10,2) = NULL,
    @MontoMaximo DECIMAL(10,2) = NULL,
    @MetodoPago VARCHAR(20) = NULL,
    @ID_EstablecimientoRecomendador INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        ca.ID_Compra,
        c.ID_Cliente,
        c.Nombre + ' ' + c.Apellido1 + ISNULL(' ' + c.Apellido2, '') AS NombreCliente,
        c.Cedula,
        ca.Fecha_Compra,
        ta.ID_Tipo_Actividad,
        ta.Nombre AS TipoActividad,
        er.ID_Empresa,
        er.Nombre AS NombreEmpresa,
        ca.Fecha_Actividad,
        ca.Cantidad_Personas,
        ca.Subtotal,
        ca.Impuestos,
        ca.Total,
        ca.Metodo_Pago,
        eh.ID_Establecimiento AS ID_EstablecimientoRecomendador,
        eh.Nombre AS NombreEstablecimientoRecomendador,
        es.Descripcion_Recomendacion
    FROM 
        Compras_Actividades ca
        JOIN Clientes c ON ca.ID_Cliente = c.ID_Cliente
        JOIN Empresa_Actividades ea ON ca.ID_Actividad_Empresa = ea.ID_Actividad_Empresa
        JOIN Tipos_Actividad ta ON ea.ID_Tipo_Actividad = ta.ID_Tipo_Actividad
        JOIN Empresas_Recreacion er ON ea.ID_Empresa = er.ID_Empresa
        LEFT JOIN Establecimiento_Socios es ON er.ID_Empresa = es.ID_Empresa_Recreacion
        LEFT JOIN Establecimiento_Hospedaje eh ON es.ID_Establecimiento_Hospedaje = eh.ID_Establecimiento
    WHERE 
        (@NombreCliente IS NULL OR (c.Nombre + ' ' + c.Apellido1 + ISNULL(' ' + c.Apellido2, '')) LIKE '%' + @NombreCliente + '%')
        AND (@CedulaCliente IS NULL OR c.Cedula LIKE '%' + @CedulaCliente + '%')
        AND (@NombreActividad IS NULL OR ta.Nombre LIKE '%' + @NombreActividad + '%')
        AND (@NombreEmpresa IS NULL OR er.Nombre LIKE '%' + @NombreEmpresa + '%')
        AND (@FechaInicio IS NULL OR ca.Fecha_Compra >= @FechaInicio)
        AND (@FechaFin IS NULL OR ca.Fecha_Compra <= @FechaFin)
        AND (@FechaActividadInicio IS NULL OR ca.Fecha_Actividad >= @FechaActividadInicio)
        AND (@FechaActividadFin IS NULL OR ca.Fecha_Actividad <= @FechaActividadFin)
        AND (@MontoMinimo IS NULL OR ca.Total >= @MontoMinimo)
        AND (@MontoMaximo IS NULL OR ca.Total <= @MontoMaximo)
        AND (@MetodoPago IS NULL OR ca.Metodo_Pago = @MetodoPago)
        AND (@ID_EstablecimientoRecomendador IS NULL OR eh.ID_Establecimiento = @ID_EstablecimientoRecomendador)
    ORDER BY 
        ca.Fecha_Compra DESC;
END;
