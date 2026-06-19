const Bookmark = require('../models/Bookmark');

exports.getBookmarks = async (req, res, next) => {
    try {
        const bookmarks = await Bookmark.find({ recruiterId: req.user.id }).populate('candidateId');
        res.status(200).json({ success: true, data: bookmarks });
    } catch (err) {
        next(err);
    }
};

exports.addBookmark = async (req, res, next) => {
    try {
        req.body.recruiterId = req.user.id;
        const bookmark = await Bookmark.create(req.body);
        res.status(201).json({ success: true, data: bookmark });
    } catch (err) {
        next(err);
    }
};

exports.removeBookmark = async (req, res, next) => {
    try {
        await Bookmark.findByIdAndDelete(req.params.id);
        res.status(200).json({ success: true, data: {} });
    } catch (err) {
        next(err);
    }
};
