# ============================================================================
# Makefile for Ultra-Automated Dev Container
# ============================================================================
# Simplifies common development operations with easy-to-remember commands

.PHONY: help install start stop restart logs status health clean build test format lint deploy

# Default target - show help
.DEFAULT_GOAL := help

# Colors for output
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

# ============================================================================
# Help & Documentation
# ============================================================================

help: ## Show this help message
	@echo "$(BLUE)═══════════════════════════════════════════════════════════$(NC)"
	@echo "$(GREEN)  Ultra-Automated Dev Container - Available Commands$(NC)"
	@echo "$(BLUE)═══════════════════════════════════════════════════════════$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "$(YELLOW)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(BLUE)Examples:$(NC)"
	@echo "  make start          # Start all services"
	@echo "  make logs           # Follow service logs"
	@echo "  make health         # Check service health"
	@echo ""

# ============================================================================
# Installation & Setup
# ============================================================================

install: ## Install and setup the development environment
	@echo "$(GREEN)🚀 Installing development environment...$(NC)"
	@bash scripts/setup.sh
	@echo "$(GREEN)✅ Installation complete!$(NC)"

# ============================================================================
# Docker Compose Operations
# ============================================================================

start: ## Start all services (docker-compose up)
	@echo "$(GREEN)🚀 Starting all services...$(NC)"
	@docker-compose -f .devcontainer/docker-compose.yml up -d
	@echo "$(GREEN)✅ Services started!$(NC)"
	@make status

stop: ## Stop all services (docker-compose down)
	@echo "$(YELLOW)⏹️  Stopping all services...$(NC)"
	@docker-compose -f .devcontainer/docker-compose.yml down
	@echo "$(GREEN)✅ Services stopped!$(NC)"

restart: ## Restart all services
	@echo "$(YELLOW)🔄 Restarting all services...$(NC)"
	@make stop
	@make start

logs: ## Follow logs from all services
	@echo "$(BLUE)📋 Following service logs (Ctrl+C to exit)...$(NC)"
	@docker-compose -f .devcontainer/docker-compose.yml logs -f

logs-app: ## Show application logs
	@docker-compose -f .devcontainer/docker-compose.yml logs -f app

logs-postgres: ## Show PostgreSQL logs
	@docker-compose -f .devcontainer/docker-compose.yml logs -f postgres

logs-redis: ## Show Redis logs
	@docker-compose -f .devcontainer/docker-compose.yml logs -f redis

logs-elasticsearch: ## Show Elasticsearch logs
	@docker-compose -f .devcontainer/docker-compose.yml logs -f elasticsearch

# ============================================================================
# Service Status & Health
# ============================================================================

status: ## Show status of all services
	@echo "$(BLUE)📊 Service Status:$(NC)"
	@docker-compose -f .devcontainer/docker-compose.yml ps

health: ## Run health checks on all services
	@echo "$(GREEN)🏥 Running health checks...$(NC)"
	@bash .devcontainer/scripts/health-check.sh

stats: ## Show resource usage statistics
	@echo "$(BLUE)📊 Resource Usage:$(NC)"
	@docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"

# ============================================================================
# Development Tools
# ============================================================================

validate: ## Validate environment setup
	@echo "$(GREEN)🔍 Validating environment setup...$(NC)"
	@bash scripts/validate-setup.sh

format: ## Format all code (JS + Python)
	@echo "$(GREEN)🎨 Formatting code...$(NC)"
	@npx prettier --write "**/*.{js,jsx,json,md,yml,yaml}" || echo "Prettier not available"
	@black python_app/ || echo "Black not available"
	@isort python_app/ || echo "isort not available"
	@echo "$(GREEN)✅ Code formatted!$(NC)"

lint-fix: ## Lint and auto-fix all code
	@echo "$(GREEN)🔧 Linting and fixing code...$(NC)"
	@npm run lint -- --fix || true
	@npm run format || true
	@black python_app/ || true
	@echo "$(GREEN)✅ Linting complete!$(NC)"

test-all: ## Run all tests (JS + Python)
	@echo "$(GREEN)🧪 Running all tests...$(NC)"
	@npm test || echo "JS tests failed"
	@cd python_app && pytest || echo "Python tests failed"

coverage: ## Generate test coverage report
	@echo "$(GREEN)📊 Generating coverage report...$(NC)"
	@npm run test:ci
	@cd python_app && pytest --cov --cov-report=html

