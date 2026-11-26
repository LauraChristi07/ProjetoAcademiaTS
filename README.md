# 🏋️ AcademiaTS

Sistema de gerenciamento de treinos desenvolvido com TypeScript, permitindo que usuários organizem suas atividades físicas.

## Tecnologias utilizadas

- HTML
- CSS
- TypeScript
- Node.js
- Express
- MySQL
- Vite

## Funcionalidades

- Cadastro e login de usuários.
- Criação, atualização e exclusão de tarefas.
- Organização dos treinos por nível e status.
- Busca e filtros de tarefas.
- Estatísticas individuais.
- Seis tarefas iniciais para cada novo usuário.
- Separação das tarefas por conta.

## Como executar o projeto

### 1. Clonar o repositório branch 7

```bash
git clone -b 7 https://github.com/LauraChristi07/ProjetoAcademiaTS.git
```

### 2. Instalar as dependências

Na pasta principal:

```bash
npm install
```

Na pasta `api`:

```bash
cd api
npm install
```

### 3. Configurar o banco de dados

- Abra o MySQL Workbench.
- Para recuperar os dados salvos, importe o arquivo `backup.sql`.

**Importante:** o `backup.sql` contém a estrutura e os dados do banco, incluindo usuários, tarefas e exercícios.

### 4. Configurar o ambiente

Na pasta `api`, copie o arquivo `.env.example` e renomeie a cópia para `.env`.

Preencha os dados de acesso ao MySQL e defina um segredo para o JWT.

### 5. Iniciar a API

Dentro da pasta `api`, execute:

```bash
npm run dev
```

A API estará disponível em:

```text
http://localhost:3000
```

### 6. Iniciar o front-end

Abra outro terminal na pasta principal e execute:

```bash
npm run dev
```

O Vite mostrará o endereço para acessar o projeto pelo navegador.

## Como utilizar o projeto em outro computador

Para executar o AcademiaTS em outro computador, é necessário:

- Ter o Node.js instalado.
- Ter o MySQL Server e o MySQL Workbench instalados.
- Clonar o repositório do GitHub ou copiar a pasta completa do projeto.
- Ter o arquivo `backup.sql` salvo no computador.
- Ter o arquivo `.env` configurado dentro da pasta `api`.

### Recuperar o banco de dados

1. Abra o MySQL Workbench.
2. Conecte-se ao MySQL Server.
3. Acesse **Server > Data Import**.
4. Selecione **Import from Self-Contained File**.
5. Escolha o arquivo `backup.sql`.
6. Defina o banco de destino como `academia`.
7. Clique em **Start Import**.

Depois da importação, configure o `.env` com os dados de conexão do MySQL daquele computador.

### Executar o sistema
1. Abra o terminal na pasta principal e execute `npm install`.
2. Entre na pasta `api` e execute `npm install`.
3. Inicie a API com `npm run dev`.
4. Abra outro terminal na pasta principal e execute `npm run dev`.

O sistema estará disponível pelo endereço apresentado pelo Vite.

**Observação:** o arquivo `.env` e o `backup.sql` devem ser guardados separadamente do repositório público do GitHub. O `.env` contém informações privadas de conexão e autenticação.