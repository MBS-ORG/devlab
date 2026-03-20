'use strict';

const { Router } = require('express');
const { z } = require('zod');

const router = Router();

// --- Validation helper ---
function validate(schema) {
  return (req, _res, next) => {
    const result = schema.safeParse(req.body);
    if (!result.success) {
      const err = new Error(result.error.issues.map((i) => i.message).join('; '));
      err.status = 400;
      return next(err);
    }
    req.body = result.data;
    next();
  };
}

// --- Example resource: items ---
const itemSchema = z.object({
  name: z.string().min(1).max(100),
  description: z.string().max(500).optional(),
});

const items = new Map();
let nextId = 1;

router.get('/items', (_req, res) => {
  res.json([...items.values()]);
});

router.post('/items', validate(itemSchema), (req, res) => {
  const id = nextId++;
  const item = { id, ...req.body, createdAt: new Date().toISOString() };
  items.set(id, item);
  res.status(201).json(item);
});

router.get('/items/:id', (req, res, next) => {
  const item = items.get(Number(req.params.id));
  if (!item) {
    const err = new Error('Item not found');
    err.status = 404;
    return next(err);
  }
  res.json(item);
});

router.delete('/items/:id', (req, res, next) => {
  const id = Number(req.params.id);
  if (!items.has(id)) {
    const err = new Error('Item not found');
    err.status = 404;
    return next(err);
  }
  items.delete(id);
  res.status(204).end();
});

module.exports = router;
