'use strict';

const express = require('express');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

// Remove fingerprinting header
app.disable('x-powered-by');

// Health check — must respond before authentication/authorization
app.get('/health', (_req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Routes
app.use('/api/v1', require('./routes'));

// 404 handler
app.use((_req, res) => {
  res.status(404).json({ error: 'Not found' });
});

// Global error handler
// eslint-disable-next-line no-unused-vars
app.use((err, _req, res, _next) => {
  const status = err.status || 500;
  const message = status < 500 ? err.message : 'Internal server error';
  if (status >= 500) console.error(err);
  res.status(status).json({ error: message });
});

app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});

module.exports = app;
