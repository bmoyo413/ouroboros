#!/bin/sh
# # Adapted from community-scripts ProxmoxVE post-pve-install.sh (same NoMoreNagging patch)

# Hide the Proxmox VE "No valid subscription" popup.

js=/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
old="res.data.status.toLowerCase() !== 'active'" # Is status not equal to active (Yes) = Show the popup
new="res.data.status.toLowerCase() === 'NoMoreNagging'" # Is status equal to NoMoreNagging (No) = Dont show the popup
# # if the file is missing or empty print a warning and exit
[ -s "$js" ] || { echo "pve-remove-nag: $js not found, skipped" >&2; exit 0; }
# find the new line in the file if found exit
grep -qF "$new" "$js" && exit 0
# if the old line is not found under the file then continue
if ! grep -qF "$old" "$js"; then
# print warning and stop 
  echo "pve-remove-nag: popup check not found in $js, upstream changed it" >&2
  exit 0
fi

sed -i "s/$old/$new/" "$js"
echo patched
