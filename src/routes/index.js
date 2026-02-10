/**
 * Main Routes
 * Central routing configuration
 */

const express = require('express');
const bfhlRoutes = require('./bfhl.routes');
const healthRoutes = require('./health.routes');

const router = express.Router();

// Mount routes
router.use('/', bfhlRoutes);
router.use('/', healthRoutes);

module.exports = router;
