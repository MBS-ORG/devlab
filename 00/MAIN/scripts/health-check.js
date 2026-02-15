#!/usr/bin/env node
/**
 * Health Check Script
 * Validates all service connections
 */

const http = require('http');
const { Pool } = require('pg');
const redis = require('redis');
require('dotenv').config();

const checks = {
  postgres: false,
  redis: false,
  app: false,
};

async function checkPostgres() {
  const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
  });

  try {
    await pool.query('SELECT NOW()');
    checks.postgres = true;
    console.log('✅ PostgreSQL: healthy');
  } catch (err) {
    console.error('❌ PostgreSQL: unhealthy -', err.message);
  } finally {
    await pool.end();
  }
}

async function checkRedis() {
  try {
    const client = redis.createClient({
      url: process.env.REDIS_URL,
    });

    await client.connect();
    await client.ping();
    checks.redis = true;
    console.log('✅ Redis: healthy');
    await client.quit();
  } catch (err) {
    console.error('❌ Redis: unhealthy -', err.message);
  }
}

async function checkApp() {
  return new Promise((resolve) => {
    const req = http.get('http://localhost:3000/health', (res) => {
      if (res.statusCode === 200) {
        checks.app = true;
        console.log('✅ Application: healthy');
      } else {
        console.error(`❌ Application: unhealthy - HTTP ${res.statusCode}`);
      }
      resolve();
    });

    req.on('error', (err) => {
      console.error('❌ Application: unhealthy -', err.message);
      resolve();
    });

    req.setTimeout(5000, () => {
      req.destroy();
      console.error('❌ Application: unhealthy - timeout');
      resolve();
    });
  });
}

async function runHealthChecks() {
  console.log('🏥 Running health checks...\n');

  await checkPostgres();
  await checkRedis();
  await checkApp();

  console.log('\n📊 Health Check Summary:');
  console.log(`   PostgreSQL: ${checks.postgres ? '✅' : '❌'}`);
  console.log(`   Redis:      ${checks.redis ? '✅' : '❌'}`);
  console.log(`   App:        ${checks.app ? '✅' : '❌'}`);

  const allHealthy = Object.values(checks).every((v) => v);
  if (!allHealthy) {
    console.log('\n⚠️  Some services are unhealthy');
    process.exit(1);
  } else {
    console.log('\n✅ All services healthy');
  }
}

runHealthChecks();
