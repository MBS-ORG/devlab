/**
 * Tests for main application
 */

const request = require('supertest');
const app = require('../index');

describe('Application Tests', () => {
  describe('GET /', () => {
    it('should return application info', async () => {
      const response = await request(app).get('/');

      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('name');
      expect(response.body).toHaveProperty('version');
      expect(response.body).toHaveProperty('status', 'running');
    });
  });

  describe('GET /health', () => {
    it('should return health status', async () => {
      const response = await request(app).get('/health');

      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('status', 'healthy');
      expect(response.body).toHaveProperty('uptime');
    });
  });

  describe('GET /api/version', () => {
    it('should return version info', async () => {
      const response = await request(app).get('/api/version');

      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('version');
      expect(response.body).toHaveProperty('apiVersion');
    });
  });

  describe('GET /api/info', () => {
    it('should return system info', async () => {
      const response = await request(app).get('/api/info');

      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('platform');
      expect(response.body).toHaveProperty('memory');
      expect(response.body).toHaveProperty('cpus');
    });
  });

  describe('POST /api/echo', () => {
    it('should echo back the request body', async () => {
      const testData = { message: 'hello world' };
      const response = await request(app).post('/api/echo').send(testData);

      expect(response.status).toBe(200);
      expect(response.body.received).toEqual(testData);
    });
  });

  describe('404 Handler', () => {
    it('should return 404 for unknown routes', async () => {
      const response = await request(app).get('/nonexistent');

      expect(response.status).toBe(404);
      expect(response.body).toHaveProperty('error', 'Not Found');
    });
  });
});
