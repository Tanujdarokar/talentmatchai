const mongoose = require('mongoose');

const rankingSchema = new mongoose.Schema({
    jobId: {
        type: mongoose.Schema.ObjectId,
        ref: 'Job',
        required: true
    },
    rankedCandidates: [
        {
            candidateId: {
                type: mongoose.Schema.ObjectId,
                ref: 'Candidate'
            },
            finalScore: Number,
            semanticScore: Number,
            experienceScore: Number,
            skillScore: Number,
            behavioralScore: Number,
            platformScore: Number,
            recommendation: String
        }
    ],
    createdAt: {
        type: Date,
        default: Date.now
    }
});

module.exports = mongoose.model('Ranking', rankingSchema);
