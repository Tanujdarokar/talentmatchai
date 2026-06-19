const pdf = require('pdf-parse');
const mammoth = require('mammoth');
const fs = require('fs');
const path = require('path');

exports.parseResume = async (req, res, next) => {
    try {
        if (!req.file) {
            return res.status(400).json({ success: false, message: 'Please upload a file' });
        }

        const filePath = req.file.path;
        const extension = path.extname(filePath).toLowerCase();
        let extractedText = "";

        if (extension === '.pdf') {
            const dataBuffer = fs.readFileSync(filePath);
            const data = await pdf(dataBuffer);
            extractedText = data.text;
        } else if (extension === '.docx') {
            const data = await mammoth.extractRawText({ path: filePath });
            extractedText = data.value;
        } else {
            return res.status(400).json({ success: false, message: 'Unsupported file format' });
        }

        res.status(200).json({
            success: true,
            text: extractedText
        });
    } catch (err) {
        next(err);
    }
};
