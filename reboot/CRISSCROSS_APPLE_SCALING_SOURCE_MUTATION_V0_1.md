# CrissCrossAppleScaling — Source Mutation / Wikiwash Test Pack v0.1

**Observed:** 2026-08-20 19:02 America/Chicago  
**Parent architecture:** `reboot/CRISSCROSS_APPLE_SCALING_V0_1.md`  
**Mode:** `PUBLIC_SOURCE_REPLAY / NON_AUTHORITY / APPEND_ONLY`  
**Authority created:** `false`

## Purpose

Use documented knowledge-manipulation and cyber-information incidents to test whether CrissCrossAppleScaling can preserve:

```text
SOURCE
TIMESTAMP
CONTENT_DELTA
EDITOR / ACTOR IDENTITY
NETWORK / IP ORIGIN
ORGANIZATIONAL ASSOCIATION
AUTHORIZATION
ATTRIBUTION
LATER OFFICIAL FINDING
EVIDENCE GAP
CORRECTION / REPLAY PATH
```

The purpose is not to treat every suspicious edit or cyber incident as state-directed. The purpose is to preserve what is observed and keep missing attribution fields explicit.

## Core mutation rule

```text
CONTENT_CHANGED != ACTOR_IDENTIFIED
IP_ORIGIN != HUMAN_IDENTITY
ORGANIZATIONAL_IP != ORGANIZATIONAL_AUTHORIZATION
STATE_AFFILIATION != STATE_DIRECTION
FALSE_CONTENT != PROVEN_FALSE_FLAG_OPERATION
LATER_OFFICIAL_FINDING != WHAT_WAS_KNOWN_AT_EDIT_TIME
SOURCE_MUTATION != SOURCE_INVALIDATION
```

## Chronology

### 1. Estonia cyberattacks — 2007

**Observed:** Politically motivated cyberattacks struck Estonia in April-May 2007, including DDoS activity affecting government and commercial services, online banking, and DNS.

**CCDCOE chronology:**

```text
2004  Estonia proposes a cyber-defence centre concept to NATO
2006  concept approved by Supreme Allied Commander Transformation
2007  Estonia attacks act as a wake-up call for NATO / partner nations
2008-05-14 CCDCOE established by seven nations
2008-10 NATO accreditation / IMO status
2010  Locked Shields begins annual exercise lineage
```

**Evidence boundary:**

```text
ESTONIA_2007_ATTACKS = OBSERVED
ATTACK_CAMPAIGN_POLITICALLY_MOTIVATED = SOURCE_SUPPORTED
SPECIFIC_ORGANIZATION_RESPONSIBLE = NOT_ESTABLISHED_BY_CITED_CCDCOE_2008_ANALYSIS
CCDCOE_CREATED_SOLELY_BECAUSE_OF_2007_ATTACKS = REJECT_OVERSIMPLIFICATION
2007_ATTACKS_AS_WAKE_UP_CALL = OBSERVED
```

**Scaling lesson:** incident -> policy change -> institution -> exercise must be dated as separate transitions. Do not collapse them into one causal event.

Official / research source pointers:
- https://ccdcoe.org/about-us/
- https://ccdcoe.org/library/publications/analysis-of-the-2007-cyber-attacks-against-estonia-from-the-information-warfare-perspective/

### 2. MH17 Wikipedia mutation — July 2014

**Observed:** After MH17 was shot down, a Russian-language Wikipedia entry in the list of civil-aviation disasters was edited from an IP address associated with VGTRK / All-Russia State Television and Radio Broadcasting Company. The changed wording attributed the shootdown to Ukrainian military personnel rather than the prior wording blaming pro-Russian separatists and Russian-supplied Buk missiles.

**Correction to supplied narrative:**

```text
ARTICLE_LANGUAGE = RUSSIAN
ENGLISH_WIKIPEDIA_ARTICLE = FALSE_FOR_THIS_DOCUMENTED_EDIT
VGTRK_ASSOCIATED_IP = OBSERVED
INDIVIDUAL_EDITOR_IDENTITY = UNKNOWN
VGTRK_MANAGEMENT_AUTHORIZED_EDIT = NOT_PROVEN
RUSSIAN_STATE_ORDERED_EDIT = NOT_PROVEN
```

