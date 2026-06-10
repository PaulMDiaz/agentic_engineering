# Context Glossary Format

Prefer the repository's existing context or glossary format. This file is a fallback for
repos that do not already define one.

## Discovery

Use the first existing convention that applies:

1. Root `CONTEXT-MAP.md` for multi-context repos.
2. Root `CONTEXT.md` for single-context repos.
3. Nearest context-specific `CONTEXT.md` when the plan clearly belongs to one subsystem.

If none exists, create a root `CONTEXT.md` lazily only after the first project-specific
term is resolved.

## Structure

```md
# {Context Name}

{One or two sentences describing what this context is and why it exists.}

## Language

**Order**:
An intent to purchase goods or services from the business.
_Avoid_: Purchase, transaction

**Invoice**:
A request for payment sent to a customer after delivery.
_Avoid_: Bill, payment request

**Customer**:
A person or organization that places orders.
_Avoid_: Client, buyer, account
```

## Rules

- Be opinionated. Pick one canonical term and list rejected synonyms under `_Avoid_`.
- Keep definitions tight: one or two sentences.
- Define what the concept is, not what code does with it.
- Include only domain or project terms. General programming concepts do not belong here.
- Keep implementation details, APIs, schemas, and algorithm choices out of context docs.
- Group terms under subheadings when natural clusters emerge.

## Multi-Context Repos

For multi-context repos, `CONTEXT-MAP.md` should list contexts, where they live, and how
they relate.

```md
# Context Map

## Contexts

- [Ordering](./src/ordering/CONTEXT.md): receives and tracks customer orders
- [Billing](./src/billing/CONTEXT.md): generates invoices and processes payments
- [Fulfillment](./src/fulfillment/CONTEXT.md): manages warehouse picking and shipping

## Relationships

- **Ordering -> Fulfillment**: Ordering emits `OrderPlaced` events; Fulfillment consumes them.
- **Fulfillment -> Billing**: Fulfillment emits `ShipmentDispatched` events; Billing consumes them.
- **Ordering <-> Billing**: Shared types for `CustomerId` and `Money`.
```

When multiple contexts exist and the target context is unclear, ask before updating docs.
