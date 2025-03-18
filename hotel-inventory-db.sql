-- Base de datos para sistema de inventario del hotel Secrets Tulum "Secrets Inventory"
-- Pedro Yelser Dzib Aban

CREATE DATABASE IF NOT EXISTS secrets_tulum_inventario;
USE secrets_tulum_inventario;

-- Configuración para optimizar rendimiento
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 1;

-- Tabla de Usuarios
CREATE TABLE usuario (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    auth_key VARCHAR(32) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    rol ENUM('super_admin', 'admin', 'inventario', 'consulta') NOT NULL DEFAULT 'consulta',
    last_login DATETIME,
    status TINYINT NOT NULL DEFAULT 10,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_usuario_status (status),
    INDEX idx_usuario_rol (rol)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Usuarios del sistema de inventario';

-- Tabla de Categorías
CREATE TABLE categoria (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    icon VARCHAR(50),
    codigo VARCHAR(20),
    parent_id INT UNSIGNED NULL,
    status TINYINT NOT NULL DEFAULT 10,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT UNSIGNED,
    updated_by INT UNSIGNED,
    INDEX idx_categoria_status (status),
    INDEX idx_categoria_parent (parent_id),
    FOREIGN KEY (parent_id) REFERENCES categoria(id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (created_by) REFERENCES usuario(id) ON DELETE SET NULL,
    FOREIGN KEY (updated_by) REFERENCES usuario(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Categorías de productos de inventario';

-- Tabla de Unidades de Medida
CREATE TABLE unidad_medida (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    abreviatura VARCHAR(10) NOT NULL,
    status TINYINT NOT NULL DEFAULT 10,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Unidades de medida para productos';

-- Tabla de Proveedores
CREATE TABLE proveedor (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    razon_social VARCHAR(150) NOT NULL,
    nombre_comercial VARCHAR(150),
    rfc VARCHAR(20),
    contacto_nombre VARCHAR(100),
    contacto_email VARCHAR(100),
    contacto_telefono VARCHAR(20),
    direccion TEXT,
    ciudad VARCHAR(100),
    estado VARCHAR(100),
    cp VARCHAR(10),
    pais VARCHAR(50) DEFAULT 'México',
    dias_credito INT UNSIGNED DEFAULT 0,
    notas TEXT,
    status TINYINT NOT NULL DEFAULT 10,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT UNSIGNED,
    updated_by INT UNSIGNED,
    INDEX idx_proveedor_status (status),
    FOREIGN KEY (created_by) REFERENCES usuario(id) ON DELETE SET NULL,
    FOREIGN KEY (updated_by) REFERENCES usuario(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Proveedores de productos';

-- Tabla de Áreas/Departamentos del Hotel
CREATE TABLE area (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    responsable VARCHAR(100),
    extension VARCHAR(20),
    ubicacion VARCHAR(100),
    status TINYINT NOT NULL DEFAULT 10,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT UNSIGNED,
    updated_by INT UNSIGNED,
    INDEX idx_area_status (status),
    FOREIGN KEY (created_by) REFERENCES usuario(id) ON DELETE SET NULL,
    FOREIGN KEY (updated_by) REFERENCES usuario(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Áreas o departamentos del hotel';

-- Tabla de Almacenes
CREATE TABLE almacen (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    descripcion TEXT,
    ubicacion VARCHAR(255),
    area_id INT UNSIGNED NULL,
    responsable_id INT UNSIGNED NULL,
    tipo ENUM('principal', 'secundario', 'temporal') NOT NULL DEFAULT 'secundario',
    status TINYINT NOT NULL DEFAULT 10,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT UNSIGNED,
    updated_by INT UNSIGNED,
    INDEX idx_almacen_status (status),
    INDEX idx_almacen_area (area_id),
    INDEX idx_almacen_responsable (responsable_id),
    FOREIGN KEY (area_id) REFERENCES area(id) ON DELETE SET NULL,
    FOREIGN KEY (responsable_id) REFERENCES usuario(id) ON DELETE SET NULL,
    FOREIGN KEY (created_by) REFERENCES usuario(id) ON DELETE SET NULL,
    FOREIGN KEY (updated_by) REFERENCES usuario(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Almacenes del hotel';

-- Tabla de Productos
CREATE TABLE producto (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    categoria_id INT UNSIGNED NOT NULL,
    unidad_id INT UNSIGNED NOT NULL,
    stock_minimo DECIMAL(10,2) DEFAULT 0,
    stock_maximo DECIMAL(10,2) DEFAULT 0,
    precio_promedio DECIMAL(10,2) DEFAULT 0,
    ultimo_precio DECIMAL(10,2) DEFAULT 0,
    image VARCHAR(255),
    perecedero BOOLEAN DEFAULT FALSE,
    dias_caducidad INT UNSIGNED DEFAULT NULL,
    codigo_barras VARCHAR(50),
    notas TEXT,
    status TINYINT NOT NULL DEFAULT 10,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT UNSIGNED,
    updated_by INT UNSIGNED,
    INDEX idx_producto_codigo (codigo),
    INDEX idx_producto_nombre (nombre),
    INDEX idx_producto_status (status),
    INDEX idx_producto_categoria (categoria_id),
    FOREIGN KEY (categoria_id) REFERENCES categoria(id) ON UPDATE CASCADE,
    FOREIGN KEY (unidad_id) REFERENCES unidad_medida(id) ON UPDATE CASCADE,
    FOREIGN KEY (created_by) REFERENCES usuario(id) ON DELETE SET NULL,
    FOREIGN KEY (updated_by) REFERENCES usuario(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Productos del inventario';

-- Tabla de Stock (inventario actual por almacén)
CREATE TABLE stock (
    producto_id INT UNSIGNED NOT NULL,
    almacen_id INT UNSIGNED NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL DEFAULT 0,
    ubicacion_almacen VARCHAR(50),
    ultimo_movimiento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by INT UNSIGNED,
    PRIMARY KEY (producto_id, almacen_id),
    FOREIGN KEY (producto_id) REFERENCES producto(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (almacen_id) REFERENCES almacen(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (updated_by) REFERENCES usuario(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Stock actual por producto y almacén';

-- Tabla de Tipos de Movimientos
CREATE TABLE tipo_movimiento (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255),
    naturaleza ENUM('entrada', 'salida', 'ajuste', 'traslado') NOT NULL,
    requiere_autorizacion BOOLEAN DEFAULT FALSE,
    codigo VARCHAR(10) NOT NULL UNIQUE,
    status TINYINT NOT NULL DEFAULT 10
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tipos de movimientos de inventario';

-- Tabla de Movimientos Principal
CREATE TABLE movimiento (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    folio VARCHAR(20) NOT NULL UNIQUE,
    tipo_id INT UNSIGNED NOT NULL,
    fecha DATETIME NOT NULL,
    almacen_origen_id INT UNSIGNED,
    almacen_destino_id INT UNSIGNED,
    proveedor_id INT UNSIGNED,
    area_solicitante_id INT UNSIGNED,
    usuario_solicitante_id INT UNSIGNED,
    factura_referencia VARCHAR(50),
    costo_total DECIMAL(12,2) DEFAULT 0,
    notas TEXT,
    status ENUM('borrador', 'pendiente', 'aprobado', 'rechazado', 'completado', 'cancelado') NOT NULL DEFAULT 'borrador',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT UNSIGNED NOT NULL,
    updated_by INT UNSIGNED NOT NULL,
    autorizado_by INT UNSIGNED,
    autorizado_at DATETIME,
    INDEX idx_movimiento_folio (folio),
    INDEX idx_movimiento_fecha (fecha),
    INDEX idx_movimiento_tipo (tipo_id),
    INDEX idx_movimiento_status (status),
    INDEX idx_movimiento_almacen_origen (almacen_origen_id),
    INDEX idx_movimiento_almacen_destino (almacen_destino_id),
    INDEX idx_movimiento_proveedor (proveedor_id),
    FOREIGN KEY (tipo_id) REFERENCES tipo_movimiento(id),
    FOREIGN KEY (almacen_origen_id) REFERENCES almacen(id) ON DELETE RESTRICT,
    FOREIGN KEY (almacen_destino_id) REFERENCES almacen(id) ON DELETE RESTRICT,
    FOREIGN KEY (proveedor_id) REFERENCES proveedor(id) ON DELETE SET NULL,
    FOREIGN KEY (area_solicitante_id) REFERENCES area(id) ON DELETE SET NULL,
    FOREIGN KEY (usuario_solicitante_id) REFERENCES usuario(id) ON DELETE SET NULL,
    FOREIGN KEY (created_by) REFERENCES usuario(id) ON DELETE RESTRICT,
    FOREIGN KEY (updated_by) REFERENCES usuario(id) ON DELETE RESTRICT,
    FOREIGN KEY (autorizado_by) REFERENCES usuario(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Cabecera de movimientos de inventario';

-- Tabla de Detalle de Movimientos
CREATE TABLE movimiento_detalle (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    movimiento_id INT UNSIGNED NOT NULL,
    producto_id INT UNSIGNED NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    precio_unitario DECIMAL(10,2),
    subtotal DECIMAL(10,2),
    lote VARCHAR(50),
    fecha_caducidad DATE,
    notas TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_movimiento_detalle_movimiento (movimiento_id),
    INDEX idx_movimiento_detalle_producto (producto_id),
    FOREIGN KEY (movimiento_id) REFERENCES movimiento(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES producto(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Detalle de movimientos de inventario';

-- Tabla de Auditoría de Stock
CREATE TABLE stock_auditoria (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    producto_id INT UNSIGNED NOT NULL,
    almacen_id INT UNSIGNED NOT NULL,
    cantidad_anterior DECIMAL(10,2) NOT NULL,
    cantidad_nueva DECIMAL(10,2) NOT NULL,
    movimiento_id INT UNSIGNED,
    motivo VARCHAR(255) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_id INT UNSIGNED NOT NULL,
    INDEX idx_stock_auditoria_producto (producto_id),
    INDEX idx_stock_auditoria_almacen (almacen_id),
    INDEX idx_stock_auditoria_fecha (fecha),
    FOREIGN KEY (producto_id) REFERENCES producto(id) ON DELETE CASCADE,
    FOREIGN KEY (almacen_id) REFERENCES almacen(id) ON DELETE CASCADE,
    FOREIGN KEY (movimiento_id) REFERENCES movimiento(id) ON DELETE SET NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Auditoría de cambios en stock';

-- Tabla de Configuración del Sistema
CREATE TABLE configuracion (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    clave VARCHAR(50) NOT NULL UNIQUE,
    valor TEXT NOT NULL,
    descripcion VARCHAR(255),
    tipo ENUM('texto', 'numero', 'booleano', 'json', 'fecha') NOT NULL DEFAULT 'texto',
    categoria VARCHAR(50) NOT NULL DEFAULT 'general',
    editable BOOLEAN DEFAULT TRUE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by INT UNSIGNED,
    FOREIGN KEY (updated_by) REFERENCES usuario(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Configuración del sistema';

-- Insertar datos iniciales para tipos de movimiento
INSERT INTO tipo_movimiento (nombre, descripcion, naturaleza, requiere_autorizacion, codigo) VALUES
('Compra', 'Entrada de productos por compra a proveedor', 'entrada', FALSE, 'COMP'),
('Requisición', 'Salida de productos solicitados por área', 'salida', TRUE, 'REQ'),
('Devolución a Proveedor', 'Salida por devolución a proveedor', 'salida', FALSE, 'DEV'),
('Ajuste Positivo', 'Entrada por ajuste de inventario', 'ajuste', TRUE, 'AJP'),
('Ajuste Negativo', 'Salida por ajuste de inventario', 'ajuste', TRUE, 'AJN'),
('Traslado', 'Movimiento entre almacenes', 'traslado', FALSE, 'TRA'),
('Baja', 'Salida por deterioro o caducidad', 'salida', TRUE, 'BAJ'),
('Devolución Interna', 'Entrada por devolución de área', 'entrada', FALSE, 'DIN');

-- Insertar datos iniciales para unidades de medida
INSERT INTO unidad_medida (nombre, abreviatura) VALUES
('Pieza', 'pza'),
('Kilogramo', 'kg'),
('Litro', 'lt'),
('Metro', 'm'),
('Caja', 'cja'),
('Paquete', 'paq'),
('Botella', 'bot'),
('Rollo', 'roll');

-- Insertar configuración inicial del sistema
INSERT INTO configuracion (clave, valor, descripcion, tipo, categoria) VALUES
('nombre_hotel', 'Secrets Tulum', 'Nombre del hotel', 'texto', 'general'),
('logo', 'logo.png', 'Logo del hotel', 'texto', 'general'),
('movimientos_requieren_autorizacion', 'true', '¿Los movimientos requieren autorización?', 'booleano', 'inventario'),
('dias_alerta_caducidad', '30', 'Días de anticipación para alertar caducidad', 'numero', 'inventario'),
('umbral_alerta_stock_minimo', '1.2', 'Multiplicador para alertas de stock mínimo', 'numero', 'inventario'),
('correo_notificaciones', 'inventario@secretstulum.com', 'Correo para notificaciones', 'texto', 'notificaciones');

-- Crear vistas para facilitar reportes comunes

-- Vista de stock actual con información completa
CREATE OR REPLACE VIEW v_stock_actual AS
SELECT 
    s.producto_id,
    p.codigo,
    p.nombre AS producto,
    c.nombre AS categoria,
    s.almacen_id,
    a.nombre AS almacen,
    s.cantidad,
    um.abreviatura AS unidad,
    p.stock_minimo,
    p.stock_maximo,
    p.precio_promedio,
    (s.cantidad * p.precio_promedio) AS valor_total,
    CASE 
        WHEN s.cantidad <= p.stock_minimo THEN 'bajo'
        WHEN s.cantidad >= p.stock_maximo THEN 'exceso'
        ELSE 'normal'
    END AS estado_stock
FROM 
    stock s
    JOIN producto p ON s.producto_id = p.id
    JOIN categoria c ON p.categoria_id = c.id
    JOIN almacen a ON s.almacen_id = a.id
    JOIN unidad_medida um ON p.unidad_id = um.id
WHERE 
    p.status = 10 AND a.status = 10;

-- Vista de movimientos recientes con información completa
CREATE OR REPLACE VIEW v_movimientos_recientes AS
SELECT 
    m.id,
    m.folio,
    tm.nombre AS tipo_movimiento,
    tm.naturaleza,
    m.fecha,
    a_orig.nombre AS almacen_origen,
    a_dest.nombre AS almacen_destino,
    p.razon_social AS proveedor,
    ar.nombre AS area_solicitante,
    CONCAT(u.nombre, ' ', u.apellido) AS usuario_creador,
    m.status,
    m.costo_total,
    COUNT(md.id) AS total_items,
    SUM(md.cantidad) AS cantidad_total
FROM 
    movimiento m
    JOIN tipo_movimiento tm ON m.tipo_id = tm.id
    LEFT JOIN almacen a_orig ON m.almacen_origen_id = a_orig.id
    LEFT JOIN almacen a_dest ON m.almacen_destino_id = a_dest.id
    LEFT JOIN proveedor p ON m.proveedor_id = p.id
    LEFT JOIN area ar ON m.area_solicitante_id = ar.id
    JOIN usuario u ON m.created_by = u.id
    JOIN movimiento_detalle md ON m.id = md.movimiento_id
GROUP BY 
    m.id
ORDER BY 
    m.fecha DESC;

-- Crear triggers para mantener la integridad de los datos

-- Trigger para actualizar stock después de aprobar un movimiento
DELIMITER //
CREATE TRIGGER trg_actualizar_stock_despues_aprobar
AFTER UPDATE ON movimiento
FOR EACH ROW
BEGIN
    DECLARE v_tipo_naturaleza VARCHAR(20);
    
    -- Solo procesamos si el status cambió a 'aprobado'
    IF NEW.status = 'aprobado' AND OLD.status != 'aprobado' THEN
        -- Obtener la naturaleza del movimiento
        SELECT naturaleza INTO v_tipo_naturaleza 
        FROM tipo_movimiento 
        WHERE id = NEW.tipo_id;
        
        -- Procesar según el tipo de movimiento
        CASE v_tipo_naturaleza
            WHEN 'entrada' THEN
                -- Aumentar stock en almacén destino
                UPDATE stock s
                JOIN movimiento_detalle md ON md.producto_id = s.producto_id
                SET s.cantidad = s.cantidad + md.cantidad,
                    s.ultimo_movimiento = NOW(),
                    s.updated_by = NEW.updated_by
                WHERE md.movimiento_id = NEW.id
                AND s.almacen_id = NEW.almacen_destino_id;
                
                -- Insertar productos que no existían en el almacén
                INSERT INTO stock (producto_id, almacen_id, cantidad, ultimo_movimiento, updated_by)
                SELECT md.producto_id, NEW.almacen_destino_id, md.cantidad, NOW(), NEW.updated_by
                FROM movimiento_detalle md
                WHERE md.movimiento_id = NEW.id
                AND NOT EXISTS (
                    SELECT 1 FROM stock s 
                    WHERE s.producto_id = md.producto_id 
                    AND s.almacen_id = NEW.almacen_destino_id
                );
                
            WHEN 'salida' THEN
                -- Disminuir stock en almacén origen
                UPDATE stock s
                JOIN movimiento_detalle md ON md.producto_id = s.producto_id
                SET s.cantidad = s.cantidad - md.cantidad,
                    s.ultimo_movimiento = NOW(),
                    s.updated_by = NEW.updated_by
                WHERE md.movimiento_id = NEW.id
                AND s.almacen_id = NEW.almacen_origen_id;
                
            WHEN 'traslado' THEN
                -- Disminuir en origen
                UPDATE stock s
                JOIN movimiento_detalle md ON md.producto_id = s.producto_id
                SET s.cantidad = s.cantidad - md.cantidad,
                    s.ultimo_movimiento = NOW(),
                    s.updated_by = NEW.updated_by
                WHERE md.movimiento_id = NEW.id
                AND s.almacen_id = NEW.almacen_origen_id;
                
                -- Aumentar en destino (existentes)
                UPDATE stock s
                JOIN movimiento_detalle md ON md.producto_id = s.producto_id
                SET s.cantidad = s.cantidad + md.cantidad,
                    s.ultimo_movimiento = NOW(),
                    s.updated_by = NEW.updated_by
                WHERE md.movimiento_id = NEW.id
                AND s.almacen_id = NEW.almacen_destino_id;
                
                -- Insertar en destino (nuevos)
                INSERT INTO stock (producto_id, almacen_id, cantidad, ultimo_movimiento, updated_by)
                SELECT md.producto_id, NEW.almacen_destino_id, md.cantidad, NOW(), NEW.updated_by
                FROM movimiento_detalle md
                WHERE md.movimiento_id = NEW.id
                AND NOT EXISTS (
                    SELECT 1 FROM stock s 
                    WHERE s.producto_id = md.producto_id 
                    AND s.almacen_id = NEW.almacen_destino_id
                );
                
            WHEN 'ajuste' THEN
                -- Para ajustes positivos o negativos
                IF EXISTS (SELECT 1 FROM tipo_movimiento WHERE id = NEW.tipo_id AND codigo = 'AJP') THEN
                    -- Ajuste positivo
                    UPDATE stock s
                    JOIN movimiento_detalle md ON md.producto_id = s.producto_id
                    SET s.cantidad = s.cantidad + md.cantidad,
                        s.ultimo_movimiento = NOW(),
                        s.updated_by = NEW.updated_by
                    WHERE md.movimiento_id = NEW.id
                    AND s.almacen_id = NEW.almacen_origen_id;
                    
                    -- Insertar productos que no existían
                    INSERT INTO stock (producto_id, almacen_id, cantidad, ultimo_movimiento, updated_by)
                    SELECT md.producto_id, NEW.almacen_origen_id, md.cantidad, NOW(), NEW.updated_by
                    FROM movimiento_detalle md
                    WHERE md.movimiento_id = NEW.id
                    AND NOT EXISTS (
                        SELECT 1 FROM stock s 
                        WHERE s.producto_id = md.producto_id 
                        AND s.almacen_id = NEW.almacen_origen_id
                    );
                ELSE
                    -- Ajuste negativo
                    UPDATE stock s
                    JOIN movimiento_detalle md ON md.producto_id = s.producto_id
                    SET s.cantidad = s.cantidad - md.cantidad,
                        s.ultimo_movimiento = NOW(),
                        s.updated_by = NEW.updated_by
                    WHERE md.movimiento_id = NEW.id
                    AND s.almacen_id = NEW.almacen_origen_id;
                END IF;
        END CASE;
        
        -- Registrar en auditoría para todos los movimientos
        INSERT INTO stock_auditoria (producto_id, almacen_id, cantidad_anterior, cantidad_nueva, 
                                  movimiento_id, motivo, usuario_id)
        SELECT 
            md.producto_id,
            CASE 
                WHEN v_tipo_naturaleza = 'entrada' OR (v_tipo_naturaleza = 'ajuste' AND EXISTS (SELECT 1 FROM tipo_movimiento WHERE id = NEW.tipo_id AND codigo = 'AJP')) THEN NEW.almacen_destino_id
                ELSE NEW.almacen_origen_id
            END AS almacen_id,
            IFNULL((SELECT s.cantidad FROM stock s 
                   WHERE s.producto_id = md.producto_id 
                   AND s.almacen_id = (CASE 
                           WHEN v_tipo_naturaleza = 'entrada' OR (v_tipo_naturaleza = 'ajuste' AND EXISTS (SELECT 1 FROM tipo_movimiento WHERE id = NEW.tipo_id AND codigo = 'AJP')) THEN NEW.almacen_destino_id
                           ELSE NEW.almacen_origen_id
                       END)), 0) - (CASE 
                           WHEN v_tipo_naturaleza = 'entrada' OR (v_tipo_naturaleza = 'ajuste' AND EXISTS (SELECT 1 FROM tipo_movimiento WHERE id = NEW.tipo_id AND codigo = 'AJP')) THEN md.cantidad
                           ELSE -md.cantidad
                       END) AS cantidad_anterior,
            IFNULL((SELECT s.cantidad FROM stock s 
                   WHERE s.producto_id = md.producto_id 
                   AND s.almacen_id = (CASE 
                           WHEN v_tipo_naturaleza = 'entrada' OR (v_tipo_naturaleza = 'ajuste' AND EXISTS (SELECT 1 FROM tipo_movimiento WHERE id = NEW.tipo_id AND codigo = 'AJP')) THEN NEW.almacen_destino_id
                           ELSE NEW.almacen_origen_id
                       END)), 0) AS cantidad_nueva,
            NEW.id,
            CONCAT('Movimiento ', NEW.folio, ' - ', (SELECT nombre FROM tipo_movimiento WHERE id = NEW.tipo_id)),
            NEW.updated_by
        FROM movimiento_detalle md
        WHERE md.movimiento_id = NEW.id;
    END IF;
END;
//
DELIMITER ;

-- Actualizar precio promedio al registrar compras
DELIMITER //
CREATE TRIGGER trg_actualizar_precio_promedio
AFTER INSERT ON movimiento_detalle
FOR EACH ROW
BEGIN
    DECLARE v_tipo_naturaleza VARCHAR(20);
    DECLARE v_tipo_codigo VARCHAR(10);
    DECLARE v_movimiento_id INT UNSIGNED;
    
    -- Obtener información del movimiento
    SELECT m.id, tm.naturaleza, tm.codigo 
    INTO v_movimiento_id, v_tipo_naturaleza, v_tipo_codigo
    FROM movimiento m
    JOIN tipo_movimiento tm ON m.tipo_id = tm.id
    WHERE m.id = NEW.movimiento_id;
    
    -- Actualizar precio promedio solo para compras
    IF v_tipo_codigo = 'COMP' AND NEW.precio_unitario > 0 THEN
        UPDATE producto p
        SET p.ultimo_precio = NEW.precio_unitario,
            p.precio_promedio = (
                (p.precio_promedio * (
                    SELECT SUM(s.cantidad) 
                    FROM stock s 
                    WHERE s.producto_id = p.id
                )) + (NEW.precio_unitario * NEW.cantidad)
            ) / (
                (SELECT SUM(s.cantidad) 
                FROM stock s 
                WHERE s.producto_id = p.id) + NEW.cantidad
            )
        WHERE p.id = NEW.producto_id;
    END IF;
END;
//
DELIMITER ;
