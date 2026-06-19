const Candidate = require('../models/Candidate');
const csv = require('csv-parser');
const fs = require('fs');
const path = require('path');
const axios = require('axios');

const AI_SERVICE_URL = "http://localhost:8000";

exports.aiSearch = async (req, res, next) => {
    try {
        const { query } = req.body;
        if (!query) return res.status(400).json({ success: false, message: 'Query is required' });

        const candidates = await Candidate.find().limit(200); // Analyze a decent pool

        const aiPayload = {
            job_description: query,
            candidates: candidates.map(c => ({
                id: c._id.toString(),
                text: `${c.fullName} ${c.currentRole} ${c.skills.join(' ')} ${c.experience_years} years experience`
            }))
        };

        const aiResponse = await axios.post(`${AI_SERVICE_URL}/rank`, aiPayload);
        const rankings = aiResponse.data.rankings;

        // Map back to candidate objects with scores
        const results = rankings.map(r => {
            const candidate = candidates.find(c => c._id.toString() === r.id);
            return {
                ...candidate.toObject(),
                matchScore: (r.semantic_score * 100).toFixed(2)
            };
        });

        res.status(200).json({ success: true, data: results });
    } catch (err) {
        next(err);
    }
};

exports.getCandidates = async (req, res, next) => {
    try {
        let query;
        const reqQuery = { ...req.query };
        const removeFields = ['select', 'sort', 'page', 'limit', 'search'];
        removeFields.forEach(param => delete reqQuery[param]);

        let queryStr = JSON.stringify(reqQuery);
        queryStr = queryStr.replace(/\b(gt|gte|lt|lte|in)\b/g, match => `$${match}`);

        let finalQuery = JSON.parse(queryStr);

        if (req.query.search) {
            finalQuery.fullName = { $regex: req.query.search, $options: 'i' };
        }

        query = Candidate.find(finalQuery);

        if (req.query.select) {
            const fields = req.query.select.split(',').join(' ');
            query = query.select(fields);
        }

        if (req.query.sort) {
            const sortBy = req.query.sort.split(',').join(' ');
            query = query.sort(sortBy);
        } else {
            query = query.sort('-createdAt');
        }

        const page = parseInt(req.query.page, 10) || 1;
        const limit = parseInt(req.query.limit, 10) || 10;
        const startIndex = (page - 1) * limit;
        const total = await Candidate.countDocuments(finalQuery);

        query = query.skip(startIndex).limit(limit);

        const candidates = await query;

        res.status(200).json({
            success: true,
            count: candidates.length,
            pagination: { total, page, limit },
            data: candidates
        });
    } catch (err) {
        next(err);
    }
};

exports.getCandidate = async (req, res, next) => {
    try {
        const candidate = await Candidate.findById(req.params.id);
        if (!candidate) return res.status(404).json({ success: false, message: 'Candidate not found' });
        res.status(200).json({ success: true, data: candidate });
    } catch (err) {
        next(err);
    }
};

exports.createCandidate = async (req, res, next) => {
    try {
        const candidate = await Candidate.create(req.body);
        res.status(201).json({ success: true, data: candidate });
    } catch (err) {
        next(err);
    }
};

exports.updateCandidate = async (req, res, next) => {
    try {
        const candidate = await Candidate.findByIdAndUpdate(req.params.id, req.body, {
            new: true,
            runValidators: true
        });
        res.status(200).json({ success: true, data: candidate });
    } catch (err) {
        next(err);
    }
};

exports.deleteCandidate = async (req, res, next) => {
    try {
        await Candidate.findByIdAndDelete(req.params.id);
        res.status(200).json({ success: true, data: {} });
    } catch (err) {
        next(err);
    }
};

exports.uploadResume = async (req, res, next) => {
    try {
        if (!req.file) {
            return res.status(400).json({ success: false, message: 'Please upload a file' });
        }
        res.status(200).json({
            success: true,
            data: req.file.path
        });
    } catch (err) {
        next(err);
    }
};

exports.importCsv = async (req, res, next) => {
    try {
        if (!req.file) {
            return res.status(400).json({ success: false, message: 'Please upload a CSV file' });
        }

        const candidates = [];
        const errors = [];
        let importedCount = 0;
        let failedCount = 0;

        fs.createReadStream(req.file.path)
            .pipe(csv())
            .on('data', (data) => candidates.push(data))
            .on('end', async () => {
                for (const candidateData of candidates) {
                    try {
                        // Basic mapping if needed, or assume headers match model
                        await Candidate.create({
                            fullName: candidateData.fullName,
                            email: candidateData.email,
                            phone: candidateData.phone,
                            currentRole: candidateData.currentRole,
                            experience: parseInt(candidateData.experience) || 0,
                            skills: candidateData.skills ? candidateData.skills.split(',') : [],
                        });
                        importedCount++;
                    } catch (err) {
                        failedCount++;
                        errors.push({ email: candidateData.email, error: err.message });
                    }
                }
                fs.unlinkSync(req.file.path); // Remove temp file
                res.status(200).json({
                    success: true,
                    importedCount,
                    failedCount,
                    errors
                });
            });
    } catch (err) {
        next(err);
    }
};
