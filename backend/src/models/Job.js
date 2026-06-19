const mongoose = require('mongoose');

const jobSchema = new mongoose.Schema({
    title: { type: String, required: true },
    department: String,
    employmentType: String,
    experience_required_min: { type: Number, default: 0 },
    required_skills: [String],
    preferred_skills: [String],
    responsibilities: [String],
    description: String,

    // Extracted Intent & Behavioral Expectations
    behavioral_expectations: [String],
    hidden_intent: String,
    target_industries: [String],

    status: { type: String, enum: ['Open', 'Closed'], default: 'Open' },
    createdBy: { type: mongoose.Schema.ObjectId, ref: 'Recruiter' },
    createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Job', jobSchema);
