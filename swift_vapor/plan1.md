### **1. Введение в Swift Vapor (30 минут)**  
**Теория:**  
- Что такое Vapor? Обзор возможностей и области применения.  
- Установка Vapor Toolbox и зависимостей.  
- Структура проекта Vapor (Sources, Public, Config).  

**Практика:**  
- Установка Vapor с помощью Homebrew:  
  ```bash
  brew install vapor  
  vapor --version  
  ```
- Создание нового проекта:  
  ```bash
  vapor new MyVaporApp  
  cd MyVaporApp  
  vapor build  
  vapor run  
  ```
- Проверка работы сервера (`http://localhost:8080`).

---

### **2. Работа с маршрутизацией**  
**Теория:**  
- Основные типы маршрутов: GET, POST, PUT, DELETE.  
- Обработка запросов и ответов.  
- Middleware и параметры маршрутов.  

**Практика:**  
- Добавление простых маршрутов в `routes.swift`:  
  ```swift
  app.get("hello") { req in  
      return "Hello, Vapor!"  
  }
  ```
- Обработка параметров:  
  ```swift
  app.get("greet", ":name") { req -> String in  
      let name = req.parameters.get("name") ?? "world"  
      return "Hello, \(name)!"  
  }
  ```
- Создание Middleware для логирования запросов.

---

### **3. Работа с моделями и Fluent**  
**Теория:**  
- Введение в Fluent ORM.  
- Определение моделей и миграций.  
- Работа с базами данных (SQLite, PostgreSQL).  

**Практика:**  
- Установка Fluent SQLite:  
  ```bash
  vapor package add fluent sqlite  
  ```
- Создание модели `User`:  
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
- Добавление маршрута для сохранения пользователя в БД.  
- Запуск миграций и тестирование запросов через Postman.  

---

### **4. Контроллеры и организация кода**  
**Теория:**  
- MVC-архитектура в Vapor.  
- Создание контроллеров.  
- Разделение логики.  

**Практика:**  
- Создание `UserController`:  
  ```swift
  struct UserController: RouteCollection {  
      func boot(routes: RoutesBuilder) throws {  
          let users = routes.grouped("users")  
          users.get(use: index)  
          users.post(use: create)  
      }  

      func index(req: Request) throws -> EventLoopFuture<[User]> {  
          return User.query(on: req.db).all()  
      }  

      func create(req: Request) throws -> EventLoopFuture<User> {  
          let user = try req.content.decode(User.self)  
          return user.save(on: req.db).map { user }  
      }  
  }
  ```
- Регистрация контроллера в `routes.swift`.  
- Тестирование маршрутов через Postman.

---

### **5. Аутентификация и валидация**  
**Теория:**  
- Методы аутентификации в Vapor (JWT, Basic Auth).  
- Валидация входных данных.  

**Практика:**  
- Добавление валидации входных данных:  
  ```swift
  struct CreateUserRequest: Content {  
      var name: String  
  }
  ```
- Использование `ValidationMiddleware`.  
- Реализация простой аутентификации через токены.  

---

### **6. Вопросы**  
- Ответы на вопросы.  
- Разбор возможных проблем и ошибок.  
- Дополнительные ресурсы для изучения (документация, курсы).  

---
