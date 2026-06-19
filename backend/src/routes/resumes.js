const express = require('express');
const { parseResume } = require('../controllers/resumeController');
const { protect } = require('../middleware/auth');
const multer = require('multer');

const router = express.Router();
const upload = multer({ dest: 'src/uploads/resumes/' });

router.use(protect);

router.post('/parse', upload.single('resume'), parseResume);

module.exports = router;
