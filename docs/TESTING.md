# RZ Community BSP Testing

## What's tested?

Whilst this project is provided on an as-is basis, effort is made to verify that
the supported build configurations work using a combination of GitLab CI, LAVA
and local testing.

Things that can be automated in the CI setup are done so for every merge
request.

All builds that are done in the CI setup have OPT\_DEBUG (kas/opt/debug.yml)
enabled in addition to the settings listed in the build/test matrix below.

### Test environment

Tests are run on each supported target using a
[LAVA](https://gitlab.com/lava/lava) environment. The Linux kernel and device
tree binaries are loaded in U-Boot using TFTP. Once booted into the kernel all
testing is done using network mounted filesystems (NFS).

### Test cases

**uname** \
Definition: [test-uname.yaml](../scripts/lava-templates/test-uname.yaml) \
A simple "boot" test that just checks that we can boot and log in successfully.

**sdk-hello** \
Definition: [test-sdk-hello.yaml](../scripts/lava-templates/test-sdk-hello.yaml) \
Tests that the `hello-test` application that was compiled using the
rz-community-bsp SDK runs successfully on the target.

### Pre-flight checks

In addition to any functional testing various checks are made on the code itself
before anything is merged.

#### yocto-check-layer

This script provides a way to assess how compatible a layer is with the Yocto
Project. More details about the script can be found in the [Yocto dev tasks manual]
(https://docs.yoctoproject.org/dev-manual/layers.html#yocto-check-layer-script).

## What's not tested?

Things that cannot be automated in the CI setup are tested manually much less
often. For example:

* Every U-Boot version
* Every TF-A version
* The Wayland/Weston display output in the demo image

Over time we hope to enhance CI support further.

## CI build/test matrix

The table below details every build combination that is currently run in CI.

| Yocto | Image | Kernel | U-Boot | TF-A | Machine | Test Cases |
| --- | --- | --- | --- | --- | --- | --- |
| Kirkstone | renesas-image-minimal | CIP SLTS v5.10 | Mainline v2023.10 | Mainline v2.9.0 | hihope-rzg2h | uname |
| Kirkstone | renesas-image-minimal | CIP SLTS v6.1 | Mainline v2023.10 | Mainline v2.9.0 | hihope-rzg2h | uname |
| Kirkstone | renesas-image-minimal (with SDK) | CIP SLTS v6.1 | Mainline v2023.10 | Mainline v2.9.0 | hihope-rzg2h | uname<br>sdk-hello |
| Kirkstone | renesas-image-minimal | Renesas BSP v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | hihope-rzg2h | uname |
| Kirkstone | renesas-image-minimal | CIP SLTS v5.10 | Mainline v2023.10 | Mainline v2.9.0 | hihope-rzg2m | uname |
| Kirkstone | renesas-image-minimal | CIP SLTS v6.1 | Mainline v2023.10 | Mainline v2.9.0 | hihope-rzg2m | uname |
| Kirkstone | renesas-image-minimal (with SDK) | CIP SLTS v6.1 | Mainline v2023.10 | Mainline v2.9.0 | hihope-rzg2m | uname<br>sdk-hello |
| Kirkstone | renesas-image-minimal | Renesas BSP v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | hihope-rzg2m | uname |
| Kirkstone | renesas-image-minimal | CIP SLTS v5.10 | Mainline v2023.10 | Mainline v2.9.0 | hihope-rzg2n | uname |
| Kirkstone | renesas-image-minimal | CIP SLTS v6.1 | Mainline v2023.10 | Mainline v2.9.0 | hihope-rzg2n | uname |
| Kirkstone | renesas-image-minimal (with SDK) | CIP SLTS v6.1 | Mainline v2023.10 | Mainline v2.9.0 | hihope-rzg2n | uname<br>sdk-hello |
| Kirkstone | renesas-image-minimal | Renesas BSP v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | hihope-rzg2n | uname |
| Kirkstone | renesas-image-minimal | CIP SLTS v5.10 | Mainline v2023.10 | Mainline v2.9.0 | ek874 | uname |
| Kirkstone | renesas-image-minimal | CIP SLTS v6.1 | Mainline v2023.10 | Mainline v2.9.0 | ek874 | uname |
| Kirkstone | renesas-image-minimal (with SDK) | CIP SLTS v6.1 | Mainline v2023.10 | Mainline v2.9.0 | ek874 | uname<br>sdk-hello |
| Kirkstone | renesas-image-minimal | Renesas BSP v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | ek874 | uname |
| Kirkstone | renesas-image-minimal | CIP SLTS v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2l | uname |
| Kirkstone | renesas-image-minimal | CIP SLTS v6.1 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2l | uname |
| Kirkstone | renesas-image-minimal (with SDK) | CIP SLTS v6.1 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2l | uname<br>sdk-hello |
| Kirkstone | renesas-image-minimal | Renesas BSP v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2l | uname |
| Kirkstone | renesas-image-minimal | CIP SLTS v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2lc | uname |
| Kirkstone | renesas-image-minimal | CIP SLTS v6.1 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2lc | uname |
| Kirkstone | renesas-image-minimal (with SDK) | CIP SLTS v6.1 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2lc | uname<br>sdk-hello |
| Kirkstone | renesas-image-minimal | Renesas BSP v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2lc | uname |
| Kirkstone | renesas-image-minimal | CIP SLTS v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2ul | uname |
| Kirkstone | renesas-image-minimal | CIP SLTS v6.1 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2ul | uname |
| Kirkstone | renesas-image-minimal (with SDK) | CIP SLTS v6.1 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2ul | uname<br>sdk-hello |
| Kirkstone | renesas-image-minimal | Renesas BSP v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2ul | uname |
| Kirkstone | renesas-image-minimal | CIP SLTS v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzv2l | uname |
| Kirkstone | renesas-image-minimal | CIP SLTS v6.1 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzv2l | uname |
| Kirkstone | renesas-image-minimal (with SDK) | CIP SLTS v6.1 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzv2l | uname<br>sdk-hello |
| Kirkstone | renesas-image-minimal | Renesas BSP v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzv2l | uname |
| Scarthgap | renesas-image-minimal | Mainline | Mainline v2023.10 | Mainline v2.9.0 | hihope-rzg2h | uname |
| Scarthgap | renesas-image-minimal | LTS v6.6 | Mainline v2023.10 | Mainline v2.9.0 | hihope-rzg2h | uname |
| Scarthgap | renesas-image-minimal | CIP SLTS v5.10 | Mainline v2023.10 | Mainline v2.9.0 | hihope-rzg2h | uname |
| Scarthgap | renesas-image-minimal | CIP SLTS v6.1 | Mainline v2023.10 | Mainline v2.9.0 | hihope-rzg2h | uname |
| Scarthgap | renesas-image-minimal (with SDK) | CIP SLTS v6.1 | Mainline v2023.10 | Mainline v2.9.0 | hihope-rzg2h | uname<br>sdk-hello |
| Scarthgap | renesas-image-minimal | Renesas BSP v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | hihope-rzg2h | uname |
| Scarthgap | renesas-image-minimal | Mainline | Mainline v2023.10 | Mainline v2.9.0 | hihope-rzg2m | uname |
| Scarthgap | renesas-image-minimal | LTS v6.6 | Mainline v2023.10 | Mainline v2.9.0 | hihope-rzg2m | uname |
| Scarthgap | renesas-image-minimal | CIP SLTS v5.10 | Mainline v2023.10 | Mainline v2.9.0 | hihope-rzg2m | uname |
| Scarthgap | renesas-image-minimal | CIP SLTS v6.1 | Mainline v2023.10 | Mainline v2.9.0 | hihope-rzg2m | uname |
| Scarthgap | renesas-image-minimal (with SDK) | CIP SLTS v6.1 | Mainline v2023.10 | Mainline v2.9.0 | hihope-rzg2m | uname<br>sdk-hello |
| Scarthgap | renesas-image-minimal | Renesas BSP v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | hihope-rzg2m | uname |
| Scarthgap | renesas-image-minimal | Mainline | Mainline v2023.10 | Mainline v2.9.0 | hihope-rzg2n | uname |
| Scarthgap | renesas-image-minimal | LTS v6.6 | Mainline v2023.10 | Mainline v2.9.0 | hihope-rzg2n | uname |
| Scarthgap | renesas-image-minimal | CIP SLTS v5.10 | Mainline v2023.10 | Mainline v2.9.0 | hihope-rzg2n | uname |
| Scarthgap | renesas-image-minimal | CIP SLTS v6.1 | Mainline v2023.10 | Mainline v2.9.0 | hihope-rzg2n | uname |
| Scarthgap | renesas-image-minimal (with SDK) | CIP SLTS v6.1 | Mainline v2023.10 | Mainline v2.9.0 | hihope-rzg2n | uname<br>sdk-hello |
| Scarthgap | renesas-image-minimal | Renesas BSP v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | hihope-rzg2n | uname |
| Scarthgap | renesas-image-minimal | Mainline | Mainline v2023.10 | Mainline v2.9.0 | ek874 | uname |
| Scarthgap | renesas-image-minimal | LTS v6.6 | Mainline v2023.10 | Mainline v2.9.0 | ek874 | uname |
| Scarthgap | renesas-image-minimal | CIP SLTS v5.10 | Mainline v2023.10 | Mainline v2.9.0 | ek874 | uname |
| Scarthgap | renesas-image-minimal | CIP SLTS v6.1 | Mainline v2023.10 | Mainline v2.9.0 | ek874 | uname |
| Scarthgap | renesas-image-minimal (with SDK) | CIP SLTS v6.1 | Mainline v2023.10 | Mainline v2.9.0 | ek874 | uname<br>sdk-hello |
| Scarthgap | renesas-image-minimal | Renesas BSP v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | ek874 | uname |
| Scarthgap | renesas-image-minimal | Mainline | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2l | uname |
| Scarthgap | renesas-image-minimal | LTS v6.6 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2l | uname |
| Scarthgap | renesas-image-minimal | CIP SLTS v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2l | uname |
| Scarthgap | renesas-image-minimal | CIP SLTS v6.1 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2l | uname |
| Scarthgap | renesas-image-minimal (with SDK) | CIP SLTS v6.1 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2l | uname<br>sdk-hello |
| Scarthgap | renesas-image-minimal | Renesas BSP v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2l | uname |
| Scarthgap | renesas-image-demo | Mainline | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2l | uname |
| Scarthgap | renesas-image-demo | LTS v6.6 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2l | uname |
| Scarthgap | renesas-image-demo | CIP SLTS v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2l | uname |
| Scarthgap | renesas-image-demo | CIP SLTS v6.1 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2l | uname |
| Scarthgap | renesas-image-demo | Renesas BSP v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2l | uname |
| Scarthgap | renesas-image-minimal | Mainline | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2lc | uname |
| Scarthgap | renesas-image-minimal | LTS v6.6 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2lc | uname |
| Scarthgap | renesas-image-minimal | CIP SLTS v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2lc | uname |
| Scarthgap | renesas-image-minimal | CIP SLTS v6.1 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2lc | uname |
| Scarthgap | renesas-image-minimal (with SDK) | CIP SLTS v6.1 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2lc | uname<br>sdk-hello |
| Scarthgap | renesas-image-minimal | Renesas BSP v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2lc | uname |
| Scarthgap | renesas-image-demo | Mainline | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2lc | uname |
| Scarthgap | renesas-image-demo | LTS v6.6 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2lc | uname |
| Scarthgap | renesas-image-demo | CIP SLTS v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2lc | uname |
| Scarthgap | renesas-image-demo | CIP SLTS v6.1 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2lc | uname |
| Scarthgap | renesas-image-demo | Renesas BSP v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2lc | uname |
| Scarthgap | renesas-image-minimal | Mainline | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2ul | uname |
| Scarthgap | renesas-image-minimal | LTS v6.6 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2ul | uname |
| Scarthgap | renesas-image-minimal | CIP SLTS v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2ul | uname |
| Scarthgap | renesas-image-minimal | CIP SLTS v6.1 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2ul | uname |
| Scarthgap | renesas-image-minimal (with SDK) | CIP SLTS v6.1 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2ul | uname<br>sdk-hello |
| Scarthgap | renesas-image-minimal | Renesas BSP v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzg2ul | uname |
| Scarthgap | renesas-image-minimal | Mainline | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzv2l | uname |
| Scarthgap | renesas-image-minimal | LTS v6.6 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzv2l | uname |
| Scarthgap | renesas-image-minimal | CIP SLTS v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzv2l | uname |
| Scarthgap | renesas-image-minimal | CIP SLTS v6.1 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzv2l | uname |
| Scarthgap | renesas-image-minimal (with SDK) | CIP SLTS v6.1 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzv2l | uname<br>sdk-hello |
| Scarthgap | renesas-image-minimal | Renesas BSP v5.10 | Renesas BSP v2021.10 | Renesas BSP v2.9.0 | smarc-rzv2l | uname |
