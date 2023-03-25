# TodosApp

LiveViewベースのTodoアプリのサンプルです。

## Schemas

### User

- `phx.gen.auth`で生成。
- 細かいところは省略

| name            | type            |
|-----------------|-----------------| 
| id              | integer         |
| email           | string          |
| hashed_password | string          |
| confirmed_at    | native_datetime |

### Todos

| name            | type                 |
|-----------------|----------------------| 
| id              | integer              |
| name            | string               |
| status          | string (todo, done)  |
| user_id         | references:users     |