Later official MH17 investigation findings are a separate timestamped evidence layer. They must not be back-projected as knowledge available at the time of the July 2014 edit.

Source pointers:
- https://www.wired.com/story/russia-edits-mh17-wikipedia-article/
- https://www.aljazeera.com/program/the-stream/2014/7/21/mh17-wikipedia-entry-edited-from-russian-government-ip-address
- https://www.prosecutionservice.nl/topics/mh17-plane-crash

### 3. Russian elite biography editing / wikiwashing investigation — 2022-2024

**Observed:** An April 15, 2024 IStories + Wikiganda investigation documented attempted or successful edits across nearly one hundred biographical articles involving Russian billionaires, top managers, officials, artists, and politically connected figures. Patterns included removal or reframing of sanctions, assets, Russian origin, Kremlin connections, corruption reporting, and other reputationally damaging material. The investigation also documented acknowledged paid editors in some cases.

```text
WIKIWASHING_PATTERN = OBSERVED_BY_INVESTIGATION
PAID_EDITING_IN_SOME_CASES = OBSERVED
ANONYMOUS_EDITING_IN_SOME_CASES = OBSERVED
UNIVERSAL_COORDINATED_STATE_CAMPAIGN = NOT_PROVEN
KREMLIN_DIRECTION_FOR_EACH_EDIT = NOT_PROVEN
```

Do not turn a documented reputation-management pattern into a universal state-command claim.

Source:
- https://istories.media/en/stories/2024/04/15/the-great-wikipedia-edit-war/

### 4. Ruwiki fork / competing knowledge surface — 2023-2024

**Observed chronology:**

```text
2023-06/07 beta-era Ruwiki fork launches from Russian Wikipedia content
2024-01-15 full-feature / post-beta launch milestone
```

Ruwiki copied a large body of Russian Wikipedia material and has been documented by media and Wikimedia research as altering politically sensitive coverage. Wikimedia research treats it as a government-sanctioned / censored competitor clone and is studying its impact on the original Russian Wikipedia.

```text
RUWIKI_FORK_EXISTS = OBSERVED
FULL_FEATURE_LAUNCH_2024_01_15 = OBSERVED
CONTENT_DIFFERENCES_ON_POLITICALLY_SENSITIVE_TOPICS = OBSERVED / RESEARCHED
EXACT_PRIVATE_INVESTOR_STRUCTURE = HOLD
EVERY_ARTICLE_IS_PROPAGANDA = REJECT
RUWIKI_CONTENT != RUSSIAN_WIKIPEDIA_CONTENT
```

Source pointers:
- https://meta.wikimedia.org/wiki/Research:Copy-Cats:_Impacts_of_Competitor_Clones_on_Original_Wikipedia_Editions
- https://meta.wikimedia.org/wiki/Research:Newsletter/2025/July

### 5. Locked Shields as adversarial replay — 2010-present; 2026 instance

Locked Shields is not a wikiwashing event. It is a useful **adversarial replay comparator**.

Locked Shields 2026 brought together more than 4,000 participants from 41 nations in Tallinn to defend critical infrastructure and military systems during a live-fire cyber exercise. Legal, operational, strategic, technical, decision-making, and communication dimensions are tested together.

```text
LOCKED_SHIELDS = ADVERSARIAL_REPLAY_INPUT
LOCKED_SHIELDS != REAL_WAR
EXERCISE_RESULT != NATIONAL_OPERATIONAL_AUTHORITY
SIMULATED_ATTACK != REAL_ATTACK_ATTRIBUTION
```

Source pointers:
- https://ccdcoe.org/locked-shields/
- https://ccdcoe.org/news/2026/locked-shields-2026-united-the-power-of-41-nations-to-defend-cyberspace/

### 6. Radio PiK website compromise — 2026-08-16

