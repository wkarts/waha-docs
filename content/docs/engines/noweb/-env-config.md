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

{{< callout context="tip" title="Auto-update WhatsApp Web Version" icon="outline/refresh" >}}

<div style="width: 100%">

You can resolve the **latest** WhatsApp Web version right before WAHA starts and pass it via `WAHA_NOWEB_WA_VERSION` -
no need to wait for a new WAHA release.

It's safe by design: WAHA uses the fetched version only if it's **higher** than the built-in one,
so a failed or stale fetch simply falls back to the built-in version.

{{< details "Auto-update WhatsApp Web Version - Setup" >}}

Save the script as `fetch-wa-version.js` - it prints the latest WhatsApp Web version (like `2.3000.1234567890`) to stdout,
or prints nothing and exits with code `1` on failure, so WAHA falls back to the built-in version.

Two versions of the script - fetching the version from **WhatsApp Web** directly (recommended)
or from the latest **Baileys** sources on GitHub:

{{< tabs "noweb-fetch-wa-version" >}}

{{< tab "WhatsApp Web" >}}
```js {title="fetch-wa-version.js"}
// Prints the latest WhatsApp Web version (e.g. "2.3000.1234567890") to stdout.
// Prints nothing and exits 1 on failure, so WAHA falls back to the built-in version.
const HEADERS = {
  'sec-fetch-site': 'none',
  'user-agent':
    'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36',
};

async function main() {
  const response = await fetch('https://web.whatsapp.com/sw.js', {
    headers: HEADERS,
    signal: AbortSignal.timeout(15_000),
  });
  if (!response.ok) {
    throw new Error(`HTTP ${response.status}`);
  }
  const text = await response.text();
  const match = text.match(/\\?"client_revision\\?":\s*(\d+)/);
  if (!match) {
    throw new Error('client_revision not found in sw.js');
  }
  console.log(`2.3000.${match[1]}`);
}

main().catch((err) => {
  console.error(`Could not fetch the latest WhatsApp Web version: ${err}`);
  process.exit(1);
});
```
{{< /tab >}}

{{< tab "Baileys" >}}
```js {title="fetch-wa-version.js"}
// Prints the WhatsApp Web version pinned in the latest Baileys sources (e.g. "2.3000.1234567890") to stdout.
// Prints nothing and exits 1 on failure, so WAHA falls back to the built-in version.
const URL = 'https://raw.githubusercontent.com/WhiskeySockets/Baileys/master/src/Defaults/index.ts';

async function main() {
  const response = await fetch(URL, { signal: AbortSignal.timeout(15_000) });
  if (!response.ok) {
    throw new Error(`HTTP ${response.status}`);
  }
  const text = await response.text();
  const match = text.match(/const version = \[(\d+),\s*(\d+),\s*(\d+)\]/);
  if (!match) {
    throw new Error('version not found in Defaults/index.ts');
  }
  console.log(`${match[1]}.${match[2]}.${match[3]}`);
}

main().catch((err) => {
  console.error(`Could not fetch the latest WhatsApp Web version: ${err}`);
  process.exit(1);
});
```
{{< /tab >}}

{{< /tabs >}}

**Option 1 - docker-compose (no image build)**

Mount the script and wrap the original entrypoint - the version is resolved once per container start:

```yaml {title="docker-compose.yaml"}
services:
  waha:
    image: devlikeapro/waha
    volumes:
      - ./fetch-wa-version.js:/fetch-wa-version.js:ro
    entrypoint:
      - /usr/bin/tini
      - --
      - /bin/sh
      - -c
      - |
        export WAHA_NOWEB_WA_VERSION="$${WAHA_NOWEB_WA_VERSION:-$$(node /fetch-wa-version.js)}"
        exec /entrypoint.sh
```

👉 Note the `$$` - Docker Compose interpolates single `${...}` itself, so the dollars must be doubled to reach the shell.

**Option 2 - your own image on top of WAHA**

```dockerfile {title="Dockerfile"}
FROM devlikeapro/waha:latest
COPY fetch-wa-version.js /fetch-wa-version.js
# Original ENTRYPOINT ["/usr/bin/tini", "--"] is inherited - only the CMD changes
CMD ["/bin/sh", "-c", "export WAHA_NOWEB_WA_VERSION=\"${WAHA_NOWEB_WA_VERSION:-$(node /fetch-wa-version.js)}\"; exec /entrypoint.sh"]
```

A few things to keep in mind:
- If you set `WAHA_NOWEB_WA_VERSION` explicitly - it wins over the fetched one (thanks to `:-` in the wrapper).
- The version is resolved **once per container start** - restart the container to pick up a newer version.
- The fetch URL must be reachable from the container at startup - otherwise WAHA uses the built-in version.

{{< /details >}}

</div>

{{< /callout >}}