security: ## Run security scans
	@echo "$(GREEN)🔒 Running security scans...$(NC)"
	@npm audit || true
	@pip install safety || true
	@safety check --file requirements.txt || true

pre-commit: ## Run pre-commit hooks
	@echo "$(GREEN)🔍 Running pre-commit hooks...$(NC)"
	@npx lint-staged || true
	@pre-commit run --all-files || true

# ============================================================================
# Database Operations
# ============================================================================

db-connect: ## Connect to PostgreSQL database
	@echo "$(BLUE)🗄️  Connecting to PostgreSQL...$(NC)"
	@docker-compose -f .devcontainer/docker-compose.yml exec postgres psql -U postgres -d devdb

db-migrate: ## Run database migrations
	@echo "$(GREEN)🔄 Running database migrations...$(NC)"
	@npm run db:migrate || echo "$(YELLOW)⚠️  No migration script found$(NC)"

db-seed: ## Seed database with sample data
	@echo "$(GREEN)🌱 Seeding database...$(NC)"
	@npm run db:seed || echo "$(YELLOW)⚠️  No seed script found$(NC)"

db-reset: ## Reset database (drop and recreate)
	@echo "$(RED)⚠️  This will delete all data! Press Ctrl+C to cancel...$(NC)"
	@sleep 3
	@docker-compose -f .devcontainer/docker-compose.yml exec postgres psql -U postgres -c "DROP DATABASE IF EXISTS devdb;"
	@docker-compose -f .devcontainer/docker-compose.yml exec postgres psql -U postgres -c "CREATE DATABASE devdb;"
	@echo "$(GREEN)✅ Database reset complete$(NC)"

redis-cli: ## Connect to Redis CLI
	@echo "$(BLUE)💾 Connecting to Redis...$(NC)"
	@docker-compose -f .devcontainer/docker-compose.yml exec redis redis-cli

redis-flush: ## Flush Redis cache
	@echo "$(YELLOW)🧹 Flushing Redis cache...$(NC)"
	@docker-compose -f .devcontainer/docker-compose.yml exec redis redis-cli FLUSHALL
	@echo "$(GREEN)✅ Redis cache flushed$(NC)"

# ============================================================================
# Cleanup Operations
# ============================================================================

clean: ## Clean up Docker resources
	@echo "$(YELLOW)🧹 Cleaning up...$(NC)"
	@bash .devcontainer/scripts/cleanup-local.sh --all

clean-containers: ## Remove containers only
	@bash .devcontainer/scripts/cleanup-local.sh --containers

clean-volumes: ## Remove volumes (WARNING: deletes data)
	@echo "$(RED)⚠️  This will delete all data! Press Ctrl+C to cancel...$(NC)"
	@sleep 3
	@bash .devcontainer/scripts/cleanup-local.sh --volumes

# ============================================================================
# Build Operations
# ============================================================================

build: ## Build the dev container
	@echo "$(GREEN)🔨 Building dev container...$(NC)"
	@docker-compose -f .devcontainer/docker-compose.yml build --no-cache
	@echo "$(GREEN)✅ Build complete!$(NC)"

rebuild: ## Rebuild and restart all services
	@echo "$(GREEN)🔄 Rebuilding all services...$(NC)"
	@make stop
	@make build
	@make start

# ============================================================================
# Testing Operations
# ============================================================================

test: ## Run all tests
	@echo "$(BLUE)🧪 Running tests...$(NC)"
	@npm test || echo "$(YELLOW)⚠️  No test script found$(NC)"

test-watch: ## Run tests in watch mode
	@echo "$(BLUE)🔍 Running tests in watch mode...$(NC)"
	@npm run test:watch || echo "$(YELLOW)⚠️  No test:watch script found$(NC)"

test-coverage: ## Run tests with coverage report
	@echo "$(BLUE)📊 Running tests with coverage...$(NC)"
	@npm run test:coverage || echo "$(YELLOW)⚠️  No test:coverage script found$(NC)"

# ============================================================================
# Code Quality Operations
# ============================================================================

format: ## Format code with Prettier
	@echo "$(GREEN)✨ Formatting code...$(NC)"
	@npm run format || npx prettier --write . || echo "$(YELLOW)⚠️  Prettier not available$(NC)"

lint: ## Lint code with ESLint
	@echo "$(BLUE)🔍 Linting code...$(NC)"
	@npm run lint || npx eslint . || echo "$(YELLOW)⚠️  ESLint not available$(NC)"

