const Pipeline = require('../models/Pipeline');

exports.getPipelines = async (req, res, next) => {
    try {
        const filter = {};
        if (req.query.jobId) filter.jobId = req.query.jobId;

        const pipelines = await Pipeline.find(filter).populate('candidateId').populate('jobId');
        res.status(200).json({ success: true, data: pipelines });
    } catch (err) {
        next(err);
    }
};

exports.createPipelineEntry = async (req, res, next) => {
    try {
        const entry = await Pipeline.create(req.body);
        res.status(201).json({ success: true, data: entry });
    } catch (err) {
        next(err);
    }
};

exports.updatePipelineStatus = async (req, res, next) => {
    try {
        const entry = await Pipeline.findByIdAndUpdate(req.params.id, {
            status: req.body.status,
            notes: req.body.notes,
            updatedAt: Date.now()
        }, { new: true });
        res.status(200).json({ success: true, data: entry });
    } catch (err) {
        next(err);
    }
};

exports.deletePipelineEntry = async (req, res, next) => {
    try {
        await Pipeline.findByIdAndDelete(req.params.id);
        res.status(200).json({ success: true, data: {} });
    } catch (err) {
        next(err);
    }
};
