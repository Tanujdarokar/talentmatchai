const Note = require('../models/Note');

exports.getNotes = async (req, res, next) => {
    try {
        const notes = await Note.find({ candidateId: req.query.candidateId }).populate('recruiterId');
        res.status(200).json({ success: true, data: notes });
    } catch (err) {
        next(err);
    }
};

exports.addNote = async (req, res, next) => {
    try {
        req.body.recruiterId = req.user.id;
        const note = await Note.create(req.body);
        res.status(201).json({ success: true, data: note });
    } catch (err) {
        next(err);
    }
};

exports.updateNote = async (req, res, next) => {
    try {
        const note = await Note.findByIdAndUpdate(req.params.id, req.body, { new: true });
        res.status(200).json({ success: true, data: note });
    } catch (err) {
        next(err);
    }
};

exports.deleteNote = async (req, res, next) => {
    try {
        await Note.findByIdAndDelete(req.params.id);
        res.status(200).json({ success: true, data: {} });
    } catch (err) {
        next(err);
    }
};
