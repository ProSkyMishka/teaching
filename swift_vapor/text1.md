# Введение в Swift Vapor

## Что такое Vapor?
Vapor — это современный серверный фреймворк на языке Swift, который используется для создания веб-приложений и API. Он предоставляет удобные инструменты для работы с HTTP-запросами, базами данных, аутентификацией и многими другими аспектами веб-разработки. Vapor подходит для следующих задач:

- **Разработка REST API** для мобильных и веб-приложений.
- **Создание полноценных веб-сайтов** с использованием шаблонов.
- **Интеграция с базами данных** с помощью ORM Fluent.
- **Работа с WebSockets** для реализации real-time приложений.

**Преимущества Vapor:**
- Написан на Swift — языке с высокой производительностью и безопасностью.
- Простота и читаемость кода.
- Широкие возможности интеграции с экосистемой Apple.
- Поддержка асинхронных операций с использованием Swift NIO.

## Установка Vapor Toolbox и зависимостей

Для начала работы с Vapor необходимо установить **Vapor Toolbox**, который помогает управлять проектами и зависимостями. 

### Требования:
- macOS (рекомендуется)
- Swift 5.5+
- Homebrew (для удобной установки)

### Шаги установки:
1. Установите Homebrew, если он еще не установлен:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
2. Установите Vapor Toolbox с помощью Homebrew:
   ```bash
   brew install vapor
   ```
3. Проверьте успешную установку:
   ```bash
   vapor --version
   ```

Если установка прошла успешно, можно создавать и управлять проектами.

## Структура проекта Vapor

После создания проекта с помощью команды:
```bash
vapor new MyVaporApp
```
Вы получите следующую структуру папок:

```
MyVaporApp/
│-- Sources/
│   └── App/
│       ├── Controllers/
│       ├── Models/
│       ├── Config/
│       ├── routes.swift
│       └── configure.swift
│-- Public/
│-- Resources/
│-- Tests/
│-- Package.swift
│-- README.md
```

