from collections.abc import AsyncIterator

from fastapi.testclient import TestClient
from sqlalchemy.exc import SQLAlchemyError

from app.db.session import get_db
from app.main import app


class HealthySession:
    async def execute(self, _: object) -> None:
        return None


class UnhealthySession:
    async def execute(self, _: object) -> None:
        raise SQLAlchemyError("Database is offline")


async def override_db() -> AsyncIterator[HealthySession]:
    yield HealthySession()


async def override_unhealthy_db() -> AsyncIterator[UnhealthySession]:
    yield UnhealthySession()


def test_health_reports_api_and_database_ready() -> None:
    app.dependency_overrides[get_db] = override_db

    try:
        with TestClient(app) as client:
            response = client.get("/health")
    finally:
        app.dependency_overrides.clear()

    assert response.status_code == 200
    assert response.json() == {"status": "ok", "database": "ok"}


def test_health_reports_database_failure() -> None:
    app.dependency_overrides[get_db] = override_unhealthy_db

    try:
        with TestClient(app) as client:
            response = client.get("/health")
    finally:
        app.dependency_overrides.clear()

    assert response.status_code == 503
    assert response.json() == {"detail": "Database unavailable"}
