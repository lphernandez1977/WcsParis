ALTER PROC [dbo].sp_selec_reporte_scanner  
@in_Fecha_Inicio varchar(10),  
@in_Fecha_Termino varchar(10)  
  
AS  
  
SELECT   
' ' + KEYBUL AS 'Carton',  
CONVERT(VARCHAR,FECHA,103) as 'Fecha Lectura',  
DATEPART(HOUR,FECHA) as 'Hora Lectura',  
DATEPART(MINUTE,FECHA) as 'Minuto Lectura',  
DATEPART(SECOND,FECHA) as 'Segundo Lectura',  
CONVERT(VARCHAR,FECHAS,103) as 'Fecha Salida',  
DATEPART(HOUR,FECHAS) as 'Hora Salida',  
DATEPART(MINUTE,FECHAS) as 'Minuto Salida',  
DATEPART(SECOND,FECHAS) as 'Secgundo Salida',  
KILOS ,  
RAMPA_SAL_SORTER,  
RAMPAS,  
ERROR,  
LINEA_RECIRC,  
OBSERVACION_ORACLE,  
CASE WHEN RAMPA_SAL_SORTER = RAMPAS AND OBSERVACION_ORACLE IS NOT NULL THEN 'BUENA LECTURA'     
    
  WHEN KEYBUL = '000000000000000000000NoRead' AND RAMPA_SAL_SORTER = '99' THEN 'ERROR LECTURA'   
  
  WHEN RAMPA_SAL_SORTER = '99' AND RAMPAS IS NULL AND ERROR IS NULL AND LINEA_RECIRC IS NULL AND OBSERVACION_ORACLE IS NULL THEN 'CARTON SIN DESTINO'  
  
  WHEN RAMPAS = '77' AND ERROR = 'RECIRCULADO' AND LINEA_RECIRC IS NOT NULL THEN 'RECIRCULADO'    
  
  WHEN RAMPAS = '77' AND ERROR = 'RECIRC' AND LINEA_RECIRC IS NOT NULL THEN 'RECIRCULADO'    
  
  WHEN RAMPAS = '77' AND ERROR IS NULL AND LINEA_RECIRC IS NULL THEN 'RECIRCULADO'    
  
  WHEN RAMPAS = '77' AND ERROR = 'RECIRCULADO' AND LINEA_RECIRC IS NULL THEN 'LINEA LLENA'    
    
  WHEN RAMPAS = '77' AND ERROR = 'TIME OUT' AND LINEA_RECIRC IS NOT NULL THEN 'LINEA LLENA'  
  
  WHEN RAMPAS = '77' AND ERROR = 'TO' AND LINEA_RECIRC IS NULL THEN 'LINEA LLENA'  
    
  WHEN RAMPA_SAL_SORTER <> RAMPAS AND ERROR IS NULL AND LINEA_RECIRC IS NULL THEN 'ERROR PROCESO'  
END 'Resultado',  
NOM_DESTINO  
FROM VL_CBC  
WHERE  
  
FECHA >=  CONVERT(DATETIME,@in_Fecha_Inicio) AND FECHA <=  CONVERT(DATETIME,@in_Fecha_Termino)    
ORDER BY FECHA , LECTURA DESC

GO

CREATE PROC SP_INFORME_RESUMEN_DIARIO_LECTURAS_SORTER  
AS  
SELECT   
' ' + KEYBUL AS 'Carton',  
CONVERT(VARCHAR,FECHA,103) as 'Fecha Lectura',  
DATEPART(HOUR,FECHA) as 'Hora Lectura',  
DATEPART(MINUTE,FECHA) as 'Minuto Lectura',  
DATEPART(SECOND,FECHA) as 'Segundo Lectura',  
CONVERT(VARCHAR,FECHAS,103) as 'Fecha Salida',  
DATEPART(HOUR,FECHAS) as 'Hora Salida',  
DATEPART(MINUTE,FECHAS) as 'Minuto Salida',  
DATEPART(SECOND,FECHAS) as 'Secgundo Salida',  
KILOS ,  
RAMPA_SAL_SORTER,  
RAMPAS,  
ERROR,  
LINEA_RECIRC,  
OBSERVACION_ORACLE,  
FECHA,  
CASE WHEN RAMPA_SAL_SORTER = RAMPAS AND OBSERVACION_ORACLE IS NOT NULL THEN 'BUENA LECTURA'     
    
  WHEN KEYBUL = '000000000000000000000NoRead' AND RAMPA_SAL_SORTER = '99' THEN 'ERROR LECTURA'   
  
  WHEN RAMPA_SAL_SORTER = '99' AND RAMPAS IS NULL AND ERROR IS NULL AND LINEA_RECIRC IS NULL AND OBSERVACION_ORACLE IS NULL THEN 'CARTON SIN DESTINO'  
  
  WHEN RAMPAS = '77' AND ERROR = 'RECIRCULADO' AND LINEA_RECIRC IS NOT NULL THEN 'RECIRCULADO'    
  
  WHEN RAMPAS = '77' AND ERROR = 'RECIRC' AND LINEA_RECIRC IS NOT NULL THEN 'RECIRCULADO'    
  
  WHEN RAMPAS = '77' AND ERROR IS NULL AND LINEA_RECIRC IS NULL THEN 'RECIRCULADO'    
  
  WHEN RAMPAS = '77' AND ERROR = 'RECIRCULADO' AND LINEA_RECIRC IS NULL THEN 'LINEA LLENA'    
    
  WHEN RAMPAS = '77' AND ERROR = 'TIME OUT' AND LINEA_RECIRC IS NOT NULL THEN 'LINEA LLENA'  
  
  WHEN RAMPAS = '77' AND ERROR = 'TO' AND LINEA_RECIRC IS NULL THEN 'LINEA LLENA'  
    
  WHEN RAMPA_SAL_SORTER <> RAMPAS AND ERROR IS NULL AND LINEA_RECIRC IS NULL THEN 'ERROR PROCESO'  
END 'Resultado',  
NOM_DESTINO  
INTO TB_TEMP_RESUMEN  
FROM VL_CBC  
WHERE  
--FECHA >=  CONVERT(DATETIME,@in_Fecha_Inicio) AND FECHA <=  CONVERT(DATETIME,@in_Fecha_Termino)   
--FECHA >=  CONVERT(DATETIME,'2020-04-28') AND FECHA <=  CONVERT(DATETIME,'2020-04-29')   
FECHA =  CONVERT(DATETIME,GETDATE())
ORDER BY FECHA , LECTURA DESC  
  
SELECT CASE WHEN RESULTADO IS NULL THEN 'EN PROCESO' ELSE RESULTADO END 'Resultado' , COUNT(*) 'CARTONES' FROM TB_TEMP_RESUMEN WHERE FECHA >=  CONVERT(DATETIME,'2020-04-28') AND FECHA <=  CONVERT(DATETIME,'2020-04-29') GROUP BY RESULTADO ORDER BY RESULTAD
O  
  
DROP TABLE TB_TEMP_RESUMEN  
  
  





