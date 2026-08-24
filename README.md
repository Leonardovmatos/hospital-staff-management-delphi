# Hospital Staff Management — Delphi VCL

Sistema desktop para gestão de empregados e departamentos hospitalares, desenvolvido em **Delphi / Object Pascal** com **PostgreSQL**, aplicando arquitetura em camadas, Programação Orientada a Objetos, princípios **SOLID** e **Clean Code**.

O projeto cobre todo o ciclo de gestão de pessoal de uma unidade hospitalar: cadastro e consulta de departamentos, cadastro e consulta de empregados vinculados a esses departamentos, e geração de relatórios consolidados com **ReportBuilder**.

---

## Visão geral

O sistema foi desenhado para refletir um cenário real de gestão de recursos humanos em ambiente hospitalar, onde cada empregado pertence a um departamento (Enfermagem, Administração, Financeiro, entre outros) e possui uma função específica dentro dele.

A aplicação permite:

- Consultar e filtrar departamentos e empregados;
- Cadastrar, alterar e excluir departamentos e empregados;
- Impedir a exclusão de departamentos que ainda possuam empregados vinculados;
- Gerar relatórios de empregados agrupados por departamento;
- Manter a integridade dos dados por meio de chaves estrangeiras e validações de negócio.

---

## Arquitetura

O projeto segue uma arquitetura em camadas, desacoplando completamente a interface visual das regras de negócio e do acesso a dados.

```text
├── app/
│   └── Ponto de entrada da aplicação e menu principal
│
├── forms/
│   └── Telas de consulta e cadastro (Departamentos e Empregados)
│
├── domain/
│   └── Entidades de negócio: Empregado, Departamento, Filtro de consulta
│
├── repositories/
│   ├── interfaces/
│   │   └── Contratos de acesso a dados (IDepartamentoRepository, IEmpregadoRepository)
│   │
│   └── Implementações FireDAC responsáveis pelo SQL e persistência
│
├── services/
│   └── Regras de negócio, validações e controle de transações
│
├── infrastructure/
│   └── Conexão com PostgreSQL via FireDAC
│
└── reports/
    └── Relatório de Empregados por Departamento (ReportBuilder)
```

### Fluxo de responsabilidades

| Camada | Responsabilidade |
|---|---|
| `forms` | Interface, interação com o usuário, exibição de dados |
| `domain` | Representação das entidades e regras conceituais do negócio |
| `repositories` | Execução de SQL e persistência via FireDAC/PostgreSQL |
| `services` | Validação de regras, coordenação de operações e transações |
| `infrastructure` | Configuração e disponibilização da conexão com o banco |
| `reports` | Geração e exibição de relatórios consolidados |

Essa separação garante que a interface **nunca** conheça SQL, e que as regras de negócio **nunca** dependam diretamente de componentes visuais — um dos princípios centrais aplicados no projeto.

---

## Modelo de dados

```text
DEPARTAMENTOS (1) ────── (N) EMPREGADOS
```

- Um departamento pode possuir vários empregados.
- Cada empregado pertence a exatamente um departamento, por meio de uma chave estrangeira.

```sql
CREATE TABLE departamentos (
    id_departamento integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    nm_departamento varchar(100),
    local           varchar(100),
    CONSTRAINT departamento_pk PRIMARY KEY (id_departamento) 
)

CREATE TABLE empregados (
    id_empregado        integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    cod_departamento    integer NOT NULL,
    cod_emp_funcao      integer NOT NULL,
    nm_empregado        varchar(100),
    nm_funcao           varchar(100),
    data_admissao       date,
    salario             numeric(92,5),
    comissao            numeric(92,5),
    CONSTRAINT empregado_pk PRIMARY KEY (id_empregado), 
    CONSTRAINT departamento_fk FOREIGN KEY (cod_departamento) REFERENCES departamentos(id_departamento) ON DELETE cascade 
)
```

---

## Funcionalidades

