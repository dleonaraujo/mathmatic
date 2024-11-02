USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'bd_mathmatic')
BEGIN
    ALTER DATABASE bd_mathmatic SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE bd_mathmatic;
END
GO

CREATE DATABASE bd_mathmatic;
GO

USE bd_mathmatic;
GO

-- Crear esquemas
CREATE SCHEMA adm;
GO

CREATE SCHEMA sec;
GO

-- Tabla para sectores
CREATE TABLE adm.sector(
    id INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) UNIQUE NOT NULL,
    estado BIT DEFAULT 1
);

-- Tabla para aulas
CREATE TABLE adm.aula(
    id INT PRIMARY KEY IDENTITY(1,1),
    codigo NVARCHAR(10) UNIQUE NOT NULL,
    estado BIT DEFAULT 1,
    id_sector INT NOT NULL,
    FOREIGN KEY (id_sector) REFERENCES adm.sector(id)
);

-- Tabla para cursos
CREATE TABLE adm.curso(
    id INT PRIMARY KEY IDENTITY(1,1),
    codigo NVARCHAR(10) UNIQUE NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    estado BIT DEFAULT 1
);

-- Tabla para contratos de profesores
CREATE TABLE adm.contrato(
    id INT PRIMARY KEY IDENTITY(1,1),
    codigo NVARCHAR(10) UNIQUE NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_finalizacion DATE NOT NULL,
    sueldo DECIMAL(6,2) NOT NULL,
    estado BIT DEFAULT 1
);

-- Tabla para profesores
CREATE TABLE adm.profesor(
    id INT PRIMARY KEY IDENTITY(1,1),
    dni NVARCHAR(8) UNIQUE NOT NULL,
    codigo NVARCHAR(10) UNIQUE NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    apellido_paterno NVARCHAR(100) NOT NULL,
    apellido_materno NVARCHAR(100) NOT NULL,
    estado BIT DEFAULT 1,
    id_contrato INT NOT NULL,
    FOREIGN KEY (id_contrato) REFERENCES adm.contrato(id)
);

-- Tabla para los días
CREATE TABLE adm.dia(
    id INT PRIMARY KEY IDENTITY(1,1),
    dia NVARCHAR(100) UNIQUE NOT NULL
);

-- Tabla para horarios
CREATE TABLE adm.horario(
    id INT PRIMARY KEY IDENTITY(1,1),
    hora TIME NOT NULL,
    id_dia INT NOT NULL,
    FOREIGN KEY (id_dia) REFERENCES adm.dia(id)
);

-- Tabla para alumnos
CREATE TABLE adm.alumno(
    id INT PRIMARY KEY IDENTITY(1,1),
    dni NVARCHAR(8) UNIQUE NOT NULL,
    codigo NVARCHAR(10) UNIQUE NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    apellido_paterno NVARCHAR(100) NOT NULL,
    apellido_materno NVARCHAR(100) NOT NULL,
    estado BIT DEFAULT 1
);

-- Tabla para inscripción de alumnos en cursos
CREATE TABLE adm.inscripcion(
    id INT PRIMARY KEY IDENTITY(1,1),
    id_alumno INT NOT NULL,
    id_curso INT NOT NULL,
    fecha_inscripcion DATE NOT NULL,
    semestre NVARCHAR(10) NOT NULL,
    estado BIT DEFAULT 1,
    FOREIGN KEY (id_alumno) REFERENCES adm.alumno(id),
    FOREIGN KEY (id_curso) REFERENCES adm.curso(id),
    UNIQUE (id_alumno, id_curso, semestre) -- Evitar duplicidad de inscripción en el mismo curso y semestre
);

-- Tabla para asignación de cursos y horarios en aulas
CREATE TABLE adm.aula_curso_horario(
    id INT PRIMARY KEY IDENTITY(1,1),
    id_aula INT NOT NULL,
    id_curso INT NOT NULL,
    id_horario INT NOT NULL,
    semestre NVARCHAR(10) NOT NULL,
    FOREIGN KEY (id_aula) REFERENCES adm.aula(id),
    FOREIGN KEY (id_curso) REFERENCES adm.curso(id),
    FOREIGN KEY (id_horario) REFERENCES adm.horario(id)
);

-- Tabla para plan de estudios: relación entre alumno, profesor y curso
CREATE TABLE adm.plan_estudio(
    id INT PRIMARY KEY IDENTITY(1,1),
    id_inscripcion INT NOT NULL,
    id_profesor INT NOT NULL,
    FOREIGN KEY (id_inscripcion) REFERENCES adm.inscripcion(id),
    FOREIGN KEY (id_profesor) REFERENCES adm.profesor(id)
);

-- Tabla para calificaciones
CREATE TABLE adm.calificacion(
    id INT PRIMARY KEY IDENTITY(1,1),
    id_inscripcion INT NOT NULL,
    calificacion DECIMAL(4,2) NOT NULL CHECK (calificacion BETWEEN 0 AND 20),
    fecha_calificacion DATE NOT NULL,
    FOREIGN KEY (id_inscripcion) REFERENCES adm.inscripcion(id)
);

-- Tabla para control de asistencia
CREATE TABLE adm.asistencia(
    id INT PRIMARY KEY IDENTITY(1,1),
    id_inscripcion INT NOT NULL,
    fecha DATE NOT NULL,
    presente BIT DEFAULT 1,
    FOREIGN KEY (id_inscripcion) REFERENCES adm.inscripcion(id)
);

-- Tabla para roles
CREATE TABLE sec.rol(
    id INT PRIMARY KEY IDENTITY(1,1),
    codigo NVARCHAR(10) UNIQUE NOT NULL,
    nombre NVARCHAR(100) UNIQUE NOT NULL
);

-- Tabla para usuarios
CREATE TABLE sec.usuario(
    id INT PRIMARY KEY IDENTITY(1,1),
    dni NVARCHAR(8) UNIQUE NOT NULL,
    codigo NVARCHAR(10) UNIQUE NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    apellido_paterno NVARCHAR(100) NOT NULL,
    apellido_materno NVARCHAR(100) NOT NULL,
    id_rol INT NOT NULL,
    FOREIGN KEY (id_rol) REFERENCES sec.rol(id)
);

-- Tabla para registro de log de procesos
CREATE TABLE sec.log_procesos(
    id INT PRIMARY KEY IDENTITY(1,1),
    fecha DATE NOT NULL,
    motivo NVARCHAR(100) NOT NULL,
    id_usuario INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES sec.usuario(id)
);

