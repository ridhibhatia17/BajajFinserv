/**
 * Health Routes
 * GET /health endpoint
 */

const express = require('express');
const { handleHealthCheck } = require('../controllers/health.controller');

const router = express.Router();

/**
 * GET /health
 * Health check endpoint
 */
router.get('/health', handleHealthCheck);

module.exports = router;
