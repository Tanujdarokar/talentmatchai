from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Dict, Any
from sentence_transformers import SentenceTransformer, util
import torch

app = FastAPI(title="TalentMatch AI Service")

# Load model once at startup
print("Loading all-MiniLM-L6-v2...")
model = SentenceTransformer("all-MiniLM-L6-v2")

class EmbedRequest(BaseModel):
    texts: List[str]

class SimilarityRequest(BaseModel):
    text1: str
    text2: str

class CandidateRank(BaseModel):
    id: str
    text: str

class RankRequest(BaseModel):
    job_description: str
    candidates: List[CandidateRank]

@app.post("/embed")
async def get_embeddings(request: EmbedRequest):
    embeddings = model.encode(request.texts)
    return {"embeddings": embeddings.tolist()}

@app.post("/similarity")
async def get_similarity(request: SimilarityRequest):
    embeddings = model.encode([request.text1, request.text2])
    similarity = util.cos_sim(embeddings[0], embeddings[1])
    return {"similarity": float(similarity[0][0])}

@app.post("/rank")
async def rank_candidates(request: RankRequest):
    if not request.candidates:
        return {"rankings": []}

    job_embedding = model.encode(request.job_description, convert_to_tensor=True)
    candidate_texts = [c.text for c in request.candidates]
    candidate_embeddings = model.encode(candidate_texts, convert_to_tensor=True)

    cosine_scores = util.cos_sim(job_embedding, candidate_embeddings)[0]
    
    results = []
    for i, score in enumerate(cosine_scores):
        results.append({
            "id": request.candidates[i].id,
            "semantic_score": float(score)
        })

    # Sort by semantic score descending
    results.sort(key=lambda x: x["semantic_score"], reverse=True)
    return {"rankings": results}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
