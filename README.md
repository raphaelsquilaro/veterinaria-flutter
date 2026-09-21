# 🐾 VetMark

Sistema de gerenciamento para clínicas veterinárias, desenvolvido para centralizar o cadastro de clientes, pets, veterinários, serviços, produtos, agendamentos, histórico clínico, pedidos e informações financeiras.

O projeto possui uma aplicação web administrativa e uma aplicação mobile para os clientes da clínica, utilizando uma API REST como ponte entre o aplicativo e o backend.

---

## 📌 Sobre o projeto

O **VetMark** foi desenvolvido com o objetivo de facilitar a gestão de uma clínica veterinária, permitindo organizar informações de clientes e seus pets, controlar atendimentos, agendamentos, produtos, pedidos e demais operações da clínica.

A solução é dividida em duas interfaces:

- 🖥️ **Sistema Web:** utilizado para gerenciamento da clínica.
- 📱 **Aplicativo Mobile:** utilizado pelos clientes para acessar seus dados, pets, agendamentos e pedidos.

As duas aplicações utilizam o mesmo backend e banco de dados.

---

## 🏗️ Arquitetura

```text
                    ┌──────────────────────┐
                    │      Flutter App     │
                    │    Aplicativo Mobile │
                    └──────────┬───────────┘
                               │
                               │ REST API
                               ▼
                    ┌──────────────────────┐
                    │    Spring Boot       │
                    │      Backend         │
                    ├──────────────────────┤
                    │ Controllers          │
                    │ Services             │
                    │ DTOs                 │
                    │ Repositories         │
                    │ Spring Security      │
                    └──────────┬───────────┘
                               │
                               │ JPA / Hibernate
                               ▼
                    ┌──────────────────────┐
                    │        MySQL         │
                    │       Database       │
                    └──────────────────────┘
```

Além da API REST, o backend possui uma interface web construída com **Thymeleaf**.

```text
VetMark
│
├── 🖥️ Web
│   └── Spring Boot + Thymeleaf
│
├── 📱 Mobile
│   └── Flutter
│
├── 🔌 API
│   └── REST
│
└── 🗄️ Banco
    └── MySQL
```

---

## 🚀 Tecnologias utilizadas

### Backend

- Java
- Spring Boot
- Spring MVC
- Spring Security
- Spring Data JPA
- Hibernate
- Thymeleaf
- Lombok
- Bean Validation
- REST API
- Maven

### Banco de dados

- MySQL

### Mobile

- Flutter
- Dart
- HTTP
- REST API

### Ferramentas

- IntelliJ IDEA
- Android Studio
- MySQL
- Git
- GitHub

---

## 📂 Estrutura do projeto

### Backend

```text
src/
└── main/
    ├── java/
    │   └── sp.senai.org.vetmark/
    │       ├── config/
    │       ├── controller/
    │       │   └── api/
    │       ├── dto/
    │       │   ├── request/
    │       │   └── response/
    │       ├── exception/
    │       ├── model/
    │       │   ├── entity/
    │       │   └── enums/
    │       ├── repository/
    │       └── service/
    │
    └── resources/
        ├── static/
        │   ├── css/
        │   ├── js/
        │   └── images/
        │
        └── templates/
            ├── agendamento/
            ├── cliente/
            ├── financeiro/
            ├── historico-clinico/
            ├── pedido/
            ├── pet/
            ├── produto/
            ├── relatorio/
            ├── servico/
            └── veterinario/
```

### Aplicativo Flutter

```text
lib/
├── main.dart
│
├── app/
│   ├── app.dart
│   ├── routes.dart
│   └── theme.dart
│
├── models/
│   ├── cliente.dart
│   ├── pet.dart
│   ├── servico.dart
│   ├── veterinario.dart
│   ├── agendamento.dart
│   ├── produto.dart
│   ├── item_pedido.dart
│   └── pedido.dart
│
├── services/
│   ├── api_service.dart
│   ├── cliente_service.dart
│   ├── pet_service.dart
│   ├── servico_service.dart
│   ├── veterinario_service.dart
│   ├── agendamento_service.dart
│   ├── produto_service.dart
│   └── pedido_service.dart
│
├── screens/
│   ├── splash/
│   ├── login/
│   ├── cadastro/
│   ├── home/
│   ├── usuario/
│   ├── pets/
│   ├── agendamentos/
│   ├── pedidos/
│   └── logout/
│
└── widgets/
```

---

## 📋 Funcionalidades

### 🖥️ Sistema Web

