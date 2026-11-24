-- Pre-Entrega 4: Consultas multicapa para análisis de negocio
-- Consultas realizadas sobre las tablas de práctica del Módulo 4.

SET search_path TO practica_m4;

-- Consulta 1: Rentabilidad por Categoría
-- Se definió un umbral de 1000 para separar las categorías con mayores ingresos de las de menor facturación y analizar cuáles generan más ventas.
SELECT c.nombre_categoria, 
	   SUM(v.cantidad) AS unidades_vendidas,
	   SUM (v.cantidad * p.precio) AS ingreso_total
FROM ventas AS v
INNER JOIN productos AS p
 ON v.producto_id = p.producto_id
INNER JOIN categorias AS c
 ON p.id_categoria = c.categoria_id
GROUP BY c.nombre_categoria
HAVING SUM(v.cantidad * p.precio) >= 1000;




-- Consulta 2: Clientes sin compras
-- Análisis realizado para identificar clientes registrados que no realizaron compras hasta el momento, para poder realizar una campaña de incentivo.
SELECT c.cliente_id, c.nombre, COALESCE (v.venta_id, 0) AS compras
FROM clientes AS c
LEFT JOIN ventas AS v
ON c.cliente_id = v.cliente_id
WHERE v.venta_id IS NULL;




--Consulta 3: Top de compras por cliente 
-- Se realiza un análisis del producto más comprado de cada cliente y la fecha de su última compra para conocer sus gustos, ofrecer experiencias personalizadas y saber qué tan recientemente realizaron una compra.
SELECT c.nombre,
		(SELECT p2.nombre
		 FROM ventas AS v2
		 INNER JOIN productos AS p2
		 ON v2.producto_id = p2.producto_id
		 WHERE v2.cliente_id = c.cliente_id
		 GROUP BY p2.producto_id, p2.nombre
		 ORDER BY COUNT(*) DESC
		 LIMIT 1) AS producto_mas_comprado,
	   MAX(v.fecha) AS ultima_compra
FROM clientes AS c
INNER JOIN ventas AS v
ON v.cliente_id = c.cliente_id
INNER JOIN productos AS p
ON p.producto_id = v.producto_id
GROUP BY c.cliente_id, c.nombre;


