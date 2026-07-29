<div></div>

You can use the following environment variables to configure the global behavior of the [**NOWEB**]({{< relref "/docs/how-to/engines#noweb" >}}) engine:

**WhatsApp Web Version**

**NOWEB** ships with a built-in WhatsApp Web version, and you can override it without waiting for a new release:

- `WAHA_NOWEB_WA_VERSION=2.3000.1234567890` - set the WhatsApp Web version to use.
  - WAHA compares it with the built-in version **once on start** and uses the **higher** one.
  - If the built-in version is higher - the variable is ignored (you'll see the resolved version in logs).
- `WAHA_NOWEB_WA_VERSION_FORCE=True` - always use the version from `WAHA_NOWEB_WA_VERSION`, even if the built-in version is higher. By default, it's `False`.

```bash
WHATSAPP_DEFAULT_ENGINE=NOWEB

# Used only if it's higher than the built-in version
WAHA_NOWEB_WA_VERSION=2.3000.1234567890

# Set to True to use WAHA_NOWEB_WA_VERSION even if the built-in version is higher
WAHA_NOWEB_WA_VERSION_FORCE=False
```
