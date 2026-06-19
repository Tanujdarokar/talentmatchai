const axios = require('axios');
const Candidate = require('../models/Candidate');
const Job = require('../models/Job');

const AI_SERVICE_URL = "http://localhost:8000";
const GROQ_API_KEY = process.env.GROQ_API_KEY; // Optional: Use local if no key

const generateAIEvaluation = async (candidate, job) => {
    try {
        if (!GROQ_API_KEY) return null;

        const prompt = `Evaluate candidate ${candidate.fullName} for role ${job.title}.
        Skills: ${candidate.skills.join(', ')}
        Experience: ${candidate.experience_years} years
        Job Requirements: ${job.required_skills.join(', ')}

        Provide a JSON response with:
        1. recommendation_summary (string)
        2. strengths (list)
        3. risks (list)
        4. missing_skills (list)`;

        const response = await axios.post("https://api.groq.com/openai/v1/chat/completions", {
            model: "llama3-70b-8192",
            messages: [{ role: "user", content: prompt }],
            response_format: { type: "json_object" }
        }, {
            headers: { Authorization: `Bearer ${GROQ_API_KEY}` }
        });

        return JSON.parse(response.data.choices[0].message.content);
    } catch (err) {
        console.error("LLM Evaluation failed:", err.message);
        return null;
    }
};

const calculateHybridScore = (semanticScore, candidate, job) => {
    // ... same as before
    // 1. Semantic Similarity (40%)
    const sScore = semanticScore * 40;

    // 2. Experience Match (25%)
    // Assume job has experience_required_min
    let eScore = 0;
    const expYears = candidate.experience_years || 0;
    const reqYears = job.experience_required_min || 0;
    if (expYears >= reqYears) {
        eScore = 25;
    } else {
        eScore = (expYears / reqYears) * 25;
    }

    // 3. Skill Match (15%)
    let skillMatchCount = 0;
    const jobSkills = (job.required_skills || []).map(s => s.toLowerCase());
    const candSkills = (candidate.normalized_skills || []);

    jobSkills.forEach(skill => {
        if (candSkills.includes(skill)) skillMatchCount++;
    });

    const skScore = jobSkills.length > 0 ? (skillMatchCount / jobSkills.length) * 15 : 15;

    // 4. Behavioral Signals (10%)
    const bScore = (candidate.behavioral_signal_score / 100) * 10;

    // 5. Platform Activity (10%)
    const pScore = (candidate.platform_activity_score / 100) * 10;

    return {
        finalScore: (sScore + eScore + skScore + bScore + pScore).toFixed(2),
        breakdown: {
            semantic: sScore.toFixed(2),
            experience: eScore.toFixed(2),
            skills: skScore.toFixed(2),
            behavioral: bScore.toFixed(2),
            activity: pScore.toFixed(2)
        }
    };
};

exports.rankTalentPool = async (jobId) => {
    const job = await Job.findById(jobId);
    if (!job) throw new Error("Job not found");

    const candidates = await Candidate.find().limit(500); // Process large batch

    // Prepare data for semantic ranking
    const aiPayload = {
        job_description: `${job.title} ${job.description} ${job.required_skills.join(' ')}`,
        candidates: candidates.map(c => ({
            id: c._id.toString(),
            text: `${c.currentRole} ${c.skills.join(' ')} ${c.resume_text || ''}`
        }))
    };

    // Call Python Service
    const aiResponse = await axios.post(`${AI_SERVICE_URL}/rank`, aiPayload);
    const semanticRankings = aiResponse.data.rankings;

    // Merge & Calculate Hybrid Scores
    const finalRankings = semanticRankings.map(sr => {
        const candidate = candidates.find(c => c._id.toString() === sr.id);
        const hybrid = calculateHybridScore(sr.semantic_score, candidate, job);

        return {
            candidate: candidate,
            score: hybrid.finalScore,
            breakdown: hybrid.breakdown
        };
    });

    // Sort by Final Score
    finalRankings.sort((a, b) => b.score - a.score);

    return finalRankings;
};
