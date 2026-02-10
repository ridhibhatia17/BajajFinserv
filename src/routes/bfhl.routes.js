/**
 * BFHL Routes
 * POST /bfhl endpoint
 */

const express = require('express');
const { handleBfhlRequest } = require('../controllers/bfhl.controller');
const { validateBfhlRequest } = require('../middleware/validation');

const router = express.Router();

/**
 * POST /bfhl
 * Main BFHL endpoint for processing requests
 */
router.post('/bfhl', validateBfhlRequest, handleBfhlRequest);

module.exports = router;
