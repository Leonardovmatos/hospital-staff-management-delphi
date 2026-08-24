CREATE TABLE departamentos (
    id_departamento integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    nm_departamento varchar(100),
    local           varchar(100),
    CONSTRAINT departamento_pk PRIMARY KEY (id_departamento) 
)

CREATE TABLE empregados (
	id_empregado 		integer NOT NULL GENERATED ALWAYS AS IDENTITY,
	cod_departamento	integer NOT NULL,
	cod_emp_funcao		integer NOT NULL,
	nm_empregado		varchar(100),
	nm_funcao			varchar(100),
	data_admissao		date,
	salario				numeric(92,5),
	comissao			numeric(92,5),
    CONSTRAINT empregado_pk PRIMARY KEY (id_empregado), 
    CONSTRAINT departamento_fk FOREIGN KEY (cod_departamento) REFERENCES departamentos(id_departamento) ON DELETE cascade 
)