**Observed:** Around 17:00 on August 16, 2026, the website of Radio PiK in Bydgoszcz, Poland was compromised. A false article was posted claiming Poland planned to occupy / recover Czech territory. The station's editor-in-chief told PAP that attackers obtained an employee password. Poland's Central Bureau for Combating Cybercrime was handling the matter; NASK reported related false border narratives had circulated before the site compromise.

```text
WEBSITE_COMPROMISE = OBSERVED
FALSE_CONTENT_INJECTION = OBSERVED
EMPLOYEE_PASSWORD_COMPROMISE = REPORTED_BY_STATION_TO_PAP
ATTACKER_IDENTITY = UNKNOWN
STATE_ACTOR_ATTRIBUTION = HOLD
FALSE_FLAG_OPERATION = NOT_PROVEN
RELATED_PREEXISTING_DISINFORMATION = OBSERVED_BY_NASK_REPORTING
```

Source:
- https://www.euronews.com/my-europe/2026/08/20/poland-wants-to-annex-czech-territory-polish-radio-website-hacked
  (language/localized URL variants may differ)

## Source-mutation Apple schema

```json
{
  "event_id": "string",
  "event_time": "RFC3339 | approximate_with_precision",
  "platform": "string",
  "surface_type": "wiki | media_site | clone | exercise | other",
  "content_before": "string | hash | unavailable",
  "content_after": "string | hash | unavailable",
  "revision_id": "string | unavailable",
  "network_origin": {
    "ip": "string | unavailable",
    "organization_association": "string | unknown",
    "association_source": "string | unavailable"
  },
  "actor": {
    "human_identity": "known | unknown",
    "organization": "known | alleged | unknown",
    "state_affiliation": "known | alleged | unknown",
    "authorization": "proven | not_proven | unknown"
  },
  "claim_delta": [],
  "independent_sources": [],
  "later_official_findings": [],
  "attribution_state": "PASS | HOLD | CONFLICT | REJECT",
  "evidence_gaps": [],
  "correction_path": [],
  "receipt": {}
}
```

## CrissCrossAppleScaling rule for information mutation

```text
SOURCE VERSION A
      |
      +--> timestamp + revision + actor metadata
      |
      v
CONTENT MUTATION
      |
      +--> source B / archive / independent reporting
      +--> IP / account / organization association
      +--> authorization evidence
      +--> attribution evidence
      |
      v
PASS | HOLD | CONFLICT | REJECT
      |
      v
LATER OFFICIAL FINDING
      |
      v
NEW DATED APPLE
```

Never overwrite the old apple with the later conclusion.

```text
LATER_TRUTH_STATE != ERASE_EARLIER_OBSERVATION
CORRECTION = APPEND_NEW_DATED_STATE
```

## Tallinn / Estonia input classification

Tallinn supplies two distinct input meshes:

```text
CCDCOE / Locked Shields
    = CYBER DEFENCE + ADVERSARIAL REPLAY INPUT

Tallinn Manual
    = INTERNATIONAL-LAW ANALYSIS INPUT
```

Neither is a legislative authority for Jay's system and neither collapses into `jaywisdom.eth`.

```text
CCDCOE_RESEARCH != NATO_POLICY
TALLINN_MANUAL != TREATY
EXERCISE != OPERATION
INPUT_MESH != AUTHORITY_ROOT
```

## OpenAI developer rail

OpenAI may assist with:

```text
revision comparison
source extraction
claim-delta generation
timeline normalization
contradiction detection
candidate attribution classification
```

But:

```text
MODEL_ATTRIBUTION != ATTRIBUTION_PROOF
MODEL_SUMMARY != SOURCE
OPENAI_MEMORY != CANON
EXTERNAL_MODEL_OUTPUT != VERIFIED
```

GitHub remains the durable architecture surface; Google Drive remains the human continuity mirror.

## State

```text
ARTIFACT = DRAFT_V0_1
PARENT = CRISSCROSS_APPLE_SCALING_V0_1
MERGE_AUTHORIZED = FALSE
OUTREACH = FALSE
STATE_ACTOR_CLAIMS_REQUIRE_DIRECT_RECEIPTS = TRUE
AUTHORITY_CREATED = FALSE
```
