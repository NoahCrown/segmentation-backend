const express = require('express')
const jobRequestRoutes = require('../routes/jobRequestRoutes.js')
const {errorHandler} = require('../middleware/errorHandler.js')
const dotenv = require('dotenv')


dotenv.config();

const app = express();

// Middleware to parse JSON requests
app.use(express.json());

// Routes
app.use("/api", jobRequestRoutes);

app.get('/', (req, res) => {
  res.json({ message: "Hello from Segmentation Backend", version: "1.0.0" });
});


// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy', timestamp: new Date().toISOString() });
});

module.exports = app