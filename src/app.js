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

app.get('/api/hello', (req, res) => {
  res.json("Hello world")
})


const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
