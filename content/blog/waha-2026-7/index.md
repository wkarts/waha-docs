---
title: "WAHA 2026.7 - Passkey Pairing, Scoped Keys, Reachout Timelock"
description: "WAHA 2026.7 - Passkey Pairing, Scoped Keys, Reachout Timelock and more!"
excerpt: "WAHA 2026.7 - Passkey Pairing, Scoped Keys, Reachout Timelock and more!"
date: 2026-07-29T08:48:45+00:00
draft: false
images: [ "waha-2026-7.png" ]
categories: [ "Releases" ]
tags: [ ]
contributors: [ "devlikeapro" ]
pinned: false
homepage: false
slug: waha-2026-7
---

## 🔑 Passkey Pairing (GOWS)

WhatsApp started asking for a **passkey** on some accounts when you link a device -
the session stops at `PASSKEY_REQUIRED` and waits instead of going to `WORKING`.

**WAHA** now handles it! Pair such sessions right from the
[**📊 Dashboard**]({{< relref "/docs/how-to/dashboard" >}}) (with the WAHA browser extension),
or build the flow into **your own UI** with two API calls:

```http request
GET /api/{session}/auth/passkey
```

```http request
POST /api/{session}/auth/passkey
```

We wrote a full guide on how it works and how to handle it from your own branded UI:
[**How to Handle Passkey**]({{< relref "/blog/waha-passkey" >}})

## ⏳ Reachout Timelock

WhatsApp **shadow-restricts** accounts that message too many **new contacts** -
sending fails with `server returned error 463` while the session looks perfectly fine.

**WAHA** now exposes the **Reachout Timelock** state, so you can detect it and stop your campaigns in time
(do **NOT** restart or re-pair the session - it lifts automatically!):

```jsonc { title="session.status" }
{
  "event": "session.status",
  "session": "default",
  "payload": {
    "status": "WORKING",
    "data": {
      "reachoutTimelock": {
        "isActive": true,
        "timeEnforcementEnds": 1784477333
      }
    }
  }
}
```

You also get it in the `me.reachoutTimelock` field in `GET /api/sessions` and `GET /api/sessions/{session}/me`.

Available in **GOWS**, **NOWEB** and **WEBJS**!

Read more: [**⏳ Reachout Timelock**]({{< relref "/docs/how-to/sessions#reachout-timelock" >}}) — [#2166](https://github.com/devlikeapro/waha/issues/2166)

## 🔒 Scoped Session Keys

Need to put a media URL in an `<img>` tag or show a QR code in a browser -
but don't want to expose your real `WAHA_API_KEY`?

You can now mint **narrow keys** locked to one action for one session:

```http request
POST /api/keys/media
```

```http request
POST /api/keys/control
```

The **media** key can only download the session's files, the **control** key can only open QR code and screenshot.
**MCP** uses them internally now, so your real API key never leaks into an AI client transcript!

Read more: [**🔒 Scoped Session Keys**]({{< relref "/docs/how-to/security#scoped-session-keys" >}}) — [#2146](https://github.com/devlikeapro/waha/issues/2146)

## 👥 Who Can Add Members (Groups)

You can now control (and read) the group setting for **who can add new members** - all members or admins only:

```http request
PUT /api/{session}/groups/{groupId}/settings/security/member-add-mode
```

```jsonc { title="Body" }
{
  // true - all members can add new members
  // false - only admins can add new members
  "membersCanAddNewMember": true
}
```

Read more: [**👥 Groups**]({{< relref "/docs/how-to/groups#security---who-can-add-members" >}}) — [#2165](https://github.com/devlikeapro/waha/issues/2165), [#2172](https://github.com/devlikeapro/waha/issues/2172)

## 🔗 Link Previews in Channels

Sending link previews to **Channels** was broken in different ways in different engines -
blurred thumbnail on Android, white image on iPhone, or no preview at all.

Fixed in **WEBJS**, **NOWEB** and **GOWS**! — [#2163](https://github.com/devlikeapro/waha/issues/2163)

For **GOWS** there's also a new env var to control how long the engine waits for preview generation:

```bash
WAHA_GOWS_LINK_PREVIEW_TIMEOUT=10s
```

## 🛠️ Other Fixes

**WEBJS**
- Not receiving message events after WhatsApp's id rename. — [#2157](https://github.com/devlikeapro/waha/issues/2157), [#2162](https://github.com/devlikeapro/waha/issues/2162)
- `GET /api/{session}/groups` returning HTTP 500. — [#2159](https://github.com/devlikeapro/waha/issues/2159)
- `Cannot GET /api/{session}/chats` error. — [#2160](https://github.com/devlikeapro/waha/issues/2160)
- Sending an image failing with `msg.avParams is not a function`. — [#2149](https://github.com/devlikeapro/waha/issues/2149)
- `Cannot read properties of undefined (reading 'includes')`. — [#2158](https://github.com/devlikeapro/waha/issues/2158)
- The current account LID is now available in the session `me.lid` field.

**GOWS**
- No webhook events after `<stream:error>` while status stays `WORKING`. — [#2151](https://github.com/devlikeapro/waha/issues/2151)
- `unknown field "faviconMMSMetadata"` error. — [#2172](https://github.com/devlikeapro/waha/issues/2172)

**NOWEB**
- Empty `message.edited` event body. — [#2168](https://github.com/devlikeapro/waha/issues/2168)
- Timestamp bug that broke message sorting when fetching chat history. — [#2139](https://github.com/devlikeapro/waha/issues/2139)
- WhatsApp Web version fix. — [#2191](https://github.com/devlikeapro/waha/issues/2191)

**ChatWoot**
- Safe read and show typing while sending messages. — [#2173](https://github.com/devlikeapro/waha/issues/2173)

**Core**
- One stuck session no longer aborts restarting the other stopped sessions. — [#2169](https://github.com/devlikeapro/waha/issues/2169)

**📊 Dashboard**
- Session info in session details and a copy button in Event Monitor.
- Passkey pairing UI with manual DevTools fallback.

## 🆕 Changelog

Check out the full list of updates in the [**🆕 WAHA 2026.7 Changelog**]({{< relref "/docs/overview/changelog#20267" >}}) and stay tuned for more!
