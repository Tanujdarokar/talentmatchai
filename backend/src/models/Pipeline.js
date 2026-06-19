const mongoose = require('mongoose');

const pipelineSchema = new mongoose.Schema({
    candidateId: {
        type: mongoose.Schema.ObjectId,
        ref: 'Candidate',
        required: true
    },
    jobId: {
        type: mongoose.Schema.ObjectId,
        ref: 'Job',
        required: true
    },
    status: {
        type: String,
        enum: [
            'Applied',
            'Shortlisted',
            'Interview Scheduled',
            'Interviewed',
            'Offered',
            'Hired',
            'Rejected'
        ],
        default: 'Applied'
    },
    notes: String,
    updatedAt: {
        type: Date,
        default: Date.now
    }
});

module.exports = mongoose.model('Pipeline', pipelineSchema);
