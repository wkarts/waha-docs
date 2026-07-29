**Message Capping** means WhatsApp has put a **per-cycle quota** on how many **new contacts** the account
may message - once `CAPPED`, sending messages to new contacts fails with `server returned error 475`
until the cycle resets.

When you receive `messageCapping` (in `session.status` `data` or in the `me` info):

- Do **NOT** restart, logout or re-pair the session - it does **not** reset the quota.
  The session is healthy, stays connected and remains in `WORKING` status.
- Watch `cappingStatus` - `FIRST_WARNING` and `SECOND_WARNING` mean the account is approaching the cap,
  so **slow down outreach to new contacts** before it becomes `CAPPED`.
- Once `CAPPED` - **pause outreach to new contacts** until `cycleEnd` (unix timestamp, seconds),
  when WhatsApp resets the quota.
- Messaging **existing chats** still works - the quota only counts 1:1 messages
  to contacts without an established chat.
- **WAHA** does **NOT** block any API calls while capped - WhatsApp enforces the quota server-side.
