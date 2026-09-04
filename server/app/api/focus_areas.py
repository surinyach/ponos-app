from typing import Annotated, NoReturn

from fastapi import APIRouter, HTTPException, Path, status

from app.schemas.focus_area import (
    FocusAreaCreate,
    FocusAreaPrioritiesUpdate,
    FocusAreaResponse,
    FocusAreaUpdate,
)

router = APIRouter(prefix="/api/v1/focus-areas", tags=["focus-areas"])
FocusAreaId = Annotated[int, Path(gt=0)]


def not_implemented() -> NoReturn:
    raise HTTPException(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        detail="Focus Area persistence is not implemented yet",
    )


@router.get("", response_model=list[FocusAreaResponse])
async def list_active_focus_areas() -> NoReturn:
    """List active Focus Areas; archived entries are excluded."""
    not_implemented()


@router.post("", response_model=FocusAreaResponse, status_code=status.HTTP_201_CREATED)
async def create_focus_area(_: FocusAreaCreate) -> NoReturn:
    """Create a Focus Area and its initial versioned weekday targets."""
    not_implemented()


@router.get("/archived", response_model=list[FocusAreaResponse])
async def list_archived_focus_areas() -> NoReturn:
    """List only archived Focus Areas."""
    not_implemented()


@router.patch("/priorities", response_model=list[FocusAreaResponse])
async def update_focus_area_priorities(_: FocusAreaPrioritiesUpdate) -> NoReturn:
    """Update priorities; multiple Focus Areas may share a value."""
    not_implemented()


@router.get("/{focus_area_id}", response_model=FocusAreaResponse)
async def get_focus_area(focus_area_id: FocusAreaId) -> NoReturn:
    """Return one active or archived Focus Area."""
    not_implemented()


@router.patch("/{focus_area_id}", response_model=FocusAreaResponse)
async def update_focus_area(
    focus_area_id: FocusAreaId,
    _: FocusAreaUpdate,
) -> NoReturn:
    """Partially update an area and append target versions when supplied."""
    not_implemented()


@router.post("/{focus_area_id}/archive", response_model=FocusAreaResponse)
async def archive_focus_area(focus_area_id: FocusAreaId) -> NoReturn:
    """Archive a Focus Area without deleting its history."""
    not_implemented()


@router.post("/{focus_area_id}/restore", response_model=FocusAreaResponse)
async def restore_focus_area(focus_area_id: FocusAreaId) -> NoReturn:
    """Restore an archived Focus Area."""
    not_implemented()