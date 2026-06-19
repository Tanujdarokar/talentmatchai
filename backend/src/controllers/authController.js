const jwt = require('jsonwebtoken');
const Recruiter = require('../models/Recruiter');

// @desc    Register recruiter
// @route   POST /api/auth/register
exports.register = async (req, res, next) => {
    try {
        const { fullName, email, company, password } = req.body;

        const recruiter = await Recruiter.create({
            fullName,
            email,
            company,
            password
        });

        sendTokenResponse(recruiter, 201, res);
    } catch (err) {
        next(err);
    }
};

// @desc    Login recruiter
// @route   POST /api/auth/login
exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({ success: false, message: 'Please provide an email and password' });
        }

        const recruiter = await Recruiter.findOne({ email }).select('+password');

        if (!recruiter) {
            return res.status(401).json({ success: false, message: 'Invalid credentials' });
        }

        const isMatch = await recruiter.matchPassword(password);

        if (!isMatch) {
            return res.status(401).json({ success: false, message: 'Invalid credentials' });
        }

        sendTokenResponse(recruiter, 200, res);
    } catch (err) {
        next(err);
    }
};

// @desc    Get current logged in recruiter
// @route   GET /api/auth/profile
exports.getMe = async (req, res, next) => {
    try {
        const recruiter = await Recruiter.findById(req.user.id);
        res.status(200).json({ success: true, data: recruiter });
    } catch (err) {
        next(err);
    }
};

// @desc    Update recruiter profile
// @route   PUT /api/auth/profile
exports.updateProfile = async (req, res, next) => {
    try {
        const fieldsToUpdate = {
            fullName: req.body.fullName,
            company: req.body.company
        };

        const recruiter = await Recruiter.findByIdAndUpdate(req.user.id, fieldsToUpdate, {
            new: true,
            runValidators: true
        });

        res.status(200).json({ success: true, data: recruiter });
    } catch (err) {
        next(err);
    }
};

// @desc    Update password
// @route   PUT /api/auth/change-password
exports.updatePassword = async (req, res, next) => {
    try {
        const recruiter = await Recruiter.findById(req.user.id).select('+password');

        // Check current password
        if (!(await recruiter.matchPassword(req.body.currentPassword))) {
            return res.status(401).json({ success: false, message: 'Password is incorrect' });
        }

        recruiter.password = req.body.newPassword;
        await recruiter.save();

        sendTokenResponse(recruiter, 200, res);
    } catch (err) {
        next(err);
    }
};

// Get token from model, create cookie and send response
const sendTokenResponse = (recruiter, statusCode, res) => {
    const token = jwt.sign({ id: recruiter._id }, process.env.JWT_SECRET, {
        expiresIn: process.env.JWT_EXPIRE
    });

    res.status(statusCode).json({
        success: true,
        token
    });
};
