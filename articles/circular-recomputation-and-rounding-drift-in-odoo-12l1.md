---
title: "Circular Recomputation and Rounding Drift in Odoo"
url: "https://dev.to/borovlevas/circular-recomputation-and-rounding-drift-in-odoo-12l1"
author: "Borovlev Artem"
category: "erp-business-law"
---
# Circular Recomputation and Rounding Drift in Odoo
**Author:** Borovlev Artem  **Published:** March 1, 2026

## Overview
In ERP systems, having two fields representing the same value in different units creates synchronization challenges when both are editable. When `purchase_price = 10` with `rate = 3`, the system calculates `purchase_price_usd = 3.33`, then recomputes as `9.99` — silently changing the user's intended value. This is "a consequence of combining bidirectional field derivation, rounding, and automatic recomputation."

## Key Concepts

**Why It Happens: The Onchange Loop**
Odoo's form editing relies on `onchange` mechanisms. In bidirectional setups, "the mechanism becomes symmetrical" — each field updates the other. Even minor rounding adjustments trigger new passes because the framework cannot determine original user intent.

**Rounding as the Hidden Amplifier**
Mathematical reversibility breaks with rounding: `round(round(x / rate, 2) * rate, 2) ≠ x`. The system treats even 0.01 differences as real changes requiring synchronization. "Rounding does not create the loop. It makes the loop observable."

**Solution: Controlling Direction**
Treat "only one field as representing user intent" at any moment. When editing `purchase_price`, it becomes authoritative while `purchase_price_usd` derives from it.

```python
def onchange(self, values, field_names, fields_spec):
    ctx = {}
    if "purchase_price" in field_names:
        ctx["skip_purchase_price_recompute"] = True
    if "purchase_price_usd" in field_names:
        ctx["skip_purchase_price_usd_recompute"] = True
    self = self.with_context(**ctx)
    return super().onchange(values, field_names, fields_spec)
```

Compute methods check for these flags:

```python
@api.depends("purchase_price")
def _compute_purchase_price_usd(self):
    if self.env.context.get("skip_purchase_price_usd_recompute"):
        return
    for record in self:
        record.purchase_price_usd = round(record.purchase_price / record.rate, 2)
```

**Architectural Constraint**
"Bidirectional field synchronization combined with rounding inevitably breaks mathematical reversibility." Preserving user intent requires explicitly controlling direction — designating one field as the source of truth and suppressing reverse recomputation within each evaluation cycle.
