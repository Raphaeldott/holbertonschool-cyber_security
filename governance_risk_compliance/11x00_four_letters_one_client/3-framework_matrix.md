# Framework Comparison Matrix

| Framework | Enforced by | Who must comply | What it protects | Max realistic consequence | Proof artifact |
|-----------|-------------|-----------------|------------------|---------------------------|----------------|
| GDPR | EU/EEA national supervisory authorities (DPAs) | Any organization that offers goods/services to, or monitors, people in the EU/EEA — wherever it is based | Personal data of people in the EU/EEA | Fine up to €20M **or** 4% of worldwide annual turnover, whichever is higher (Art. 83); plus processing bans / corrective orders | Records of Processing Activities (RoPA) + Data Processing Agreements (DPAs) |
| HIPAA | HHS Office for Civil Rights (OCR) | Covered entities and their business associates | Protected Health Information (PHI) | Civil penalties capped at ~$2.1M per violation category per year (inflation-adjusted from the $1.5M statutory cap); plus OCR corrective action plans | Executed BAAs + a documented risk analysis |
| PCI DSS | The card brands, via acquiring banks (contractual) | Any merchant/service provider that stores, processes, or transmits cardholder data | Cardholder data (CHD) | Acquirer fines ~$5,000–$100,000 per month until compliant, **plus** loss of the ability to process cards (processing termination) | ROC or SAQ + an Attestation of Compliance (AOC) |
| SOC 2 | Market and contract pressure (no regulator) | Voluntary — service orgs whose customers demand it | Service-organization controls over the Trust Services Criteria | No fine — lost deals and lost revenue | The SOC 2 report itself (from a licensed CPA firm) |

## Status as of 2026
- **PCI DSS:** v4.0.1 is the only active version (v3.2.1 retired 31 March 2024); all future-dated v4.x requirements have been mandatory since **31 March 2025**.
- **HIPAA:** the Security Rule update is still a **proposal** — the NPRM was published in January 2025 and has not been finalized or taken effect.
- **GDPR:** enforcement is real and large — the landmark fine remains Meta's **€1.2 billion** penalty (May 2023), the largest to date per the GDPR Enforcement Tracker.
- **SOC 2:** reports are issued against the AICPA **Trust Services Criteria** (Security is the mandatory common criteria; Availability, Processing Integrity, Confidentiality, and Privacy are optional). A Type II covers operating effectiveness over a period.
