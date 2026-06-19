const mongoose = require('mongoose');
const dotenv = require('dotenv');
const xlsx = require('xlsx');
const path = require('path');
const Job = require('../models/Job');
const Candidate = require('../models/Candidate');
const Recruiter = require('../models/Recruiter');

dotenv.config({ path: path.join(__dirname, '../../.env') });

const jobTitles = [
  'Senior Flutter Developer', 'Full Stack Engineer', 'Backend Lead', 'Data Scientist',
  'UI/UX Designer', 'DevOps Specialist', 'Product Manager', 'Mobile Architect',
  'Frontend Developer', 'Cloud Security Engineer', 'Project Coordinator', 'QA Automation Lead',
  'Machine Learning Engineer', 'Systems Analyst', 'HR Manager', 'Sales Director'
];

const departments = ['Engineering', 'Product', 'Design', 'Marketing', 'Sales', 'Human Resources', 'Operations'];

const skillsPool = [
  'Flutter', 'Dart', 'Node.js', 'React', 'MongoDB', 'PostgreSQL', 'AWS', 'Docker', 'Kubernetes',
  'Python', 'Machine Learning', 'TensorFlow', 'Figma', 'TypeScript', 'Java', 'Kotlin', 'Swift',
  'Go', 'Redux', 'GraphQL', 'Firebase', 'Azure', 'GCP', 'Jenkins', 'Terraform', 'Agile'
];

const getRandom = (arr) => arr[Math.floor(Math.random() * arr.length)];
const getRandomInt = (min, max) => Math.floor(Math.random() * (max - min + 1)) + min;

const importData = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        console.log('Connected to MongoDB for bulk seeding...');

        let recruiter = await Recruiter.findOne({ email: 'admin@talentmatch.ai' });
        if (!recruiter) {
            recruiter = await Recruiter.create({
                fullName: 'System Admin',
                email: 'admin@talentmatch.ai',
                company: 'TalentMatch AI Global',
                password: 'password123',
            });
        }

        await Job.deleteMany();
        await Candidate.deleteMany();

        try {
            const filePath = path.join(__dirname, '../../../dataset/TalentMatch_AI_Production_Mock_Dataset.xlsx');
            const workbook = xlsx.readFile(filePath);

            // Jobs Data - aligned with Job.js model
            const jobsSheet = workbook.Sheets['Jobs Data'];
            if (jobsSheet) {
                const jobsData = xlsx.utils.sheet_to_json(jobsSheet, { range: 2 });
                const jobsToInsert = jobsData.map(row => ({
                    title: row['Title'],
                    department: row['Department'],
                    employmentType: row['Employment Type'] || 'Full-time',
                    experience_required_min: parseInt(row['Experience Required (Yrs)']) || 0,
                    required_skills: row['Required Skills'] ? row['Required Skills'].split(',').map(s => s.trim()) : [],
                    preferred_skills: row['Preferred Skills'] ? row['Preferred Skills'].split(',').map(s => s.trim()) : [],
                    status: row['Status'] || 'Open',
                    createdBy: recruiter._id,
                    description: `Role in ${row['Department']} department at ${row['Location']}.`
                })).filter(j => j.title);
                await Job.insertMany(jobsToInsert);
                console.log(`✓ Imported ${jobsToInsert.length} jobs from Excel.`);
            }

            // Candidates Data - aligned with Candidate.js model
            const candidatesSheet = workbook.Sheets['Candidates Data'];
            if (candidatesSheet) {
                const candidatesData = xlsx.utils.sheet_to_json(candidatesSheet, { range: 2 });
                const candidatesToInsert = candidatesData.map(row => ({
                    candidate_id: row['Candidate ID'] || `EXCEL_${Math.random().toString(36).substr(2, 9)}`,
                    fullName: row['Full Name'],
                    email: row['Email'],
                    phone: row['Phone']?.toString(),
                    currentRole: row['Current Role'],
                    experience_years: parseInt(row['Experience (Yrs)']) || 0,
                    skills: row['Skills'] ? row['Skills'].split(',').map(s => s.trim()) : [],
                    normalized_skills: row['Skills'] ? row['Skills'].split(',').map(s => s.toLowerCase().trim()) : [],
                    education: row['Education'] ? [{ degree: row['Education'] }] : [],
                    platform_activity_score: parseInt(row['Platform Activity']) || getRandomInt(40, 95),
                    behavioral_signal_score: parseInt(row['Behavioral Score']) || getRandomInt(50, 98)
                })).filter(c => c.fullName && c.email);
                await Candidate.insertMany(candidatesToInsert);
                console.log(`✓ Imported ${candidatesToInsert.length} candidates from Excel.`);
            }
        } catch (e) {
            console.log('Excel import issue:', e.message);
        }

        // Generate Synthetic Data
        console.log('Generating additional synthetic data...');
        const synthJobs = [];
        for (let i = 0; i < 20; i++) {
            synthJobs.push({
                title: `${getRandom(jobTitles)}`,
                department: getRandom(departments),
                employmentType: getRandom(['Full-time', 'Remote', 'Contract']),
                experience_required_min: getRandomInt(1, 10),
                required_skills: [getRandom(skillsPool), getRandom(skillsPool)],
                preferred_skills: [getRandom(skillsPool)],
                status: 'Open',
                createdBy: recruiter._id,
                description: 'AI-generated description for recruitment testing.'
            });
        }
        await Job.insertMany(synthJobs);

        const synthCandidates = [];
        for (let i = 0; i < 100; i++) {
            const fname = getRandom(firstNames);
            const lname = getRandom(lastNames);
            synthCandidates.push({
                candidate_id: `SYNTH_${i}`,
                fullName: `${fname} ${lname}`,
                email: `${fname.toLowerCase()}.${lname.toLowerCase()}${i}@talentai.test`,
                phone: `+91 ${getRandomInt(7000000000, 9999999999)}`,
                currentRole: getRandom(jobTitles),
                experience_years: getRandomInt(0, 12),
                skills: [getRandom(skillsPool), getRandom(skillsPool), getRandom(skillsPool)],
                normalized_skills: [], // Calculated in model if needed or manually here
                platform_activity_score: getRandomInt(20, 100),
                behavioral_signal_score: getRandomInt(30, 100)
            });
        }
        // Fix for missing names arrays in scope if needed, or just use hardcoded
        await Candidate.insertMany(synthCandidates);

        console.log('Import & Generation Complete!');
        process.exit();
    } catch (error) {
        console.error('Error:', error);
        process.exit(1);
    }
};

const firstNames = ['Amit', 'Priya', 'Rahul', 'Sneha', 'Vikram', 'Anjali', 'Deepak', 'Meera'];
const lastNames = ['Sharma', 'Verma', 'Gupta', 'Singh', 'Patel', 'Reddy'];

importData();
