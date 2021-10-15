use Hospital
GO

if OBJECT_ID('sp_MENUdept')is not null
begin
	drop procedure sp_MENUdept
end
go

/*
 * Creado por adrian  villamar
 */
create procedure sp_MENUdept (
   @i_fecha_inicial       		DATETIME			=null       ,
   @i_fecha_final       		DATETIME			=null		,
   @i_numero_departamento       int 				=null		,
   @i_apellido					varchar		(50)	=null		,
   @i_oficio					varchar		(50)	=null		,
   @i_dir						int					=null		,
   @i_fecha_alt					Datetime			=null		,
   @i_salario					numeric				=null		,
   @i_comision					numeric				=null		,
   @i_id_dept					int					=null		,
   @i_nombre_dept				varchar		(20)    =null       ,
   @i_operacion                 varchar 	(100)        
)
AS
declare 
@w_verificador varchar (50),
@w_codigo int,
@w_max     int

if @i_operacion='ALTA'
begin 

select e.Emp_No , e.Oficio, e.Apellido,e.Dir,e.Fecha_Alt from Emp e,Dept d  
where Fecha_Alt between @i_fecha_inicial and @i_fecha_final and e.Dept_No=@i_numero_departamento and e.Dept_No=d.Dept_No 

end

if @i_operacion='INSERTAR'
begin

   if @i_apellido is null
    begin
	     raiserror ( 'Apellido no fue proporcionado',10,5)		
	    return 7004
    end

	if @i_oficio is null
    begin
	     raiserror ( 'Oficio no fue proporcionado',10,5)		
	    return 7005
    end

	if @i_dir is null
    begin
	     raiserror ( 'Dir no fue proporcionado',10,5)		
	    return 7006
    end

	if @i_fecha_alt is null
    begin
	     raiserror ( 'Fecha alt no fue proporcionado',10,5)		
	    return 7007
    end

	if @i_salario is null
    begin
	     raiserror ( 'Salario no fue proporcionado',10,5)		
	    return 7008
    end


	if @i_comision is null
    begin
	     raiserror ( 'Comision no fue proporcionado',10,5)		
	    return 7009
    end

	if @i_id_dept is null
    begin
	     raiserror ( 'Dept no fue proporcionado',10,5)		
	    return 7009
    end
	else
	begin
   select @w_verificador= DNombre from Dept where dept.Dept_No=666
	if @w_verificador=''
	begin
	raiserror ( 'Dept no fue existe',10,5)		
	    return 7010
	end
	end

	 select @w_max=max(Emp_No) from Emp                        
	
	if @w_max is null
       select @w_codigo=1
    else
    select @w_codigo=@w_max+1


	INSERT INTO EMP VALUES
							(@w_codigo,
							 @i_apellido,
							 @i_oficio,
							 @i_dir,
							 @i_fecha_alt,
                             @i_salario,
							 @i_comision,
                             @i_id_dept)



end


if @i_operacion='RECUPERAR'
begin
	if @i_numero_departamento is null
    begin
	     raiserror ( 'Dept no fue proporcionado',10,5)		
	    return 7009
    end
select count (*) as Numero_personas_dep,  d.Dept_No as numero_dep from Dept d, Emp p where d.Dept_No=@i_numero_departamento and d.Dept_No=p.Dept_No group by d.Dept_No
end

if @i_operacion='RECUPERAR DEPT PERSONA'
begin
	if @i_nombre_dept is null
    begin
	     raiserror ( 'Dept no fue proporcionado',10,5)		
	    return 7009
    end
SELECT E.DEPT_NO AS [NUMERO DEPT]
, D.DNOMBRE AS [NOMBRE], COUNT(*) AS [NUMERO EMPLEADOS]
FROM EMP AS E, DEPT AS D
WHERE D.DNOMBRE = @i_nombre_dept AND E.DEPT_NO = D.DEPT_NO
GROUP BY D.DNOMBRE, E.DEPT_NO

SELECT E.DEPT_NO AS [Nº DEPARTAMENTO]
, D.DNOMBRE AS [DEPARTAMENTO]
, E.APELLIDO, E.SALARIO
FROM EMP AS E, DEPT AS D
WHERE D.DNOMBRE = @i_nombre_dept and E.DEPT_NO = D.DEPT_NO
end

if @i_operacion='DATOS'
BEGIN
    if @i_apellido is null
    begin
	     select *from emp p 
		 raiserror ( 'Apellido no fue proporcionado',10,5)		

	    return 7004
    end
	select *from emp p where   p.Apellido like '%'+@i_apellido+'%'
end

if @i_operacion='DEPT DAT EM'
BEGIN
    if @i_apellido is null
    begin
	    
		 raiserror ( 'Apellido no fue proporcionado',10,5)		

	    return 7004
    end
		select p.Salario,p.Oficio, p.Apellido, d.DNombre from emp p , Dept d where   p.Apellido like '%'+@i_apellido+'%' and d.Dept_No=p.Dept_No
END


return 0 



/*Ejercicio número 1*/
EXEC sp_MENUdept @i_operacion='ALTA',@i_fecha_inicial='1982/01/05',@i_fecha_final='1985/01/05',@i_numero_departamento=20
/*Ejercicio número 2*/
EXEC sp_MENUdept @i_operacion='INSERTAR' ,@i_apellido='SUAREZ',@i_oficio='EMPLEADO',@i_dir=0,@i_fecha_alt='2021/05/11',@i_salario=16000,@i_comision=0,@i_id_dept=2
/*Ejercicio número 3*/
EXEC sp_MENUdept @i_operacion='RECUPERAR', @i_numero_departamento=20
/*Ejercicio número 4*/
exec sp_MENUdept @i_operacion='RECUPERAR DEPT PERSONA', @i_nombre_dept='CONTABILIDAD'
/*Ejercicio número 5*/
exec sp_MENUdept @i_operacion='DATOS' , @i_apellido='sanchez'
/*Ejercicio número 6*/
exec sp_MENUdept @i_operacion='DATOS'
/*Ejercicio número 7*/
exec  sp_MENUdept @i_operacion='DEPT DAT EM', @i_apellido='s'