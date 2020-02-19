---
---
A flag indicating if the company is 'inactive'. This is an OpenCorporates field derived from either:
- inactive company statuses defined by the register, including dissolved, removed, liquidated, etc.
- when a company is has merged into or been acquired by another
- when it has a [dissolution_date](dissolution_date) that is in the past.

Note that not all companies make company statuses available, so that it cannot be inferred that a company is active just because inactive is not true.

Companies that have an extant legal personality that can e.g. sign contracts are not inactive: if they're undergoing bankruptcy, civil forfeiture etc. this flag should remain unset until they're entirely extinct and their last legal duties have been discharged.