- Consulta de departamentos com filtro por nome;
- Consulta de empregados com filtro por nome e por departamento;
- Cadastro, alteração e exclusão de departamentos;
- Cadastro, alteração e exclusão de empregados;
- Seleção de departamento via `TDBLookupComboBox` no cadastro de empregados;
- Bloqueio de exclusão de departamentos com empregados vinculados;
- Relatório de Empregados por Departamento, respeitando os filtros aplicados na consulta;
- Transações controladas com `Commit`/`Rollback` em todas as operações de escrita;
- Validações de negócio aplicadas na camada de serviço, antes de qualquer persistência.

---

## Conceitos aplicados

Este projeto demonstra a aplicação prática de fundamentos de engenharia de software em uma aplicação Delphi de porte real:

- Programação Orientada a Objetos, com entidades de domínio bem definidas;
- Princípios **SOLID**:
  - **S**ingle Responsibility — cada classe possui uma única razão para mudar;
  - **O**pen/Closed — novas regras e relatórios podem ser adicionados sem alterar estruturas existentes;
  - **L**iskov Substitution — implementações de repositório podem ser substituídas sem quebrar o contrato;
  - **I**nterface Segregation — interfaces enxutas, específicas para cada entidade;
  - **D**ependency Inversion — services dependem de interfaces (`IDepartamentoRepository`, `IEmpregadoRepository`), não de implementações concretas;
- Clean Code: nomes claros, métodos curtos, ausência de SQL nas telas;
- Separação entre domínio, persistência e apresentação;
- Uso de `TTransaction` para garantir consistência em operações críticas;
- Prevenção de exclusões inconsistentes via regra de negócio explícita.

---

## Tecnologias

- Delphi / Object Pascal;
- VCL;
- PostgreSQL;
- FireDAC (`TFDConnection`, `TFDQuery`);
- ReportBuilder (`TppReport`, `TppDBPipeline`);
- `TDBGrid`, `TDBLookupComboBox`, `TDataSource`;
- Programação Orientada a Objetos e princípios SOLID.

---

## Como executar

1. Clone este repositório:

```bash
git clone https://github.com/Leonardovmatos/hospital-staff-management-delphi.git
```

2. Crie o banco de dados PostgreSQL e execute os scripts na ordem:

```text
database/01_create_tables.sql
database/02_insert_departamentos.sql
database/03_insert_empregados.sql
```

3. Copie o arquivo de configuração de exemplo:

```text
bin/config.example.ini → bin/config.ini
```

4. Preencha os dados de conexão em `config.ini`:

```ini
[DATABASE]
Server=127.0.0.1
Port=5432
Database=hospital_staff_management
User_Name=postgres
Password=
CharacterSet=UTF8
```

5. Abra o projeto no Delphi, compile e execute — ou utilize diretamente o executável disponível em `bin/`.

---

## Estrutura do repositório

```text
hospital-staff-management-delphi/
├── src/
│   ├── app/
│   ├── forms/
│   ├── domain/
│   ├── repositories/
│   │   └── interfaces/
│   ├── services/
│   ├── infrastructure/
│   └── reports/
├── database/
├── bin/
├── docs/
│   └── images/
├── README.md
└── .gitignore
```

---

## Sobre o autor

**Leonardo de Vargas Matos**
Desenvolvedor Delphi Pleno, com mais de 4 anos de experiência em sistemas ERP, sustentação de sistemas legados, integrações e rotinas fiscais críticas (NF-e, NFC-e, MDF-e).

Na Sulpasso Software, atuei na refatoração de sistemas de emissão fiscal, reduzindo em 90% os erros de emissão em produção, e desenvolvi do zero um módulo de emissão de MDF-e utilizando ACBr. Também construí uma API REST com DataSnap e relatórios avançados com Report Builder, experiência que embasa diretamente a arquitetura aplicada neste projeto.

Este sistema representa minha abordagem para construção de software: modelar bem o domínio, separar responsabilidades entre camadas, validar regras de negócio de forma explícita e entregar soluções estáveis e sustentáveis ao longo do tempo.

- LinkedIn: [linkedin.com/in/leonardovmatos](https://linkedin.com/in/leonardovmatos)
- GitHub: [github.com/Leonardovmatos](https://github.com/Leonardovmatos)
- E-mail: leonardodevargasmatos@gmail.com