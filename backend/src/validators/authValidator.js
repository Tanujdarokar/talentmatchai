const { body } = require('express-validator');

exports.registerValidator = [
    body('fullName').notEmpty().withMessage('Full name is required'),
    body('email').isEmail().withMessage('Please provide a valid email'),
    body('company').notEmpty().withMessage('Company name is required'),
    body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters')
];

exports.loginValidator = [
    body('email').isEmail().withMessage('Please provide a valid email'),
    body('password').notEmpty().withMessage('Password is required')
];
