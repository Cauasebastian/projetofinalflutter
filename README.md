# Task App - Projeto Final de Mobile

Este é o projeto final da disciplina de Mobile, desenvolvido utilizando Flutter para o front-end e Spring Boot com MongoDB para o back-end. O aplicativo é uma ferramenta de gerenciamento de tarefas com funcionalidades como autenticação, gerenciamento de tarefas e armazenamento persistente.

## 🚀 Tecnologias Utilizadas
### Front-end
- Flutter: Framework para desenvolvimento de aplicativos multiplataforma.
- Provider: Gerenciamento de estado no Flutter.
- Material Design: Interface moderna e responsiva.
### Back-end
- Spring Boot: Framework Java para criação de APIs robustas e escaláveis.
- MongoDB: Banco de dados NoSQL para armazenamento das informações.
### Outras Tecnologias
- JWT: Autenticação baseada em tokens.
-Docker: Containerização do back-end para facilitar o deploy.
## 📱 Funcionalidades do Aplicativo
#### Autenticação de Usuários:
- Login e registro com validação.
- Logout seguro utilizando JWT.
- Gerenciamento de Tarefas:
Criar, editar e excluir tarefas.
Listar tarefas por categorias ou datas.
#### Perfil do Usuário:
- Visualizar informações do perfil.
- Atualizar dados pessoais.
- Interface Responsiva:
- Navegação amigável e intuitiva.
- Suporte a diferentes tamanhos de tela.

## 🛠️ Configuração do Backend

# Instalação
 1. **Navegue para o diretório do backend**:
   ```bash
   cd /caminho/para/o/diretorio/que/contem/o/pom.xml
   ```
 2. Configure o arquivo application.properties para:
- Configurar a conexão com o banco de dados MongoDB.
  Exemplo:
  ```bash
  spring.data.mongodb.uri=mongodb://localhost:27017/flutter_task_app
  ```
1. **Instale as dependências:**:
    ```bash
    mvn clean install
    ```
    
2. **Execute o aplicativo Spring Boot**:
    ```bash
    mvn spring-boot:run
    ```
3. **O backend estará disponível em**:
    ```
    http://localhost:8080
    ```
4. **Acesse a documentação da API no Swagger em**:
    ```
    http://localhost:8080/swagger-ui.html
    ```
## 📱 Configuração do frontend 
### Front-end
1. Acesse a pasta frontend e abra um terminal.
2. Obtenha o IP da máquina executando o comando:
```
   ipconfig
 ```
Nota: Localize o IP correspondente à sua conexão de rede (geralmente exibido em IPv4 Address).
3. Abra o código do front-end e substitua o IP na URL base das APIs, por exemplo:
```
   const String baseUrl = 'http://192.168.15.106:8080'; // Substitua pelo seu IP
 ```
Certifique-se de atualizar as chamadas de API nos arquivos relevantes, como LoginService e UserService, utilizando o IP correto.
4. Execute o comando:
  ```
   flutter pub get
   ```
5. Inicie o aplicativo em um emulador ou dispositivo:
```
   flutter run
 ```
## Dicas
- O IP configurado no front-end deve ser acessível pelo dispositivo em que o aplicativo será executado.
- Caso utilize um emulador Android, é possível usar 10.0.2.2 como IP para acessar o servidor local do host.
- Se houver problemas de conexão, verifique se o firewall está bloqueando o acesso ao back-end.