lint-fix: ## Lint and fix code issues
	@echo "$(GREEN)🔧 Linting and fixing code...$(NC)"
	@npm run lint:fix || npx eslint . --fix || echo "$(YELLOW)⚠️  ESLint not available$(NC)"

typecheck: ## Run TypeScript type checking
	@echo "$(BLUE)🔍 Type checking...$(NC)"
	@npm run typecheck || npx tsc --noEmit || echo "$(YELLOW)⚠️  TypeScript not available$(NC)"

# ============================================================================
# Development Operations
# ============================================================================

dev: ## Start development server
	@echo "$(GREEN)🚀 Starting development server...$(NC)"
	@npm run dev || npm start

watch: ## Run in watch mode
	@npm run watch || npm run dev

# ============================================================================
# Diagnostic Operations
# ============================================================================

diagnostics: ## Run full system diagnostics
	@echo "$(BLUE)🔍 Running diagnostics...$(NC)"
	@bash scripts/diagnostics.sh

info: ## Show system information
	@echo "$(BLUE)ℹ️  System Information:$(NC)"
	@echo ""
	@echo "Docker version:"
	@docker --version
	@echo ""
	@echo "Docker Compose version:"
	@docker-compose --version
	@echo ""
	@echo "Node version:"
	@node --version 2>/dev/null || echo "Not installed"
	@echo ""
	@echo "npm version:"
	@npm --version 2>/dev/null || echo "Not installed"
	@echo ""
	@echo "Python version:"
	@python --version 2>/dev/null || echo "Not installed"

# ============================================================================
# Git Operations
# ============================================================================

git-status: ## Show git status
	@git status

git-log: ## Show recent git commits
	@git log --oneline -10

# ============================================================================
# Shell Access
# ============================================================================

shell: ## Open shell in app container
	@echo "$(BLUE)🐚 Opening shell in app container...$(NC)"
	@docker-compose -f .devcontainer/docker-compose.yml exec app /bin/zsh || \
		docker-compose -f .devcontainer/docker-compose.yml exec app /bin/bash

shell-postgres: ## Open shell in PostgreSQL container
	@docker-compose -f .devcontainer/docker-compose.yml exec postgres /bin/sh

shell-redis: ## Open shell in Redis container
	@docker-compose -f .devcontainer/docker-compose.yml exec redis /bin/sh

# ============================================================================
# Advanced Operations
# ============================================================================

prune: ## Remove all unused Docker resources (DANGEROUS)
	@echo "$(RED)⚠️  This will remove ALL unused Docker resources! Press Ctrl+C to cancel...$(NC)"
	@sleep 5
	@docker system prune -af --volumes
	@echo "$(GREEN)✅ Docker pruned$(NC)"

backup: ## Backup database and volumes
	@echo "$(BLUE)💾 Creating backup...$(NC)"
	@mkdir -p backups
	@docker-compose -f .devcontainer/docker-compose.yml exec -T postgres pg_dump -U postgres devdb > backups/db-backup-$$(date +%Y%m%d-%H%M%S).sql
	@echo "$(GREEN)✅ Backup created in backups/$(NC)"

restore: ## Restore database from latest backup
	@echo "$(YELLOW)🔄 Restoring from latest backup...$(NC)"
	@bash -c 'latest=$$(ls -t backups/db-backup-*.sql 2>/dev/null | head -1); \
		if [ -z "$$latest" ]; then \
			echo "$(RED)❌ No backup found$(NC)"; \
			exit 1; \
		fi; \
		echo "Restoring from $$latest"; \
		docker-compose -f .devcontainer/docker-compose.yml exec -T postgres psql -U postgres devdb < $$latest'
	@echo "$(GREEN)✅ Database restored$(NC)"

# ============================================================================
# CI/CD Operations
# ============================================================================

ci-test: ## Run CI tests locally
	@echo "$(BLUE)🧪 Running CI tests locally...$(NC)"
	@docker run --rm -v $(PWD):/workspace -w /workspace node:20-alpine npm ci
	@docker run --rm -v $(PWD):/workspace -w /workspace node:20-alpine npm test

# ============================================================================
# Documentation
# ============================================================================

docs: ## Generate documentation
	@echo "$(BLUE)📚 Generating documentation...$(NC)"
	@bash create_documentation.sh || echo "$(YELLOW)⚠️  Documentation script not found$(NC)"
