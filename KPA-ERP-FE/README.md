# 🚆 ICF Forms API Documentation

This project handles digital form submissions for:

1. ✅ ICF Wheel Specifications Form  
2. ✅ ICF Bogie Checksheet Form

Both forms are digitally captured, submitted, and queried via REST APIs.

---

## 📌 TODOs / In-Scope Features

- [x] Submit Wheel Specifications form
- [x] Submit Bogie Checksheet form (multi-section)
- [x] Search both forms by Form Number / Inspector / Date
- [x] Dropdown support for "Inspection By" (from DB)
- [ ] Admin dashboard to view all forms
- [ ] Edit/Delete forms (Admin only)
- [ ] Export forms as PDF (optional)
- [ ] Authentication & role-based access (optional)

---

## 📘 1. Wheel Specifications Form

### 📤 API: `POST /api/forms/wheel-specifications`

**Description:** Submit ICF wheel specification form

#### Payload:
```json
{
  "formNumber": "WHEEL-2025-001",
  "submittedBy": "user_id_123",
  "submittedDate": "2025-07-03",
  "fields": {
    "treadDiameterNew": "915 (900-1000)",
    "lastShopIssueSize": "837 (800-900)",
    "condemningDia": "825 (800-900)",
    "wheelGauge": "1600 (+2,-1)",
    "variationSameAxle": "0.5",
    "variationSameBogie": "5",
    "variationSameCoach": "13",
    "wheelProfile": "29.4 Flange Thickness",
    "intermediateWWP": "20 TO 28",
    "bearingSeatDiameter": "130.043 TO 130.068",
    "rollerBearingOuterDia": "280 (+0.0/-0.035)",
    "rollerBearingBoreDia": "130 (+0.0/-0.025)",
    "rollerBearingWidth": "93 (+0/-0.250)",
    "axleBoxHousingBoreDia": "280 (+0.030/+0.052)",
    "wheelDiscWidth": "127 (+4/-0)"
  }
}


2. POST /api/forms/bogie-checksheet


{
  "formNumber": "BOGIE-2025-001",
  "inspectionBy": "user_id_456",
  "inspectionDate": "2025-07-03",
  "bogieDetails": {
    "bogieNo": "BG1234",
    "makerYearBuilt": "RDSO/2018",
    "incomingDivAndDate": "NR / 2025-06-25",
    "deficitComponents": "None",
    "dateOfIOH": "2025-07-01"
  },
  "bogieChecksheet": {
    "bogieFrameCondition": "Good",
    "bolster": "Good",
    "bolsterSuspensionBracket": "Cracked",
    "lowerSpringSeat": "Good",
    "axleGuide": "Worn",
    ...
  },
  "bmbcChecksheet": {
    "cylinderBody": "WORN OUT",
    "pistonTrunnion": "GOOD",
    "adjustingTube": "DAMAGED",
    "plungerSpring": "GOOD",
    ...
  }
}
  

  
