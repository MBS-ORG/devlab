#!/usr/bin/env node
/**
 * Database Seeding Script
 */

const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

async function seed() {
  console.log('🌱 Seeding database...');

  try {
    // Insert sample users
    const userResult = await pool.query(`
      INSERT INTO users (email, name) VALUES
        ('admin@example.com', 'Admin User'),
        ('developer@example.com', 'Developer User'),
        ('tester@example.com', 'Tester User')
      ON CONFLICT (email) DO NOTHING
      RETURNING id;
    `);

    if (userResult.rows.length > 0) {
      const userId = userResult.rows[0].id;

      // Insert sample posts
      await pool.query(
        `
        INSERT INTO posts (user_id, title, content, published) VALUES
          ($1, 'Getting Started', 'Welcome to the DevContainer framework!', true),
          ($1, 'Advanced Features', 'Learn about advanced CI/CD features.', true),
          ($1, 'Draft Post', 'This is a draft post.', false)
        ON CONFLICT DO NOTHING;
      `,
        [userId]
      );
    }

    console.log('✅ Database seeded successfully');
  } catch (err) {
    console.error('❌ Seeding failed:', err.message);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

seed();
