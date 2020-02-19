---
---

## length of names - short names
- highlighted in QA report
- 2, 1 or 0 character length names might need to be excluded from OpenC on the basis of bad data at source
  - examples might be source redacting company names for privacy or security reasons.
  - might not apply in all jurisdictions (Eg Japan / China which have glyphs representing syllables)

## length of names - long names
- company.name is limited to 2000 characters, any being imported longer than that will be truncated
- QA report will highlight long names.
- Validation of company schema will prevent long names from being added to OpenC
- Detection of names longer than 2000 characters should be treated as a blocker for that bot pending dev team investigation