O sistema administrativo possui módulos para:

- 👤 Clientes
- 🐾 Pets
- 🩺 Veterinários
- 📦 Produtos
- 💉 Serviços
- 📅 Agendamentos
- 📋 Histórico clínico
- 🧾 Pedidos
- 💰 Financeiro
- 📈 Relatórios
- 🔐 Autenticação e controle de acesso

---

### 📱 Aplicativo Mobile

O aplicativo Flutter possui:

- Splash Screen
- Login
- Cadastro de cliente
- Home
- Perfil do usuário
- Listagem de pets
- Cadastro de pets
- Listagem de agendamentos
- Cadastro de agendamentos
- Listagem de pedidos
- Cadastro de pedidos
- Logout

---

## 🔌 API REST

A API foi construída utilizando Spring Boot e utiliza DTOs para separar os dados de entrada e saída das entidades JPA.

### Clientes

```text
GET    /api/clientes
GET    /api/clientes/{id}
POST   /api/clientes
PUT    /api/clientes/{id}
DELETE /api/clientes/{id}
```

### Pets

```text
GET    /api/pets
GET    /api/pets/{id}
POST   /api/pets
PUT    /api/pets/{id}
DELETE /api/pets/{id}
```

### Veterinários

```text
GET    /api/veterinarios
GET    /api/veterinarios/{id}
POST   /api/veterinarios
PUT    /api/veterinarios/{id}
DELETE /api/veterinarios/{id}
```

### Serviços

```text
GET    /api/servicos
GET    /api/servicos/{id}
POST   /api/servicos
PUT    /api/servicos/{id}
DELETE /api/servicos/{id}
```

### Produtos

```text
GET    /api/produtos
GET    /api/produtos/{id}
POST   /api/produtos
PUT    /api/produtos/{id}
DELETE /api/produtos/{id}
```

### Agendamentos

```text
GET    /api/agendamentos
GET    /api/agendamentos/{id}
POST   /api/agendamentos
PUT    /api/agendamentos/{id}
DELETE /api/agendamentos/{id}
```

### Pedidos

```text
GET    /api/pedidos
GET    /api/pedidos/{id}
POST   /api/pedidos
PUT    /api/pedidos/{id}
DELETE /api/pedidos/{id}
```

---

## 🧩 DTOs

A API utiliza uma separação entre objetos de requisição e resposta:

```text
dto/
├── request/
│   ├── ClienteRequest
│   ├── PetRequest
│   ├── VeterinarioRequest
│   ├── ServicoRequest
│   ├── ProdutoRequest
│   ├── AgendamentoRequest
│   ├── PedidoRequest
│   └── ...
│
└── response/
    ├── ClienteResponse
    ├── PetResponse
    ├── VeterinarioResponse
    ├── ServicoResponse
    ├── ProdutoResponse
    ├── AgendamentoResponse
    ├── PedidoResponse
    └── ...
```

Essa abordagem evita expor diretamente as entidades JPA através da API.

---

## 🔐 Segurança

O backend utiliza **Spring Security** para proteger as páginas administrativas.

As páginas de login e os recursos públicos ficam disponíveis sem autenticação, enquanto as demais áreas do sistema exigem usuário autenticado.

O aplicativo mobile possui fluxo próprio de autenticação e cadastro de cliente, integrado ao backend através da API.

---

## 🗄️ Modelo de dados

Entre as principais entidades do sistema estão:

```text
Pessoa
 ├── Cliente
 └── Veterinario

Cliente
 └── Pets

Pet
 └── Histórico Clínico

Agendamento
 ├── Cliente
 ├── Pet
 ├── Veterinário
 └── Serviço

Pedido
 ├── Cliente
 └── Itens do Pedido

ItemPedido
 └── Produto

MovimentacaoFinanceira
 └── Pedido (opcional)
```

---

## 📱 Comunicação com o backend

O aplicativo Flutter utiliza HTTP para consumir a API REST.

Exemplo:

```dart
final response = await http.get(
  Uri.parse('$baseUrl/api/pets'),
);
```

No Android Emulator, o endereço utilizado para acessar o backend local é:

```text
http://10.0.2.2:8080
```

Para um dispositivo físico, o endereço deve apontar para o IP da máquina onde o Spring Boot está executando.

---

## ⚙️ Configuração do Backend

### 1. Clone o projeto

```bash
git clone https://github.com/seu-usuario/vetmark.git
```

Entre na pasta:

```bash
cd vetmark
```

