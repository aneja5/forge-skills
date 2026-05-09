---
description: Redact sensitive information from .forge/ documents for external sharing
---

Invoke the forge-skills:redaction-and-cleanup skill.

SAFETY: NEVER modify original files. All redaction happens on copies in .forge/redacted/.

Define redaction categories with the user (pricing, credentials, strategy, names).
Define what to KEEP (public data, architecture patterns, role titles).
Scan all .forge/ files for matches.
Generate manifest documenting every change.
Copy files to .forge/redacted/ and apply redactions to copies only.
Verify: grep confirms zero remaining matches in .forge/redacted/.

Output: .forge/redaction-manifest.md + cleaned files in .forge/redacted/
