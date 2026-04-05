# How to copy paru from an image
# ------------------------------
#
# To a local file system:
#
# ```shell
# docker run --rm ghcr.io/masnagam/setup/paru cat /usr/bin/paru >/usr/bin/paru
# chmod +x /usr/bin/paru
#```
#
# To another image:
#
# ```Dockerfile
# COPY --from=masnagam/paru /usr/bin/paru /usr/bin/paru
# ```
#
# Install required packages before running `paru` extracted from the image.

FROM archlinux AS build
RUN --mount=type=bind,source=paru.sh,target=/paru.sh sh -x /paru.sh

FROM busybox
COPY --from=build /usr/bin/paru /usr/bin/paru
