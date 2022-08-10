use master
go

if DB_ID('BDUniversidad') is not null
	drop database BdUniversidad
go
create database BDUniversidad
go

use BDUniversidad
go

--Creacion de Tablas
if OBJECT_ID('TEscuela') is not null
	drop table TEscuela
go
create table TEscuela
(
	CodEscuela char(3) primary key,
	Escuela varchar(50),
	Facultad varchar(50)
)
go

if OBJECT_ID('TAlumno') is not null
	drop table TAlumno
go
create table TAlumno
(
	CodAlumno char(5) primary key,
	Apellidos varchar(50),
	Nombres varchar(50),
	LugarNac varchar(50),
	FechaNac datetime,
	CodEscuela char(3),
	foreign key (CodEscuela) references TEscuela
)
go

--Insertamos los datos
insert into TEscuela values('E01','Sistemas','Ingenieria')
insert into TEscuela values('E02','Civil','Ingenieria')
insert into TEscuela values('E03','Industrial','Ingenieria')
insert into TEscuela values('E04','Ambiental','Ingenieria')
insert into TEscuela values('E05','Arquitectura','Ingenieria')
go
insert into TAlumno values('A01','Delgado','Wolfran','Cusco','2020-6-12','E01')
insert into TAlumno values('A02','Fernandez','Marco','Cusco','2020-6-13','E02')
insert into TAlumno values('A03','Torres','Adiendra','Cusco','2020-6-14','E03')
insert into TAlumno values('A04','Sanchez','Jordan','Cusco','2020-6-15','E04')
insert into TAlumno values('A05','Webert','Riveiro','Cusco','2020-6-16','E05')
go


--PA para TEscuela
use BDUniversidad
go

--Listar
if OBJECT_ID('spListarE') is not null
	drop proc spListarE
go
create proc spListarE
as
begin
	select CodEscuela, Escuela, Facultad from TEscuela
end
go

exec spListarE

--Agregar
if OBJECT_ID('spAgregarE') is not null
	drop proc spAgregarE
go

create proc spAgregarE
	@CodEscuela char(3),
	@Escuela varchar(50),
	@Facultad varchar(50)
as
begin
--CodEscuela no puede ser duplicado
	if not exists(select CodEscuela from TEscuela where CodEscuela=@CodEscuela)
		--Escuela no puede ser duplicado
		if not exists(select Escuela from TEscuela where Escuela=@Escuela)
			begin
				insert into TEscuela values(@CodEscuela, @Escuela, @Facultad)
				select CodError=0, Mensaje='Se inserto correctamente '
			end
		else select CodError=1, Mensaje='Error: Escuela duplicada'
	else select CodError=1, Mensaje='Error: CodEscuela duplicado'
end
go

exec spAgregarE 'E06','CIRUGIA','Medicina Humana'
exec spAgregarE 'E07','CARDIOLOGIA','Medicina Humana1'
exec spAgregarE 'E08','GENERAL','Medicina Humana2'
exec spListarE
--Eliminar
if OBJECT_ID('spEliminarE') is not null
	drop proc spEliminarE
go

create proc spEliminarE
	@CodEscuela char(3)
as
begin
	if exists(select * from TEscuela where CodEscuela=@CodEscuela)
		begin
			delete from TEscuela where CodEscuela=@CodEscuela
			select CodError=0, Mensaje='Se elimino correctamente '
		end
	else select CodError=1, Mensaje='Error:  no existe'
end
go

exec spEliminarE 'E08'
exec spListarE

--Actualizar
if OBJECT_ID('spActualizarE') is not null
	drop proc spActualizarE
go

create proc spActualizarE
	@CodEscuela char(3),
	@Escuela varchar(50),
	@Facultad varchar(50)
as
begin
	if exists(select CodEscuela from TEscuela where CodEscuela=@CodEscuela)
			if not exists(select Escuela from TEscuela where Escuela=@Escuela)
				begin
					update TEscuela Set Escuela=@Escuela, Facultad=@Facultad where CodEscuela=@CodEscuela
					select CodError=0, Mensaje='Se actualizo correctamente '
				end
			else select CodError=1, Mensaje='Error: Escuela duplicada'
	else select CodError=1, Mensaje='Error: CodEscuela duplicada'
end
go
exec spActualizarE 'E06','HUMANA','Medicina Humana'
exec spListarE

