const mongoose = require('mongoose');

const bookmarkSchema = new mongoose.Schema({
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
    createdAt: {
        type: Date,
        default: Date.now
    }
});

module.exports = mongoose.model('Bookmark', bookmarkSchema);
