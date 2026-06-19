const express = require('express');
const { getCandidates, getCandidate, createCandidate, updateCandidate, deleteCandidate, uploadResume, importCsv, aiSearch } = require('../controllers/candidateController');
const { protect } = require('../middleware/auth');
const multer = require('multer');
const path = require('path');

const router = express.Router();

// Multer Config
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'src/uploads/resumes/');
    },
    filename: (req, file, cb) => {
        cb(null, `${file.fieldname}-${Date.now()}${path.extname(file.originalname)}`);
    }
});

const upload = multer({ storage });

router.use(protect);

router.post('/ai-search', aiSearch);
router.post('/upload-resume', upload.single('resume'), uploadResume);
router.post('/import-csv', upload.single('csv'), importCsv);

router.route('/')
    .get(getCandidates)
    .post(createCandidate);

router.route('/:id')
    .get(getCandidate)
    .put(updateCandidate)
    .delete(deleteCandidate);

module.exports = router;
