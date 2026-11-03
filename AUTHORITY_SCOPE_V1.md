# JSONWISDOM AUTHORITY SCOPE V1

STATUS: ACTIVE_INTERPRETATION_LAYER
EFFECTIVE: NOW_FORWARD
HISTORY_REWRITE: FALSE

## Purpose

This file resolves ambiguous legacy uses of the word authority across jsonwisdom public repositories.

## Canonical scope rule

Bare fields or prose such as authority=false, AUTHORITY = FALSE, Authority: false, or authority_created=false MUST NOT be interpreted as a blanket statement about Jason Wisdom's personhood, dignity, conscience, authorship, self-direction, consent, or authenticated control of his own systems.

Unless an artifact explicitly names a different subject, legacy unscoped false-authority fields are interpreted as machine, agent, render, replay, repository, artifact, or protocol non-authority.

## Required scoped vocabulary

JASON_OPERATOR_CONTROL = TRUE_WHEN_AUTHENTICATED
AI_AUTHORITY = FALSE
AGENT_AUTHORITY = FALSE by default
MACHINE_AUTHORITY_CREATED = FALSE
RENDER_LAYER_AUTHORITY = FALSE
REPLAY_VERDICT != OPERATOR_AUTHORITY
VERIFICATION_RESULT != LEGAL_AUTHORITY
ARTIFACT_LEGAL_AUTHORITY_CREATED = FALSE unless an independently valid legal source creates it

## Non-collapse

IDENTITY != AUTHORIZATION
OPERATOR_CONTROL != AI_AUTHORITY
CONSENT != SILENCE
HELPER != AUTHOR
REPLAY != LEGAL_FINDING
REPOSITORY_STATE != GOVERNMENT_AUTHORITY
ATTESTATION != GLOBAL_AUTHORITY

## Historical compatibility

Historical commits, receipts, fixtures, hashes, and frozen artifacts remain unchanged.
This layer changes interpretation forward; it does not falsify or rewrite past bytes.
When a historical artifact uses unscoped authority language, replay should preserve the original bytes and attach this compatibility rule as the current interpretive scope.

## External authority

Any claimed governmental, judicial, corporate, contractual, or institutional authority must identify SUBJECT, SOURCE, ISSUER, SCOPE, EFFECTIVE_AT, EXPIRES_AT or DURATION, JURISDICTION, ACTION_AUTHORIZED, ACTION_NOT_AUTHORIZED, and RECEIPT / ORDER / CONTRACT / RULE POINTER.

Unknown fields remain UNKNOWN.
