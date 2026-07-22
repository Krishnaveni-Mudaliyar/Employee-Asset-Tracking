# Operations runbook

## Job queue

Schedule codeunit **50013 AST Asset Monitoring** daily. It identifies assets whose warranty expires within 30 days. Notification delivery remains separated from detection so that delivery can be retried independently.

## Telemetry and privacy

Emit only operational IDs and counts. Do not send employee names, serial numbers, notes, or other customer content to telemetry. Use `SystemMetadata` or a lower permitted classification only after confirming the tenant's telemetry policy.

## Copilot

The Copilot component is a provider boundary, not a hard dependency. Enable a provider only after its data-processing and consent requirements have been approved. Never pass secrets or unrestricted customer content in prompts.
