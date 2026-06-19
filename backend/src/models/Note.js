const mongoose = require('mongoose');

const noteSchema = new mongoose.Schema({
    recruiterId: {
        type: mongoose.Schema.ObjectId,
        ref: 'Recruiter',
        required: true
    },
    candidateId: {
        type: mongoose.Schema.ObjectId,
        ref: 'Candidate',
        required: true
    },
    note: {
        type: String,
        required: [true, 'Please add a note']
    },
    createdAt: {
        type: Date,
        default: Date.now
    }
});

module.exports = mongoose.model('Note', noteSchema);
