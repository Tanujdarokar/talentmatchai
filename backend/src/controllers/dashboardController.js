const Job = require('../models/Job');
const Candidate = require('../models/Candidate');
const Ranking = require('../models/Ranking');

exports.getStats = async (req, res, next) => {
    try {
        const totalJobs = await Job.countDocuments();
        const totalCandidates = await Candidate.countDocuments();
        const totalRanked = await Ranking.countDocuments();

        // Mocking some other stats
        const interviewsToday = 8;

        res.status(200).json({
            success: true,
            data: {
                totalJobs,
                totalCandidates,
                totalRanked,
                interviewsToday
            }
        });
    } catch (err) {
        next(err);
    }
};
