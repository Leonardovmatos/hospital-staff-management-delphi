9 - Escreva uma consulta para exibir o nome do empregado, a função e a data de admissão.
Ordene pelo maior salário.


	select nm_empregado, nm_funcao, data_admissao
	  from empregados
  order by salario desc


10 - Escreva uma consulta para exibir o nome do empregado e a data de admissão para todos os empregados que estão no mesmo departamento do empregado "Marcelo", excluindo-o do resultado.  


	select e.nm_empregado, e.data_admissao
	  from empregados e
	  join departamentos d on (d.id_departamento = e.cod_departamento)
     where e.cod_departamento  = 

	 (
		select e2.cod_departamento
		  from empregados e2
		 where e2.nm_empregado = 'Marcelo'
	 )
	   and e.nm_empregado != 'Marcelo'


11 - Escreva uma consulta que mostre o número do empregado e o nome para todos os empregados que trabalham em um departamento com qualquer empregado cujo nome contenha uma letra T.


	select e.id_empregado, e.nm_empregado
	  from empregados e
	  join departamentos d on (d.id_departamento = e.cod_departamento)
	 where e.cod_departamento in
(
  	select e2.cod_departamento
  	  from empregados e2
  	 where e2.nm_empregado ilike '%T%'
)


12 - Escreva uma consulta que mostre o nome do empregado, o departamento, a localização e a função de todos os empregados admitidos há mais de 5 anos, cujo salário ultrapasse o menor salário entre os empregados de função "Gerente".


	select e.nm_empregado, d.nm_departamento, d.local, e.nm_funcao
	  from empregados e
	  join departamentos d on (d.id_departamento = e.cod_departamento)
     where e.data_admissao <= current_date - interval '5 years'
       and e.salario >
(
	select min(e2.salario)
	  from empregados e2
	 where e2.nm_funcao = 'Gerente'
)	



13 - Escreva uma consulta que mostre a soma dos salários o departamento e o cargo de todos os empregados admitidos há mais de 1 ano, localizados em "Porto Alegre".


	select d.nm_departamento, e.nm_funcao, sum(e.salario) as Total_salarios
	  from empregados e
	  join departamentos d on (d.id_departamento = e.cod_departamento)
     where e.data_admissao <= current_date - interval '1 year'
       and d.local = 'Porto Alegre'
   group by d.nm_departamento, e.nm_funcao

14 - Qual o modo correto utilizado para relacionar a tabela de empregados com a tabela de departamentos?

O modo correto para relacionar as tabelas e campos empregados.cod_departamento e departamentos.id_departamento sao:
Na criação do banco de dados relacionar com FK
E nas queries utilizar join.