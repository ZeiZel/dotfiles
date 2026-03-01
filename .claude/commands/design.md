---
name: design
description: Create a system design document with architecture diagrams, data models, and trade-off analysis
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, WebFetch
---

Design the system/feature: $ARGUMENTS

Follow the system-design skill framework:

1. **Requirements**: Clarify functional and non-functional requirements
2. **Estimation**: Back-of-the-envelope capacity planning
3. **Architecture**: Create Mermaid diagram of components
4. **Data Model**: Define entities, relationships, access patterns
5. **API Design**: Key endpoints with request/response schemas
6. **Scaling Plan**: What changes at 10x, 100x
7. **Trade-offs**: Document what we gain and sacrifice
8. **ADR**: Write an Architecture Decision Record

Save the output as a markdown document in `docs/design/` directory.
