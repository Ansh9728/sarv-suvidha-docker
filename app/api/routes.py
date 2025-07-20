from typing import Optional
from fastapi import APIRouter, status, Depends, Query, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import and_
from fastapi.responses import JSONResponse
from app.schema import BogieFormCreate
from app.core.database import postgres_db
from app.models import BogieFormORM
from app.schema import WheelSpecResponse, WheelSpecificationRequest
from app.models import WheelSpecification
import datetime



api_router = APIRouter()


def convert_dates(obj):
    """
    Recursively convert all `date` or `datetime` values in a dict to ISO format strings.
    """
    if isinstance(obj, dict):
        return {k: convert_dates(v) for k, v in obj.items()}
    elif isinstance(obj, list):
        return [convert_dates(v) for v in obj]
    elif isinstance(obj, (datetime.date, datetime.datetime)):
        return obj.isoformat()
    else:
        return obj



@api_router.post('/forms/bogie-checksheet', status_code=status.HTTP_201_CREATED)
async def create_bogie_form(
    form: BogieFormCreate,
    db: AsyncSession = Depends(postgres_db.get_db)
    ):
    
    try:
        
        existing_form = await db.execute(
            select(BogieFormORM).where(BogieFormORM.formNumber==form.formNumber)
        )
        
        if existing_form.scalar():
            # raise HTTPException(status_code=400, detail="Form with this number already exists")
            return JSONResponse(
            content={
                "message": "Form with this number already exists",
                # "data": form.model_dump_json()
                "success":False,
                }, 
            status_code=status.HTTP_400_BAD_REQUEST
        )
        
        # Convert nested dicts to remove datetime.date
        bogieDetails_clean = convert_dates(form.bogieDetails.model_dump())
        bogieChecksheet_clean = convert_dates(form.bogieChecksheet.model_dump())
        bmbcChecksheet_clean = convert_dates(form.bmbcChecksheet.model_dump())
        
        # For saving the Data in database
        # new_form = BogieFormORM(**form.dict())
        # new_form = BogieFormORM(
        #     formNumber=form.formNumber,
        #     inspectionBy=form.inspectionBy,
        #     inspectionDate=form.inspectionDate,
        #     bogieDetails=form.bogieDetails.model_dump(),
        #     bogieChecksheet=form.bogieChecksheet.model_dump(),
        #     bmbcChecksheet=form.bmbcChecksheet.model_dump()
        # )
        
        new_form = BogieFormORM(
            formNumber=form.formNumber,
            inspectionBy=form.inspectionBy,
            inspectionDate=form.inspectionDate,
            bogieDetails=bogieDetails_clean,
            bogieChecksheet=bogieChecksheet_clean,
            bmbcChecksheet=bmbcChecksheet_clean
        )
        db.add(new_form)
        await db.commit()
        await db.refresh(new_form)
        # For now, just return the received data.
        
        
        return JSONResponse(
            content={
                "message": "Bogie form created",
                # "data": form.model_dump_json()
                "success":True,
                }, 
            status_code=status.HTTP_201_CREATED
        )
    except Exception as e:
        await db.rollback()
        raise HTTPException(status_code=500, detail=str(e))


@api_router.get("/forms/wheel-specifications", response_model=WheelSpecResponse)
async def get_wheel_specs(
    formNumber: Optional[str] = Query(None),
    submittedBy: Optional[str] = Query(None),
    submittedDate: Optional[str] = Query(None),
    db: AsyncSession = Depends(postgres_db.get_db)
):
    try:
        filters = []

        if formNumber:
            filters.append(WheelSpecification.form_number == formNumber)
        if submittedBy:
            filters.append(WheelSpecification.submitted_by == submittedBy)
        if submittedDate:
            filters.append(WheelSpecification.submitted_date == submittedDate)
            
        stmt = select(WheelSpecification)
        if filters:
            stmt = stmt.where(*filters)
            
        results = await db.execute(stmt)
        results = results.scalars().all()

        data = []
        for row in results:
            data.append({
                "formNumber": row.form_number,
                "submittedBy": row.submitted_by,
                "submittedDate": row.submitted_date.strftime("%Y-%m-%d"),
                "fields": {
                    "condemningDia": row.condemning_dia,
                    "lastShopIssueSize": row.last_shop_issue_size,
                    "treadDiameterNew": row.tread_diameter_new,
                    "wheelGauge": row.wheel_gauge
                }
            })
            
        return JSONResponse(
            content={
                "message": "Wheel specs retrieved",
                "data": data,
                "success": True
            },
            status_code=status.HTTP_200_OK
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error retrieving data: {str(e)}")


@api_router.post("/forms/wheel-specifications", status_code=status.HTTP_201_CREATED)
async def create_wheel_specification(
    payload: WheelSpecificationRequest,
    db: AsyncSession = Depends(postgres_db.get_db)
):
    
    existing_form = await db.execute(
            select(BogieFormORM).where(WheelSpecification.form_number==payload.form_number)
        )
        
    if existing_form.scalar():
        return JSONResponse(
        content={
            "message": "Form wheel already stored",
            "success":False,
            }, 
        status_code=status.HTTP_400_BAD_REQUEST
    )
    
    try:
        # Create ORM object
        new_entry = WheelSpecification(
            form_number=payload.form_number,
            submitted_by=payload.submitted_by,
            submitted_date=payload.submitted_date,
            fields=payload.fields.model_dump()
        )

        # Save to DB
        db.add(new_entry)
        await db.commit()
        await db.refresh(new_entry)
        
        return JSONResponse(
            content={
                
                "message": "Wheel specification submitted successfully.",
                "success": True,
                "data": {
                "formNumber": new_entry.form_number,
                "status": "Saved",
                "submittedBy": new_entry.submitted_by,
                "submittedDate": str(new_entry.submitted_date)
            },
            }
        )

    except Exception as e:
        await db.rollback()
        raise HTTPException(status_code=500, detail=f"Error submiting wheel spec data: {str(e)}")

