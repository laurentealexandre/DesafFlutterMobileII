CRUD Flutter com MySQL
Configuração do Ambiente
Requisitos
•	Node.js
•	XAMPP
•	Flutter SDK
•	Editor (VS Code recomendado)

Executando o Projeto
Iniciar Serviços
•	Abrir XAMPP e iniciar: 
•	Apache
•	MySQL

Iniciar API:
•	cd crud_api 
•	node server.js

Rodar o Flutter:
•	cd crud_flutter 
•	flutter run -d chrome

Funcionalidades

Tela Inicial
•	Acesso a Clientes
•	Acesso a Produtos
•	Botões de cadastro para clientes
•	Botões de cadastro para produtos 

Clientes
•	Listagem de clientes
•	Cadastro de novo cliente
•	Edição de cliente existente
•	Exclusão de cliente
•	Campos: 
    o	Nome (mín. 3, máx. 25 caracteres)
    o	Sobrenome (mín. 3, máx. 25 caracteres)
    o	Email (formato válido)
    o	Idade (1-120)
    o	Foto URL (opcional)

Produtos
•	Listagem de produtos
•	Cadastro de novo produto
•	Edição de produto existente
•	Exclusão de produto
•	Campos: 
    o	Nome (mín. 3, máx. 25 caracteres)
    o	Descrição (mín. 3, máx. 25 caracteres)
    o	Preço (0-120)
    o	Data de Atualização


Mensagens do aplicativo
•	Mensagens de sucesso/erro nas operações
•	Confirmação antes de excluir
•	Interface intuitiva e responsiva

Observações
•	O programa deve ser executado em um navegador web (Chrome de preferência)
•	Certifique-se que todas as portas necessárias estão livres
•	Mantenha o XAMPP e a API rodando durante o uso do sistema
