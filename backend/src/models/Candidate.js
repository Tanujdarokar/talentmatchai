const mongoose = require('mongoose');

const candidateSchema = new mongoose.Schema({
    candidate_id: { type: String, unique: true, required: true },
    fullName: { type: String, required: true },
    email: { type: String, required: true },
    phone: String,
    currentRole: String,
    experience_years: { type: Number, default: 0 },
    skills: [String],
    normalized_skills: [String],
    career_history: [{
        company: String,
        role: String,
        duration_months: Number,
        description: String
    }],
    education: [{
        degree: String,
        institution: String,
        year: Number
    }],
    certifications: [String],
    projects: [String],
    resume_text: String,
    resumePath: String,

    // Redrob & Platform Signals
    platform_activity_score: { type: Number, default: 0 },
    behavioral_signal_score: { type: Number, default: 0 },
    engagement_rate: { type: Number, default: 0 },
    technical_assessment_score: { type: Number, default: 0 },

    raw_data: Object, // Store original JSON for reference
    createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Candidate', candidateSchema);
