const express = require('express')
const {createJobRequest, getAllJobRequests} = require('../controllers/jobRequestController.js')

const router = express.Router();

// POST route to create a job request
router.post("/job-request", createJobRequest);

// GET route to retrieve all job requests
router.get("/job-requests", getAllJobRequests);

module.exports = router;
