const express = require('express');
const dotenv = require('dotenv');
const morgan = require('morgan');
const helmet = require('helmet');
const cors = require('cors');
const path = require('path');
const errorHandler = require('./middleware/error');

// Load env vars
dotenv.config();

const app = express();

// Body parser
app.use(express.json());

// Dev logging middleware
if (process.env.NODE_ENV === 'development') {
    app.use(morgan('dev'));
}

// Set security headers
app.use(helmet());

// Enable CORS
app.use(cors());

// Set static folder
app.use(express.static(path.join(__dirname, 'public')));

// Route files
const auth = require('./routes/auth');
const jobs = require('./routes/jobs');
const candidates = require('./routes/candidates');
const rankings = require('./routes/rankings');
const pipeline = require('./routes/pipeline');
const bookmarks = require('./routes/bookmarks');
const notes = require('./routes/notes');
const reports = require('./routes/reports');
const resumes = require('./routes/resumes');
const dashboard = require('./routes/dashboard');
const imports = require('./routes/importRoutes');

// Mount routers
app.use('/api/auth', auth);
app.use('/api/jobs', jobs);
app.use('/api/candidates', candidates);
app.use('/api/rankings', rankings);
app.use('/api/pipeline', pipeline);
app.use('/api/bookmarks', bookmarks);
app.use('/api/notes', notes);
app.use('/api/reports', reports);
app.use('/api/resumes', resumes);
app.use('/api/dashboard', dashboard);
app.use('/api/import', imports);

app.use(errorHandler);

module.exports = app;
