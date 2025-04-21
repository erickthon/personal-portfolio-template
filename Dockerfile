# === STAGE 1: Build React Frontend ===
FROM node:23-slim AS frontend-builder

WORKDIR /app/frontend

COPY frontend/package*.json ./
RUN npm install

COPY frontend/ ./
RUN npm run build

# === STAGE 2: Backend + Frontend ===
FROM python:alpine AS final

WORKDIR /app

# Install backend deps
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend app
COPY backend/ ./backend

# Copy built frontend files
COPY --from=frontend-builder /app/frontend/dist ./frontend-dist

# Optionally re-install FastAPI deps (skip if already in requirements.txt)
RUN pip install fastapi uvicorn python-multipart

# Serve frontend
COPY backend/main.py ./backend/main.py

CMD ["uvicorn", "backend.main:app", "--host", "0.0.0.0", "--port", "8000"]