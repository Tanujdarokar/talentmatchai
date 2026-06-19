const { body } = require('express-validator');

exports.createJobValidator = [
    body('title').notEmpty().withMessage('Job title is required'),
    body('department').notEmpty().withMessage('Department is required'),
    body('employmentType').notEmpty().withMessage('Employment type is required'),
    body('experienceRequired').isNumeric().withMessage('Experience required must be a number')
];
