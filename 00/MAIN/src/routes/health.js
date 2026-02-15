/**
 * Health Check Routes
 */

const express = require('express');
const router = express.Router();
const { Pool } = require('pg');
const redis = require('redis');
const logger = require('../config/logger');

// Database connection pool
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

// Redis client
let redisClient;
try {
  redisClient = redis.createClient({
    url: process.env.REDIS_URL,
  });
  redisClient.connect().catch((err) => {
    logger.error('Redis connection error', { error: err.message });
  });
} catch (err) {
  logger.error('Redis initialization error', { error: err.message });
}

/**
 * Basic health check endpoint
 */
router.get('/', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV,
  });
});

/**
 * Detailed health check with service dependencies
 */
router.get('/detailed', async (req, res) => {
  const health = {
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV,
    services: {
      database: { status: 'unknown' },
      redis: { status: 'unknown' },
    },
  };

  // Check PostgreSQL
  try {
    const result = await pool.query('SELECT NOW()');
    health.services.database = {
      status: 'healthy',
      responseTime: result.rows[0] ? 'ok' : 'slow',
    };
  } catch (err) {
    health.services.database = {
      status: 'unhealthy',
      error: err.message,
    };
    health.status = 'degraded';
  }

  // Check Redis
  try {
    if (redisClient && redisClient.isOpen) {
      await redisClient.ping();
      health.services.redis = { status: 'healthy' };
    } else {
      health.services.redis = {
        status: 'unhealthy',
        error: 'Not connected',
      };
      health.status = 'degraded';
    }
  } catch (err) {
    health.services.redis = {
      status: 'unhealthy',
      error: err.message,
    };
    health.status = 'degraded';
  }

  const statusCode = health.status === 'healthy' ? 200 : 503;
  res.status(statusCode).json(health);
});

/**
 * Readiness probe for Kubernetes
 */
router.get('/ready', async (req, res) => {
  try {
    await pool.query('SELECT 1');
    res.status(200).json({ ready: true });
  } catch (err) {
    res.status(503).json({ ready: false, error: err.message });
  }
});

/**
 * Liveness probe for Kubernetes
 */
router.get('/live', (req, res) => {
  res.status(200).json({ alive: true });
});

module.exports = router;
