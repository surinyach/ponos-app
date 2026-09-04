from datetime import date

import pytest
from fastapi.testclient import TestClient
from pydantic import ValidationError

from app.main import app
from app.schemas.focus_area import (
    FocusAreaCreate,
    FocusAreaPrioritiesUpdate,
    FocusAreaUpdate,
)


def target(weekday: int = 1) -> dict[str, object]:
    return {
        "weekday": weekday,
        "target_minutes": 60,
        "valid_from": "2026-09-07",
    }


def test_openapi_exposes_only_the_requested_operations() -> None:
    paths = app.openapi()["paths"]

    assert set(paths["/api/v1/focus-areas"]) == {"get", "post"}
    assert set(paths["/api/v1/focus-areas/archived"]) == {"get"}
    assert set(paths["/api/v1/focus-areas/priorities"]) == {"patch"}
    assert set(paths["/api/v1/focus-areas/{focus_area_id}"]) == {"get", "patch"}
    assert set(paths["/api/v1/focus-areas/{focus_area_id}/archive"]) == {"post"}
    assert set(paths["/api/v1/focus-areas/{focus_area_id}/restore"]) == {"post"}
    assert all("delete" not in operations for operations in paths.values())


def test_create_requires_initial_targets_and_allows_optional_end_date() -> None:
    request = FocusAreaCreate.model_validate(
        {
            "name": "Work placement",
            "description": None,
            "priority": 1,
            "targets": [target()],
        }
    )

    assert request.target_end_date is None
    assert request.targets[0].valid_from == date(2026, 9, 7)


def test_create_rejects_duplicate_target_weekdays() -> None:
    with pytest.raises(ValidationError):
        FocusAreaCreate.model_validate(
            {
                "name": "Work placement",
                "priority": 1,
                "targets": [target(), target()],
            }
        )


def test_patch_is_partial_but_not_empty() -> None:
    request = FocusAreaUpdate.model_validate({"description": "Updated"})
    assert request.description == "Updated"

    with pytest.raises(ValidationError):
        FocusAreaUpdate.model_validate({})


@pytest.mark.parametrize("field", ["name", "priority", "targets"])
def test_patch_rejects_null_for_non_nullable_fields(field: str) -> None:
    with pytest.raises(ValidationError):
        FocusAreaUpdate.model_validate({field: None})


def test_target_changes_require_a_new_effective_date() -> None:
    with pytest.raises(ValidationError):
        FocusAreaUpdate.model_validate(
            {"targets": [{"weekday": 1, "target_minutes": 90}]}
        )


def test_priority_contract_allows_duplicate_priorities() -> None:
    request = FocusAreaPrioritiesUpdate.model_validate(
        {
            "items": [
                {"id": 1, "priority": 2},
                {"id": 2, "priority": 2},
            ]
        }
    )

    assert request.items[0].priority == request.items[1].priority


def test_contract_routes_do_not_access_persistence_yet() -> None:
    with TestClient(app) as client:
        archived = client.get("/api/v1/focus-areas/archived")
        created = client.post(
            "/api/v1/focus-areas",
            json={
                "name": "Work placement",
                "priority": 1,
                "targets": [target()],
            },
        )

    assert archived.status_code == 501
    assert created.status_code == 501