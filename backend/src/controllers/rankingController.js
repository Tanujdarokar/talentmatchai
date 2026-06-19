const rankingService = require('../services/rankingService');
const Ranking = require('../models/Ranking');

exports.triggerRanking = async (req, res, next) => {
    try {
        const { jobId } = req.body;
        const results = await rankingService.rankTalentPool(jobId);

        // Save top results to DB
        const rankingDoc = await Ranking.create({
            jobId: jobId,
            rankedCandidates: results.map(r => ({
                candidateId: r.candidate._id,
                finalScore: r.score,
                semanticScore: r.breakdown.semantic,
                experienceScore: r.breakdown.experience,
                skillScore: r.breakdown.skills,
                behavioralScore: r.breakdown.behavioral,
                platformScore: r.breakdown.activity,
                recommendation: r.candidate.fullName // Simplified
            }))
        });

        res.status(200).json({ success: true, data: rankingDoc });
    } catch (err) {
        next(err);
    }
};

exports.getRankings = async (req, res, next) => {
    try {
        const rankings = await Ranking.find().populate('jobId').populate('rankedCandidates.candidateId');
        res.status(200).json({ success: true, data: rankings });
    } catch (err) {
        next(err);
    }
};

exports.getRanking = async (req, res, next) => {
    try {
        const ranking = await Ranking.findById(req.params.id).populate('jobId').populate('rankedCandidates.candidateId');
        if (!ranking) return res.status(404).json({ success: false, message: 'Ranking not found' });
        res.status(200).json({ success: true, data: ranking });
    } catch (err) {
        next(err);
    }
};

exports.deleteRanking = async (req, res, next) => {
    try {
        const ranking = await Ranking.findByIdAndDelete(req.params.id);
        if (!ranking) return res.status(404).json({ success: false, message: 'Ranking not found' });
        res.status(200).json({ success: true, data: {} });
    } catch (err) {
        next(err);
    }
};
