# iso_gen_minimal

Minimal code to build Ubuntu Focal bottable ISO with installed cloud-init.

Modify files/packages_install.sh for additional packages installed into iso image

Create isogen docker image

build_iso_gen.sh

Modify cloud-init config files in "data" for actions after boot system from iso image

build_ephemeral_iso.sh

Get ephemeral.iso from "data"

Default hostname - "ubuntu-live"
You should set different name via cloud-init to clarify boot process.

If cloud-init fails for some reasons you see prompt "ubuntu-live", else you see hostname.

User to debug 

devusr:r00tme

Can be changed, removed via /files/packages_install.sh
