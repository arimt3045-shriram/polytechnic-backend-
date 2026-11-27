const express = require('express');
const cors = require('cors');
require('dotenv').config();

const applicationRoutes = require('./routes/applications');
const paymentRoutes = require('./routes/payments');

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// API Routes
app.use('/api/applications', applicationRoutes);
app.use('/api/payments', paymentRoutes);

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.status(200).json({ status: 'OK', service: 'Polytechnic Admission Backend API', timestamp: new Date() });
});

app.listen(PORT, () => {
  console.log(`Polytechnic Admission Backend Server running on port ${PORT}`);
});
