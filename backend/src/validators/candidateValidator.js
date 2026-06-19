const { body } = require('express-validator');

exports.createCandidateValidator = [
    body('fullName').notEmpty().withMessage('Full name is required'),
    body('email').isEmail().withMessage('Please provide a valid email'),
    body('currentRole').notEmpty().withMessage('Current role is required'),
    body('experience').isNumeric().withMessage('Experience must be a number')
];
