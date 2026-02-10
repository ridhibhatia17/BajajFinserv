const express = require('express');
const { handleHealthCheck } = require('../controllers/health.controller');

const router = express.Router();

router.get('/health', handleHealthCheck);

module.exports = router;
