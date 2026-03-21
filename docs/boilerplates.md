# Boilerplates

Ready-to-run project starters. Copy, rename, and build on top of them.

## Node.js API (`boilerplates/nodejs-api/`)

Minimal Express REST API with input validation, error handling, health check, and tests.

```bash
cp -r boilerplates/nodejs-api my-api
cd my-api
npm install
npm run dev   # starts with --watch (auto-restart on file changes)
npm test      # runs node:test
```

**Stack:** Node.js 20+, Express 4, Zod (validation), `node:test` (no extra test framework).

**Endpoints out of the box:**

| Method | Path | Description |
|---|---|---|
| `GET` | `/health` | Health check |
| `GET` | `/api/v1/items` | List items (in-memory) |
| `POST` | `/api/v1/items` | Create item |
| `GET` | `/api/v1/items/:id` | Get item by ID |
| `DELETE` | `/api/v1/items/:id` | Delete item |

**To add a new resource:**
1. Add a new router file, e.g. `src/users.js`.
2. Mount it in `src/index.js`: `app.use('/api/v1/users', require('./users'))`.
3. Use the `validate(schema)` middleware helper for request body validation.

---

## Python Script (`boilerplates/python-script/`)

CLI script boilerplate with argument parsing, structured logging, exit codes, and pytest tests.

```bash
cp -r boilerplates/python-script my-script
cd my-script
pip install -r requirements-dev.txt
python main.py --input sample.txt --output result.json
pytest -v
```

**Features:**
- `argparse` with typed, validated arguments and `--help`
- Structured logging: `--verbose` / `-v` for debug output
- Exit codes: `0` success, `1` expected error (e.g. file not found), `2` unexpected exception
- `pytest` with `tmp_path` fixture for isolated file I/O testing

**To customise:**
1. Add arguments to `parse_args()`.
2. Replace the body of `process()` with your logic.
3. Add dependencies to `requirements.txt`.