### Основные директории и файлы:
- **Sources/App/** — содержит основную логику приложения.
  - `Controllers/` — контроллеры для обработки запросов.
  - `Models/` — модели данных.
  - `routes.swift` — настройка маршрутов.
  - `configure.swift` — конфигурация приложения.
- **Public/** — статические файлы (изображения, стили, скрипты).
- **Resources/** — шаблоны и дополнительные ресурсы.
- **Tests/** — тесты для приложения.
- **Package.swift** — файл управления зависимостями через Swift Package Manager.

---

После успешной настройки можно запустить сервер:
```bash
vapor run
```

Приложение будет доступно по адресу: [http://localhost:8080](http://localhost:8080).

---

# Работа с базами данных (SQLite, PostgreSQL)

## Подключение базы данных SQLite
Подключение базы данных в `configure.swift`:
```swift
app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
```

## Подключение базы данных PostgreSQL

Для работы с PostgreSQL необходимо добавить зависимость в `Package.swift`:
```swift
.package(url: "https://github.com/vapor/postgres-kit.git", from: "2.0.0")
```

Добавьте PostgreSQL в конфигурацию приложения:
```swift
import FluentPostgresDriver

app.databases.use(.postgres(
    hostname: "localhost",
    username: "postgres",
    password: "password",
    database: "vapor_database"
), as: .psql)
```

### Установка PostgreSQL на macOS
1. Установите PostgreSQL с помощью Homebrew:
   ```bash
   brew install postgresql
   ```
2. Запустите PostgreSQL сервис:
   ```bash
   brew services start postgresql
   ```
3. Создайте базу данных:
   ```bash
   createdb vapor_database
   ```

### Проверка подключения
После настройки можно выполнить тестовый запрос к базе данных для проверки подключения:
```swift
app.get("check-db") { req in
    req.db.raw("SELECT version();").all().map { rows in
        rows.description
    }
}
```

Теперь сервер Vapor сможет взаимодействовать с PostgreSQL.

---

# Работа с маршрутизацией

## Основные типы маршрутов: GET, POST, PUT, DELETE
Vapor поддерживает стандартные HTTP-методы для обработки запросов:
- **GET** — получение данных.
- **POST** — отправка новых данных на сервер.
- **PUT** — обновление существующих данных.
- **DELETE** — удаление данных.

Примеры маршрутов в файле `routes.swift`:
```swift
app.get("hello") { req in
    return "Hello, Vapor!"
}

app.post("user") { req -> HTTPStatus in
    let user = try req.content.decode(User.self)
    return .created
}

app.put("user", ":id") { req -> String in
    let id = req.parameters.get("id") ?? "unknown"
    return "Updated user with ID: \(id)"
}

app.delete("user", ":id") { req -> String in
    let id = req.parameters.get("id") ?? "unknown"
    return "Deleted user with ID: \(id)"
}
```

## Обработка запросов и ответов
В Vapor запросы обрабатываются через замыкания, принимающие объект `Request`. Ответ может быть простым текстом, JSON или другим типом данных.

Пример обработки запроса и ответа:
```swift
app.get("json") { req -> Response in
    let response = Response(status: .ok)
    try response.content.encode(["message": "Hello, JSON!"])
    return response
}
```

## Middleware и параметры маршрутов
**Middleware** — это промежуточные обработчики, которые выполняются до или после основного обработчика маршрута. Они позволяют выполнять различные задачи, такие как логирование, аутентификация, обработка ошибок и настройка заголовков HTTP-ответов.

**Типы middleware в Vapor:**
- **Глобальные middleware** — применяются ко всем запросам.
- **Групповые middleware** — применяются к группе маршрутов.
- **Локальные middleware** — применяются к конкретному маршруту.

Пример создания middleware для логирования:
```swift
final class LoggingMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        print("Incoming request: \(request.method) \(request.url)")
        return next.respond(to: request)
    }
}
app.middleware.use(LoggingMiddleware())
```

**Параметры маршрутов** позволяют обрабатывать динамические значения в URL, что дает возможность передавать переменные в запросах. Например, можно извлекать значения, такие как идентификатор пользователя или название категории, и использовать их для обработки запроса.
```swift
app.get("user", ":id") { req -> String in
    let id = req.parameters.get("id") ?? "unknown"
    return "User ID: \(id)"
}
```

---

# Работа с моделями и Fluent ORM

## Введение в Fluent ORM
Fluent — это ORM (Object-Relational Mapping) фреймворк для работы с базами данных в Vapor. Он предоставляет удобный интерфейс для взаимодействия с SQL и NoSQL базами данных с использованием моделей на Swift.

## Определение моделей и миграций

Пример создания модели в Vapor:
```swift
import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    init() {}

    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
```

# Работа с контроллерами и организация кода

## MVC-архитектура в Vapor
Vapor следует принципу MVC (Model-View-Controller), который помогает организовать код приложения:
- **Model (Модель)** — управляет данными и логикой их обработки.
- **View (Представление)** — отвечает за отображение данных (не используется в чистом API).
- **Controller (Контроллер)** — обрабатывает запросы и управляет бизнес-логикой.

## Создание контроллеров
Контроллеры позволяют группировать обработчики маршрутов и разделять логику. Пример контроллера для управления пользователями:

```swift
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.get(use: getAllHandler)
        users.post(use: createHandler)
        users.get(":userID", use: getHandler)
    }

    func getAllHandler(req: Request) -> [String] {
        ["User 1", "User 2"]
    }

    func createHandler(req: Request) throws -> HTTPStatus {
        return .created
    }

    func getHandler(req: Request) throws -> String {
        let userID = req.parameters.get("userID") ?? "Unknown"
        return "User ID: \(userID)"
    }
}
```

### Регистрация контроллера в приложении
Добавьте контроллер в `configure.swift`:

```swift
try app.register(collection: UserController())
```

Теперь маршруты, определенные в контроллере, будут доступны по следующим путям:
- `GET /users` — получить всех пользователей.
- `POST /users` — создать нового пользователя.
- `GET /users/:userID` — получить пользователя по ID.

## Разделение логики
Для упрощения сопровождения кода в крупных проектах рекомендуется разбивать логику на:
- **Контроллеры** — обработка маршрутов.
- **Сервисы** — бизнес-логика.
- **Модели** — взаимодействие с базой данных.

Пример разделения логики:
```swift
struct UserService {
    func getAllUsers() -> [String] {
        return ["Alice", "Bob"]
    }
}
```

В контроллере:
```swift
let userService = UserService()
let users = userService.getAllUsers()
```

Такой подход делает код более читаемым и тестируемым.

## Аутентификация и валидация

### Методы аутентификации в Vapor
Vapor поддерживает несколько методов аутентификации, включая:
- **JWT (JSON Web Token)** — широко используемый метод для аутентификации API-запросов.
- **Basic Auth** — простая аутентификация с использованием пары логин/пароль.

Пример настройки JWT-аутентификации:
```swift
import Vapor
import JWT

struct UserPayload: Content, Authenticatable, JWTPayload {
    var sub: String
    var exp: ExpirationClaim

    func verify(using signer: JWTSigner) throws {
        try self.exp.verifyNotExpired()
    }
}
```

### Валидация входных данных
Для проверки данных запроса в Vapor используется протокол `Validatable`.

Пример модели с валидацией:
```swift
struct UserInput: Content, Validatable {
    var username: String
    var email: String
    
    static func validations(_ validations: inout Validations) {
        validations.add("username", as: String.self, is: .count(3...))
        validations.add("email", as: String.self, is: .email)
    }
}

func createUserHandler(req: Request) throws -> HTTPStatus {
    try UserInput.validate(content: req)
    return .created
}
```

Такой подход позволяет обрабатывать входные данные эффективно и безопасно.

