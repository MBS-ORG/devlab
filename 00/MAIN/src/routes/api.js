/**
 * API Routes
 */

const express = require('express');
const router = express.Router();

/**
 * GET /api/version
 * Returns API version information
 */
router.get('/version', (req, res) => {
  res.json({
    version: '1.1.1',
    apiVersion: 'v1',
    buildDate: new Date().toISOString(),
    nodeVersion: process.version,
  });
});

/**
 * GET /api/info
 * Returns system information
 */
router.get('/info', (req, res) => {
  res.json({
    platform: process.platform,
    architecture: process.arch,
    nodeVersion: process.version,
    memory: {
      total: Math.round(require('os').totalmem() / 1024 / 1024) + ' MB',
      free: Math.round(require('os').freemem() / 1024 / 1024) + ' MB',
      used:
        Math.round(
          (require('os').totalmem() - require('os').freemem()) / 1024 / 1024
        ) + ' MB',
    },
    cpus: require('os').cpus().length,
    uptime: Math.floor(process.uptime()) + ' seconds',
  });
});

/**
 * POST /api/echo
 * Echo endpoint for testing
 */
router.post('/echo', (req, res) => {
  res.json({
    received: req.body,
    timestamp: new Date().toISOString(),
  });
});

module.exports = router;
