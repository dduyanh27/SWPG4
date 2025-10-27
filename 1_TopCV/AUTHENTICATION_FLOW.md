# Authentication Flow Diagram

```
┌─────────────────┐
│   User Request  │
└─────────┬───────┘
          │
          ▼
┌─────────────────┐
│AuthenticationFilter│
│  - Check session │
│  - Detect conflict│
│  - Basic auth    │
└─────────┬───────┘
          │
          ▼
┌─────────────────┐
│RoleBasedAccess  │
│ControlFilter    │
│  - Check path   │
│  - Check role   │
│  - Granular auth│
└─────────┬───────┘
          │
          ▼
┌─────────────────┐
│   Target Page   │
│   or Access     │
│   Denied Page   │
└─────────────────┘

Session Conflict Detection:
┌─────────────────┐
│  Session Check  │
└─────────┬───────┘
          │
          ▼
┌─────────────────┐
│  Has Conflict?  │
└─────────┬───────┘
          │ Yes
          ▼
┌─────────────────┐
│ Clear Session   │
│ Redirect to     │
│ Access Denied   │
└─────────────────┘

Role-Based Access:
┌─────────────────┐
│   Path Check    │
└─────────┬───────┘
          │
          ▼
┌─────────────────┐
│  Role Check     │
└─────────┬───────┘
          │
          ▼
┌─────────────────┐
│  Has Access?    │
└─────────┬───────┘
          │ No
          ▼
┌─────────────────┐
│ Generate Error  │
│ Message &       │
│ Redirect to     │
│ Access Denied   │
└─────────────────┘
