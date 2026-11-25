<h1 align="center">ouroboros</h1>

<p align="center">
  <img alt="Proxmox VE 9" src="https://img.shields.io/badge/Proxmox_VE-9-b2ed91?logo=proxmox&style=for-the-badge&labelColor=1d2526&logoColor=b2ed91">
  <img alt="Ansible: host prep" src="https://img.shields.io/badge/Ansible-host_prep-b2ed91?logo=ansible&style=for-the-badge&labelColor=1d2526&logoColor=b2ed91">
  <img alt="Status: under construction" src="https://img.shields.io/badge/status-under_construction-e5c07b?style=for-the-badge&labelColor=1d2526">
</p>

<p align="center">
  <a href="#quick-start">Quick start</a> ·
  <a href="#what-it-does">What it does</a> ·
  <a href="#files">Files</a> ·
  <a href="#whats-next">What's next</a>
</p>

> [!WARNING]
> **Under construction.** The lab is mid-rebuild and this repo fills in as it goes. Only the Proxmox host prep
> for node 2 is done so far.

The plan is to wipe the lab and rebuild it from this repo every month, so anything I fix by hand and forget to write
down here gets eaten on the next lap. The repo is the only source of truth, because it is the only thing that survives.

## Quick start

```sh
cd ansible
cp inventory/hosts.example.yml inventory/hosts.yml   # fill in the real values
ansible-playbook playbooks/proxmox-hosts.yml --limit node2 --check --diff   # dry run first
ansible-playbook playbooks/proxmox-hosts.yml --limit node2
```

Real hostnames and IPs only go in `hosts.yml`, which is gitignored. Everything in the repo is a placeholder.

## What it does

`pve_post_install` takes a fresh Proxmox VE 9 node and sets it up to run without a subscription. Rewritten from the
community-scripts "PVE Post Install" script, keeping only what this lab needs.

- **Checks the host first.** Stops unless it is Proxmox VE on Debian trixie.
- **Free package sources.** Swaps the enterprise sources for the no-subscription ones (PVE and Ceph).
- **No subscription popup.** Hides it, and leaves an apt hook that hides it again after every update.
- **Full upgrade.** Runs a dist-upgrade.
- **Reboots only when needed.** Only if the upgrade installed a newer kernel than the one running.

Left out on purpose: the high-availability toggles (the nodes join a cluster), the mobile UI patch, and the test
repository. Every step is a switch in `defaults/main.yml`.

Ran on node 2. The second run changed nothing.

## Files

| File | Purpose |
|------|---------|
| [`ansible/ansible.cfg`](ansible/ansible.cfg) | Inventory path, roles path, SSH pipelining |
| [`ansible/inventory/hosts.example.yml`](ansible/inventory/hosts.example.yml) | Template for the real inventory (`hosts.yml`, gitignored) |
| [`ansible/playbooks/proxmox-hosts.yml`](ansible/playbooks/proxmox-hosts.yml) | Host prep for a freshly installed Proxmox VE node |
| [`ansible/roles/pve_post_install/`](ansible/roles/pve_post_install/) | The role above: tasks, defaults, handler, and the popup patch script |

## What's next

**An admin user.** A new role, `admin_user`, creates a non-root admin account on each node with key-based SSH and
passwordless sudo.

---

<p align="center"><i>The snake that eats its own tail: a homelab that gets torn down and grows back from its own code.</i></p>
