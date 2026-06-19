const fs = require('fs');
const readline = require('readline');
const path = require('path');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const Candidate = require('../models/Candidate');

dotenv.config({ path: path.join(__dirname, '../../.env') });

const importCandidates = async (filePath) => {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        console.log('Connected to MongoDB for Hackathon Data Import...');

        const fileStream = fs.createReadStream(filePath);
        const rl = readline.createInterface({
            input: fileStream,
            crlfDelay: Infinity
        });

        let count = 0;
        let invalidCount = 0;

        for await (const line of rl) {
            if (!line.trim()) continue;

            try {
                const rawCandidate = JSON.parse(line);

                // Normalization & Validation
                const candidate = new Candidate({
                    candidate_id: rawCandidate.id || rawCandidate.candidate_id || `CAN_${Date.now()}_${count}`,
                    fullName: rawCandidate.name || rawCandidate.fullName,
                    email: rawCandidate.email,
                    phone: rawCandidate.phone,
                    currentRole: rawCandidate.current_role || rawCandidate.role,
                    experience_years: parseFloat(rawCandidate.experience) || 0,
                    skills: rawCandidate.skills || [],
                    normalized_skills: (rawCandidate.skills || []).map(s => s.toLowerCase().trim()),
                    career_history: rawCandidate.career_history || [],
                    education: rawCandidate.education || [],
                    platform_activity_score: rawCandidate.platform_activity || rawCandidate.signals?.activity || 0,
                    behavioral_signal_score: rawCandidate.behavioral_score || rawCandidate.signals?.behavioral || 0,
                    raw_data: rawCandidate
                });

                await Candidate.findOneAndUpdate(
                    { candidate_id: candidate.candidate_id },
                    candidate.toObject(),
                    { upsert: true }
                );

                count++;
                if (count % 100 === 0) console.log(`Processed ${count} candidates...`);
            } catch (err) {
                console.error(`Error parsing candidate at line:`, err.message);
                invalidCount++;
            }
        }

        console.log('-----------------------------------------');
        console.log(`IMPORT SUMMARY:`);
        console.log(`Successfully Imported/Updated: ${count}`);
        console.log(`Invalid Records Skipped: ${invalidCount}`);
        console.log('-----------------------------------------');
        process.exit();
    } catch (err) {
        console.error('Import failed:', err);
        process.exit(1);
    }
};

const targetPath = path.join(__dirname, '../../../candidates.jsonl');
if (fs.existsSync(targetPath)) {
    importCandidates(targetPath);
} else {
    console.error('File not found:', targetPath);
}
