# TalentMatch AI - Backend

Production-ready backend for TalentMatch AI Recruitment System built with Node.js, Express, and MongoDB.

## Features

- **JWT Authentication**: Secure recruiter registration and login.
- **Job Management**: CRUD operations for job postings with search and filters.
- **Candidate Management**: Candidate profiles, skills, and experience tracking.
- **Resume Handling**: Upload PDF/DOCX resumes and extract text.
- **Bulk Import**: Import candidate data via CSV.
- **AI Rankings Integration**: Store and retrieve candidate rankings for jobs.
- **Hiring Pipeline**: Track candidate progress from application to hiring.
- **Reports**: Export rankings and candidate data to CSV and JSON.
- **Security**: Helmet, CORS, and password hashing with bcrypt.

## Installation

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Configure environment variables in `.env`:
   ```env
   PORT=5000
   MONGO_URI=mongodb://127.0.0.1:27017/talentmatch_ai
   JWT_SECRET=your_secret_key
   JWT_EXPIRE=30d
   NODE_ENV=development
   ```

## Usage

### Run Development Server
```bash
npm run dev
```

### Run Production Server
```bash
npm start
```

## API Documentation

### Auth
- `POST /api/auth/register`: Register a new recruiter.
- `POST /api/auth/login`: Login and receive JWT.
- `GET /api/auth/profile`: Get logged-in recruiter profile.
- `PUT /api/auth/profile`: Update profile info.

### Jobs
- `GET /api/jobs`: List all jobs (supports pagination & filters).
- `POST /api/jobs`: Create a new job.
- `GET /api/jobs/:id`: Get job details.
- `PUT /api/jobs/:id`: Update job.
- `DELETE /api/jobs/:id`: Delete job.

### Candidates
- `GET /api/candidates`: List candidates (supports search & filters).
- `POST /api/candidates`: Create a candidate.
- `POST /api/candidates/upload-resume`: Upload a resume file.
- `POST /api/candidates/import-csv`: Bulk import candidates via CSV.

### Rankings
- `POST /api/rankings`: Save AI-generated ranking results.
- `GET /api/rankings`: Get all rankings.

### Reports
- `GET /api/reports/rankings/csv`: Download rankings as CSV.
- `GET /api/reports/candidates/csv`: Download candidate list as CSV.

---

Built with ❤️ for TalentMatch AI.