### 2. Configure o MySQL

Crie o banco de dados:

```sql
CREATE DATABASE vetmark;
```

Configure as informações do banco no `application.properties` ou `application.yml`.

Exemplo:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/vetmark
spring.datasource.username=root
spring.datasource.password=SUA_SENHA

spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
```

### 3. Execute o backend

Com Maven:

```bash
./mvnw spring-boot:run
```

No Windows:

```bash
mvnw.cmd spring-boot:run
```

O backend ficará disponível, por padrão, em:

```text
http://localhost:8080
```

---

## 📱 Configuração do Flutter

Entre na pasta do aplicativo:

```bash
cd mobile
```

Instale as dependências:

```bash
flutter pub get
```

Execute o projeto:

```bash
flutter run
```

Para Android Emulator, a API deve estar configurada como:

```dart
static const String baseUrl =
    'http://10.0.2.2:8080';
```

---

## 🎨 Identidade visual

O VetMark utiliza uma identidade visual baseada em tons de verde e azul, buscando transmitir uma aparência moderna, limpa e relacionada ao cuidado veterinário.

### Cores principais

| Cor | Hexadecimal |
|---|---|
| Primary | `#2A9D8F` |
| Primary Dark | `#217A70` |
| Primary Light | `#DFF3EF` |
| Secondary | `#4A90A4` |
| Secondary Light | `#E8F4F7` |
| Background | `#F4F8F7` |
| Surface | `#FFFFFF` |
| Text | `#203331` |
| Secondary Text | `#5F7471` |
| Border | `#DDEAE7` |
| Success | `#3BAA72` |
| Warning | `#E7A23B` |
| Danger | `#D95C5C` |

---

## 🔄 Fluxo principal do aplicativo

```text
                    ┌──────────────┐
                    │    Splash    │
                    └──────┬───────┘
                           │
                           ▼
                    ┌──────────────┐
                    │    Login     │
                    └──────┬───────┘
                           │
                 ┌─────────┴─────────┐
                 │                   │
              Entrar              Cadastro
                 │                   │
                 └─────────┬─────────┘
                           ▼
                    ┌──────────────┐
                    │     Home     │
                    └──────┬───────┘
                           │
        ┌──────────────────┼──────────────────┐
        ▼                  ▼                  ▼
      Pets              Agenda             Perfil
        │                  │
        ▼                  ▼
 Cadastro Pet       Novo Agendamento

                           │
                           ▼
                        Pedidos
                           │
                           ▼
                     Novo Pedido
```

---

## 🧪 Testes da API

A API pode ser testada utilizando ferramentas como:

- Postman
- Insomnia
- Bruno
- Thunder Client

Exemplo de criação de um pet:

```http
POST /api/pets
Content-Type: application/json
```

```json
{
  "nome": "Thor",
  "especie": "CACHORRO",
  "raca": "Golden Retriever",
  "dataNascimento": "2022-05-10",
  "clienteId": 1
}
```

---

## 📈 Próximos passos

Algumas funcionalidades planejadas para evolução do projeto:

- [ ] Autenticação completa do aplicativo mobile
- [ ] JWT para comunicação com a API
- [ ] Persistência da sessão do usuário
- [ ] Recuperação de senha
- [ ] Filtro de agendamentos por usuário
- [ ] Validação de disponibilidade de veterinários
- [ ] Notificações de consultas
- [ ] Histórico clínico no aplicativo
- [ ] Detalhes individuais de pedidos
- [ ] Pagamento de pedidos
- [ ] Dashboard com indicadores
- [ ] Relatórios avançados
- [ ] Testes unitários
- [ ] Testes de integração
- [ ] Documentação com Swagger/OpenAPI
- [ ] Deploy do backend
- [ ] Deploy do aplicativo mobile

---

## 👨‍💻 Desenvolvimento

O projeto foi estruturado utilizando uma arquitetura em camadas:

```text
Controller
    ↓
Service
    ↓
Repository
    ↓
Database
```

Para a API:

```text
Request DTO
    ↓
API Controller
    ↓
Service
    ↓
Entity
    ↓
Repository
    ↓
MySQL
    ↓
Response DTO
```

Essa separação facilita a manutenção, organização e evolução do sistema.

---

## 📄 Licença

Este projeto foi desenvolvido para fins acadêmicos e de estudo.

---

## 🐾 VetMark

**Gestão inteligente para clínicas veterinárias.**

> Cuidando da gestão para que a clínica possa cuidar melhor dos seus pacientes.
