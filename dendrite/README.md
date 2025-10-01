# Dendrite for Home Assistant

This is a Home Assistant add-on that runs the [Dendrite Matrix server](https://matrix.org/docs/projects/server/dendrite).

## Features
- Lightweight Matrix homeserver
- Works on Raspberry Pi 5 (aarch64) and x86_64
- Easy setup through HA UI

## Configuration
Options in the add-on UI:
- `server_name`: Your domain (e.g. `chat.myhomeserver.com`)
- `enable_registration`: Whether users can self-register
- `registration_shared_secret`: Secret for controlled registration

## Ports
- `8008` — Client API (for Element, etc.)
- `8448` — Federation (optional, needs DNS + TLS)

## Installation

1. Go to **Supervisor → Add-on Store** in Home Assistant.
2. Add this repo as a custom repository:
https://github.com/VGarK/ha-addons-dendrite

3. Install **Dendrite Matrix Server** from the add-on list.
4. Configure the add-on in the UI.

---

## ⚙️ Configuration Options

| Option | Description | Example |
|--------|-------------|---------|
| `server_name` | Your Matrix server domain (must match DNS) | `chat.example.com` |
| `enable_registration` | Allow new user signups | `true` |
| `registration_shared_secret` | Secret for generating accounts programmatically | `mysupersecret` |

---

## 🔑 Notes
- Ensure your domain (e.g. `chat.example.com`) points to your HA instance.
- Use a reverse proxy (like Nginx Proxy Manager) or Cloudflare to expose ports 8008/8448.
- Admin accounts can be created via the add-on logs/CLI (future helper planned).

---

## 🛠 Development

This repo builds Docker images automatically via GitHub Actions.  
Images are published to [GitHub Container Registry](https://ghcr.io).

ghcr.io/VGarK/ha-addons-dendrite/dendrite-{arch}:latest

yaml
Copy code

---

Enjoy Matrix in your smart home setup! 🚀


