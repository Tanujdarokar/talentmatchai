const Candidate = require('../models/Candidate');
const Ranking = require('../models/Ranking');
const fs = require('fs');
const path = require('path');

exports.exportRankingsCsv = async (req, res, next) => {
    try {
        const rankings = await Ranking.find().populate('jobId').populate('rankedCandidates.candidateId');

        let csvContent = "Rank,Candidate Name,Job Title,Final Score,Recommendation\n";

        rankings.forEach(ranking => {
            ranking.rankedCandidates.forEach((rc, index) => {
                csvContent += `${index + 1},${rc.candidateId?.fullName},${ranking.jobId?.title},${rc.finalScore},"${rc.recommendation}"\n`;
            });
        });

        const filePath = path.join(__dirname, '../exports/rankings.csv');
        fs.writeFileSync(filePath, csvContent);

        res.download(filePath);
    } catch (err) {
        next(err);
    }
};

exports.exportCandidatesCsv = async (req, res, next) => {
    try {
        const candidates = await Candidate.find();
        let csvContent = "FullName,Email,Role,Experience,Skills\n";

        candidates.forEach(c => {
            csvContent += `${c.fullName},${c.email},${c.currentRole},${c.experience},"${c.skills.join(', ')}"\n`;
        });

        const filePath = path.join(__dirname, '../exports/candidates.csv');
        fs.writeFileSync(filePath, csvContent);

        res.download(filePath);
    } catch (err) {
        next(err);
    }
};

exports.exportRankingsJson = async (req, res, next) => {
    try {
        const rankings = await Ranking.find().populate('jobId').populate('rankedCandidates.candidateId');
        res.status(200).json({ success: true, data: rankings });
    } catch (err) {
        next(err);
    }
};
