const express = require('express');
const { getJobs, getJob, createJob, updateJob, deleteJob } = require('../controllers/jobController');
const { protect } = require('../middleware/auth');
const { createJobValidator } = require('../validators/jobValidator');
const { validationResult } = require('express-validator');

const router = express.Router();

const validate = (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ success: false, errors: errors.array() });
    }
    next();
};

router.use(protect);

router.route('/')
    .get(getJobs)
    .post(createJobValidator, validate, createJob);

router.route('/:id')
    .get(getJob)
    .put(updateJob)
    .delete(deleteJob);

module.exports = router;
