# Memo — Nordwell Compliance Priorities

**To:** CEO, Nordwell Technologies
**From:** Northbridge Risk Advisory
**Date:** Friday
**Re:** Three Monday fires — what is mandatory, what is contractual, what can wait

Three events landed at once. Here is what each one triggers, in what order to act, and what to do Monday.

## The three events

**1. Hartwell — SOC 2 Type II.** This is **contractual**, not law. No regulator requires SOC 2; Hartwell does, and so will the next enterprise buyer. Enforcement is market pressure: no report, no signature, no $1.2M. A Type II proves controls operate over a period, which is why they want it — and why it cannot be produced overnight.

**2. Brightpath — the BAA.** This is **law (HIPAA)**, enforced by the HHS Office for Civil Rights. Holding medical-note metadata for a hospital group's staff makes Nordwell a **business associate**; the BAA is a binding legal contract, not paperwork. Legal should not sign it blind — signing commits us to safeguards and breach-notification duties we must actually have in place before go-live.

**3. Q4 EU launch + in-app card payments.** Two frameworks. Selling to and monitoring people in France and Germany triggers **GDPR** (law, EU supervisory authorities). Taking cards in-app makes us a merchant under **PCI DSS** (contractual, card brands via our acquiring bank).

## Correcting the payment assumption
Using a payment provider **reduces** our PCI scope — it does not remove it. We remain a merchant with obligations; the embedded checkout still puts us in scope, and the integration method decides whether we qualify for the lightest self-assessment (SAQ A) or something heavier.

## Priority order (by legal force and deadline)
1. **Brightpath / HIPAA** — the only hard legal blocker on the near horizon (8 weeks), on a signed deal, with health data. Non-negotiable.
2. **Hartwell / SOC 2** — nearest clock (6 weeks) and largest single ARR; start now, because Type II needs an observation window. They accept Type I + a roadmap.
3. **Q4 / GDPR + PCI DSS** — real but has runway; both need lead time, so begin in parallel, not at launch.

## Current facts
- **HIPAA:** the proposed Security Rule update is still an NPRM (Jan 2025), not yet in force.
- **SOC 2:** issued against the AICPA Trust Services Criteria; Type II = operating effectiveness over time.
- **GDPR:** fines reach €20M or 4% of global turnover; the Meta €1.2B fine (2023) sets the ceiling in practice.
- **PCI DSS:** v4.0.1 is the only active version; all its requirements are mandatory since 31 March 2025.

## Monday morning
- **Hartwell:** engage a CPA firm to scope SOC 2; commit to a Type I + dated Type II roadmap and send it to hold the deal.
- **Brightpath:** start a HIPAA risk analysis and stand up safeguards + breach process — then sign the BAA before go-live.
- **Q4:** confirm the checkout integration to lock PCI scope (target SAQ A), and begin GDPR groundwork (RoPA, DPAs, lawful basis, EU representative).
