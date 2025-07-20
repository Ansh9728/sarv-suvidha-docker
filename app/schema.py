from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime, date
from enum import Enum

class BMBCChecksheetEnum(str, Enum):
    Good = "Good"
    WornOut = "WornOut"
    Damaged = "Damaged"
    Others = "Others"

class BogieDetails(BaseModel):
    """ BogieDetails."""
    bogieNo: str
    makerYearBuilt: str
    incomingDivAndDate: date
    deficitComponents: str
    dateOfIOH: date
    
    
class BogieChecksheet(BaseModel):
    """ BogieChecksheet."""
    
    bogieFrameCondition: str
    bolster: str
    bolsterSuspensionBracket: str
    lowerSpringSeat: str
    axleGuide: str


class BmbcChecksheet(BaseModel):
    """ BmbcChecksheet."""
    cylinderBody: BMBCChecksheetEnum
    pistonTrunnion: BMBCChecksheetEnum
    adjustingTube: BMBCChecksheetEnum
    plungerSpring: BMBCChecksheetEnum

class BogieFormCreate(BaseModel):
    
    """ BogieFormCreate."""
    
    formNumber: str
    inspectionBy: str
    inspectionDate: date
    bogieDetails: BogieDetails
    bogieChecksheet: BogieChecksheet
    bmbcChecksheet: BmbcChecksheet
    
    
# wheell specification schema

class WheelSpecFields(BaseModel):
    condemningDia: str
    lastShopIssueSize: str
    treadDiameterNew: str
    wheelGauge: str

class WheelSpecResponseItem(BaseModel):
    formNumber: str
    submittedBy: str
    submittedDate: str  # consistency with query param
    fields: WheelSpecFields

class WheelSpecResponse(BaseModel):
    data: List[WheelSpecResponseItem]
    message: str
    success: bool
    
    
class WheelSpecificationFields(BaseModel):
    axleBoxHousingBoreDia: Optional[str]
    bearingSeatDiameter: Optional[str]
    condemningDia: Optional[str]
    intermediateWWP: Optional[str]
    lastShopIssueSize: Optional[str]
    rollerBearingBoreDia: Optional[str]
    rollerBearingOuterDia: Optional[str]
    rollerBearingWidth: Optional[str]
    treadDiameterNew: Optional[str]
    variationSameAxle: Optional[str]
    variationSameBogie: Optional[str]
    variationSameCoach: Optional[str]
    wheelDiscWidth: Optional[str]
    wheelGauge: Optional[str]
    wheelProfile: Optional[str]

class WheelSpecificationRequest(BaseModel):
    fields: WheelSpecificationFields
    form_number: str
    submitted_by: str
    submitted_date: datetime
