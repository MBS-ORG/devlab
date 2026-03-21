# Node.js API Boilerplate

Minimal Express REST API with input validation, health check, error handling, and tests — using only Node.js built-ins plus Express and Zod.

## Stack

- **Runtime**: Node.js 20+ (native test runner, native watch mode)
- **Framework**: Express 4
- **Validation**: Zod
- **Tests**: `node:test` (no extra test framework)

## Quick Start

```bash
npm install
npm run dev      # watch mode
npm test         # run tests
npm start        # production
```

## Project Structure

```
src/
├── index.js       # App entry point, middleware, error handler
├── index.test.js  # Integration tests
└── routes.js      # Route definitions with validation
```

## API Endpoints

| Method | Path | Description |
|---|---|---|
| `GET` | `/health` | Health check |
| `GET` | `/api/v1/items` | List all items |
| `POST` | `/api/v1/items` | Create item (`{ name, description? }`) |
| `GET` | `/api/v1/items/:id` | Get item by ID |
| `DELETE` | `/api/v1/items/:id` | Delete item |

## Extending

1. Add a new router file in `src/` (e.g., `src/users.js`).
2. Mount it in `src/index.js`: `app.use('/api/v1/users', require('./users'))`.
3. Add Zod schemas for request validation using the `validate()` helper in `src/routes.js`.
