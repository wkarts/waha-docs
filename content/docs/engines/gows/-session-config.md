<div></div>

You can configure GOWS-specific options per session via `config.gows`.

- `storage.messages` - Store messages locally. Set to `false` to disable.
- `storage.groups` - Store groups locally. Set to `false` to disable.
- `storage.chats` - Store chats locally. Set to `false` to disable.
- `storage.labels` - Store labels locally. Set to `false` to disable.
- `storage.contacts` - Store contacts locally. Set to `false` to disable.
  When disabled: contacts API returns no data, no contact names in chats,
  no push name updates, and sending status to all contacts doesn't work.
- `storage.messageSecrets` - Store message secrets locally. Set to `false` to disable.
  When disabled: incoming poll votes, event responses and bot messages can't be decrypted,
  and sending your own poll votes doesn't work.

If a field is omitted or set to `null`, storage remains enabled for that data type.

```json
{
  "name": "default",
  "config": {
    "gows": {
      "storage": {
        "messages": true,
        "groups": true,
        "chats": true,
        "labels": true,
        "contacts": true,
        "messageSecrets": true
      }
    }
  }
}
```
