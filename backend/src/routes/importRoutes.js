const express = require('express');
const router = express.Router();
const path = require('path');
const { protect } = require('../middleware/auth');
const { spawn } = require('child_process');

// @desc    Trigger candidate import from JSONL
// @route   POST /api/import/candidates
router.post('/candidates', protect, (req, res) => {
    const importProcess = spawn('node', [path.join(__dirname, '../utils/importHackathonData.js')]);

    importProcess.stdout.on('data', (data) => console.log(`stdout: ${data}`));
    importProcess.stderr.on('data', (data) => console.error(`stderr: ${data}`));

    res.status(202).json({ success: true, message: 'Import started in background' });
});

module.exports = router;
