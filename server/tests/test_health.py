from collections.abc import AsyncIterator

import httpx
import pytest
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


@pytest.mark.asyncio
async def test_health_reports_api_and_database_ready() -> None:
    app.dependency_overrides[get_db] = override_db

    try:
        async with httpx.AsyncClient(
            transport=httpx.ASGITransport(app=app),
            base_url="http://test",
        ) as client:
            response = await client.get("/health")
    finally:
        app.dependency_overrides.clear()

    assert response.status_code == 200
    assert response.json() == {"status": "ok", "database": "ok"}


@pytest.mark.asyncio
async def test_health_reports_database_failure() -> None:
    app.dependency_overrides[get_db] = override_unhealthy_db

    try:
        async with httpx.AsyncClient(
            transport=httpx.ASGITransport(app=app),
            base_url="http://test",
        ) as client:
            response = await client.get("/health")
    finally:
        app.dependency_overrides.clear()

    assert response.status_code == 503
    assert response.json() == {"detail": "Database unavailable"}
