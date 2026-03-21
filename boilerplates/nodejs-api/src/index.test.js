'use strict';

const { describe, it, before, after } = require('node:test');
const assert = require('node:assert/strict');

let app;
let server;
let baseUrl;

before(async () => {
  process.env.PORT = '0'; // random port
  app = require('./index');
  await new Promise((resolve) => app.on('listening', resolve));
  const { port } = app.address();
  baseUrl = `http://localhost:${port}`;
  server = app;
});

after(() => server.close());

describe('GET /health', () => {
  it('returns 200 with status ok', async () => {
    const res = await fetch(`${baseUrl}/health`);
    assert.equal(res.status, 200);
    const body = await res.json();
    assert.equal(body.status, 'ok');
  });
});

describe('Items API', () => {
  let createdId;

  it('POST /api/v1/items creates an item', async () => {
    const res = await fetch(`${baseUrl}/api/v1/items`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name: 'Test Item', description: 'A test' }),
    });
    assert.equal(res.status, 201);
    const body = await res.json();
    assert.equal(body.name, 'Test Item');
    createdId = body.id;
  });

  it('GET /api/v1/items returns list', async () => {
    const res = await fetch(`${baseUrl}/api/v1/items`);
    assert.equal(res.status, 200);
    const body = await res.json();
    assert.ok(Array.isArray(body));
    assert.ok(body.length > 0);
  });

  it('GET /api/v1/items/:id returns item', async () => {
    const res = await fetch(`${baseUrl}/api/v1/items/${createdId}`);
    assert.equal(res.status, 200);
  });

  it('DELETE /api/v1/items/:id deletes item', async () => {
    const res = await fetch(`${baseUrl}/api/v1/items/${createdId}`, { method: 'DELETE' });
    assert.equal(res.status, 204);
  });

  it('GET non-existent item returns 404', async () => {
    const res = await fetch(`${baseUrl}/api/v1/items/99999`);
    assert.equal(res.status, 404);
  });
});
