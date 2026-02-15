"""
Ultra-Automated DevContainer Framework
Sample Python FastAPI Application
"""

import os
from datetime import datetime
from typing import Dict, Any

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.gzip import GZipMiddleware
from pydantic import BaseModel
import uvicorn

# Initialize FastAPI app
app = FastAPI(
    title="Ultra-Automated DevContainer Framework",
    description="Sample Python application for CI/CD framework",
    version="1.1.1",
)

# Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.add_middleware(GZipMiddleware, minimum_size=1000)


class EchoRequest(BaseModel):
    """Echo request model"""

    message: str


@app.get("/")
async def root() -> Dict[str, Any]:
    """Root endpoint"""
    return {
        "name": "Ultra-Automated DevContainer Framework (Python)",
        "version": "1.1.1",
        "status": "running",
        "environment": os.getenv("NODE_ENV", "development"),
        "timestamp": datetime.utcnow().isoformat(),
    }


@app.get("/health")
async def health() -> Dict[str, Any]:
    """Health check endpoint"""
    return {
        "status": "healthy",
        "timestamp": datetime.utcnow().isoformat(),
    }


@app.get("/api/version")
async def version() -> Dict[str, Any]:
    """API version endpoint"""
    return {
        "version": "1.1.1",
        "apiVersion": "v1",
        "buildDate": datetime.utcnow().isoformat(),
        "pythonVersion": os.sys.version,
    }


@app.post("/api/echo")
async def echo(request: EchoRequest) -> Dict[str, Any]:
    """Echo endpoint"""
    return {
        "received": request.dict(),
        "timestamp": datetime.utcnow().isoformat(),
    }


if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=int(os.getenv("PORT", 8000)),
        reload=True,
        log_level="info",
    )
