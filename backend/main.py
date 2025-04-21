from fastapi import FastAPI
from fastapi.responses import FileResponse
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.gzip import GZipMiddleware
from fastapi.staticfiles import StaticFiles
import os
import json

app = FastAPI()

# === Middleware ===
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In prod, restrict to your frontend domain
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.add_middleware(GZipMiddleware, minimum_size=1000)

# === Paths ===
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECTS_PATH = os.path.join(BASE_DIR, "data", "projects.json")
RESUME_PATH = os.path.join(BASE_DIR, "static", "sample_resume.pdf")
FRONTEND_PATH = os.path.join(BASE_DIR, "..", "frontend-dist")

# === API Routes ===

@app.get("/api/projects")
def get_projects():
    path = os.path.join(os.path.dirname(__file__), "data", "projects.json")
    with open(path) as f:
        return json.load(f)


@app.get("/api/resume", response_class=FileResponse)
def get_resume():
    if not os.path.exists(RESUME_PATH):
        return {"error": "resume.pdf not found"}
    return FileResponse(
        RESUME_PATH,
        media_type='application/pdf',
        filename="sample_resume.pdf"
    )

# === Serve React frontend ===
app.mount("/", StaticFiles(directory=FRONTEND_PATH, html=True), name="frontend")
