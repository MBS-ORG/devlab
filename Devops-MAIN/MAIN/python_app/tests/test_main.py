"""
Tests for Python FastAPI application
"""

from fastapi.testclient import TestClient
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))
from main import app

client = TestClient(app)


def test_root():
    """Test root endpoint"""
    response = client.get("/")
    assert response.status_code == 200
    data = response.json()
    assert "name" in data
    assert "version" in data
    assert data["status"] == "running"


def test_health():
    """Test health endpoint"""
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert "timestamp" in data


def test_version():
    """Test version endpoint"""
    response = client.get("/api/version")
    assert response.status_code == 200
    data = response.json()
    assert "version" in data
    assert "apiVersion" in data


def test_echo():
    """Test echo endpoint"""
    test_message = {"message": "hello world"}
    response = client.post("/api/echo", json=test_message)
    assert response.status_code == 200
    data = response.json()
    assert data["received"] == test_message
    assert "timestamp" in data
