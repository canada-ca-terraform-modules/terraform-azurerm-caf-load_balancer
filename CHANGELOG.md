# Changelog

All notable changes to this module are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [2.0.0] - 2026-07-29

### Removed

- **Breaking:** removed unused pass-through input variables `group`, `project`, `custom_data`,
  `user_data`. None of the four were ever consumed inside this module (dead copy-paste artifacts
  from a VM-module template); they only existed so `ESLZ/load-banlancer.tf` could forward them.
  Callers passing any of these four keys to the module must remove them — `terraform plan` will
  otherwise fail with `Error: Unsupported argument`.

### Changed

- Upgraded `azurerm` provider constraint to `~> 5.0` (created `providers.tf`; none existed before).
- `azurerm_lb_rule.loadbalancer-lbr`: renamed resource attributes to match the azurerm v5 schema —
  `enable_floating_ip` -> `floating_ip_enabled`, `enable_tcp_reset` -> `tcp_reset_enabled`.
  Caller-facing tfvars keys (`enable_floating_ip`, `enable_tcp_reset`) are unchanged; the mapping
  is internal to the module, so no caller changes are required.
- Bumped self-referential ESLZ module ref in `ESLZ/load-banlancer.tf` from `v1.0.1` to `v2.0.0`,
  and removed the `group`/`project`/`custom_data`/`user_data` pass-through arguments from its
  `module` block.

### Fixed

- `locals.tf`: invalid regex escape sequence `[^\/]+$` corrected to `[^/]+$` in the resource group
  name parsing (forward slash never needs escaping in RE2).
- `module.tf`: `frontend_ip_configuration.subnet_id` and `.private_ip_address` no longer crash when
  a frontend IP configuration omits the `subnet` / `private_ip_address` keys (e.g. public-IP-only
  frontends) — both are now guarded with `try()`.
- `module.tf`: removed a deprecated interpolation-only expression (`"${each.value.probe_name}"`) in
  the `azurerm_lb_rule` probe lookup.

### Added

- `providers.tf` pinning `azurerm ~> 5.0` and `required_version >= 1.9`.
- `.tflint.hcl`, `.gitignore`, `.gitattributes` (none previously existed).
- `.github/workflows/terraform-ci.yml` running fmt/init/validate/test/tflint on every PR.
- `tests/load_balancer.tftest.hcl` and `tests/upgrade_compat.tftest.hcl` (no prior test coverage existed).
- `sensitive = true` on all four module outputs, since each exposes a full resource object.
- Optional name overrides for every auto-generated resource name (frontend IP configuration,
  backend address pool, probes, rules) — see README "New optional arguments" section.

### Known limitations

- `tflint-ruleset-azurerm` intentionally omitted from `.tflint.hcl` — this module's `load_balancer`
  input is `type = any`, and the ruleset's attribute-level rules produce false positives against
  `any`-typed wrapper modules (consistent with prior upgrades of similarly-shaped modules).
- `tests/upgrade_compat.tftest.hcl` uses `command = plan` for its baseline run instead of `apply` —
  azurerm v5 strictly validates the ARM ID format of cross-resource references
  (`loadbalancer_id`, `probe_id`) at apply time, and `mock_provider`'s synthetic computed IDs do not
  match that format.