--Buscar
if OBJECT_ID('spBuscarE') is not null
	drop proc spBuscarE
go

IF OBJECT_ID('spbuscar') IS NOT NULL
BEGIN 
    DROP PROC spbuscar
END 
GO
CREATE PROC spbuscar
    @CodEscuela char(3)
AS 
BEGIN 
 
    SELECT  @CodEscuela,Escuela,Facultad
    FROM   TEscuela  
    WHERE  (CodEscuela = @CodEscuela) 
END
GO
EXECUTE spbuscar  E02
exec spListarE


--PA para TAlumno
use BDUniversidad
go

--Listar
if OBJECT_ID('spListarA') is not null
	drop proc spListarA
go
create proc spListarA
as
begin
	select CodAlumno, Apellidos, Nombres, LugarNac, FechaNac, CodEscuela from TAlumno
end
go

exec spListarA
go

--Agregar
if OBJECT_ID('spAgregarA') is not null
	drop proc spAgregarA
go

create proc spAgregarA
	@CodAlumno char(5),
	@Apellidos varchar(50),
	@Nombres varchar(50),
	@LugarNac varchar(50),
	@FechaNac datetime,
	@CodEscuela char(3)
as
begin
--CodEscuela no puede ser duplicado
	if not exists(select CodAlumno from TAlumno where CodAlumno=@CodAlumno)
		--Escuela no puede ser duplicado
		if not exists(select Apellidos from TAlumno where Apellidos=@Apellidos)
			begin
				insert into TAlumno values(@CodAlumno, @Apellidos, @Nombres, @LugarNac, @FechaNac, @CodEscuela)
				select CodError=0, Mensaje='Se inserto correctamente '
			end
		else select CodError=1, Mensaje=' Apellidos duplicados'
	else select CodError=1, Mensaje=' CodAlumno duplicado'
end
go

exec spAgregarA 'A06','Gordo�ez','Wolf','Cusco','1254-11-07','E06'
exec spAgregarA'A07','Amao','Wilfried','Huancayo','2014-09-01','E07'
exec spAgregarA 'A08','Ponso�ez','Marilyn','Lima','2030-02-05','E08'
exec spListarA

--Eliminar
if OBJECT_ID('spEliminarA') is not null
	drop proc spEliminarA
go

create proc spEliminarA
	@CodAlumno char(5)
as
begin
	if exists(select * from TAlumno where CodAlumno=@CodAlumno)
		begin
			delete from TAlumno where CodAlumno=@CodAlumno
			select CodError=0, Mensaje='Se elimino correctamente '
		end
	else select CodError=1, Mensaje=' Alumno no existe'
end
go

exec spEliminarA'A08'
exec spListarA

--Actualizar
if OBJECT_ID('spActualizarA') is not null
	drop proc spActualizarA
go

create proc spActualizarA
	@CodAlumno char(5),
	@Apellidos varchar(50),
	@Nombres varchar(50),
	@LugarNac varchar(50),
	@FechaNac datetime,
	@CodEscuela char(3)
as
begin
	if exists(select CodAlumno from TAlumno where CodEscuela=@CodEscuela)
			if not exists(select Apellidos from TAlumno where Apellidos=@Apellidos)
				begin
					update TAlumno Set Apellidos=@Apellidos, Nombres=@Nombres, LugarNac=@LugarNac, FechaNac=@FechaNac, CodEscuela=@CodEscuela where CodAlumno=@CodAlumno
					select CodError=0, Mensaje='Se actualizo '
				end
			else select CodError=1, Mensaje='Apellidos duplicados'
	else select CodError=1, Mensaje=' CodAlumno duplicado'
end
go

exec spActualizarA 'A06','TRIGUEROS','Diosea','Arequipa','2014-09-10','E06'
exec spListarA

--Buscar
if OBJECT_ID('spBuscarA') is not null
	drop proc spBuscarA
go

create proc spBuscarA
	@CodAlumno char(5)
as
begin
	if exists(select CodEscuela from TAlumno where CodAlumno=@CodAlumno)
		begin
			select * from TAlumno where CodAlumno=@CodAlumno
			select CodError=0, Mensaje='Se encontro '
		end
	else select CodError=1, Mensaje='Error: Alumno no existe'
end
go

exec spBuscarA 'A07'

exec spListarA