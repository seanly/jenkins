ARG VARIANT="bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}


# [Option] Install zsh
ARG INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="false"
# [Option] Enable non-root Docker access in container
ARG ENABLE_NONROOT_DOCKER="true"
# [Option] Use the OSS Moby CLI instead of the licensed Docker CLI
ARG USE_MOBY="true"
# [Option] Select CLI version
ARG CLI_VERSION="latest"

# Enable new "BUILDKIT" mode for Docker CLI
ENV DOCKER_BUILDKIT=1

# Install needed packages and setup non-root user. Use a separate RUN statement to add your
# own dependencies. A user of "automatic" attempts to reuse an user ID if one already exists.
ARG USERNAME=automatic
ARG USER_UID=1000
ARG USER_GID=$USER_UID
COPY library-scripts/*.sh /tmp/library-scripts/
RUN apt-get update \
    && /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    # Use Docker script from script library to set things up
    && /bin/bash /tmp/library-scripts/docker-debian.sh "${ENABLE_NONROOT_DOCKER}" "/var/run/docker-host.sock" "/var/run/docker.sock" "${USERNAME}" "${USE_MOBY}" "${CLI_VERSION}" \
    # Clean up
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

# Setting the ENTRYPOINT to docker-init.sh will configure non-root access to 
# the Docker socket if "overrideCommand": false is set in devcontainer.json. 
# The script will also execute CMD if you need to alter startup behaviors.
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends neovim tig tmux tig zsh 

# tools
COPY --from=mikefarah/yq /usr/bin/yq /usr/bin/yq

# kubernetes
COPY --from=seanly/toolset:rke /usr/bin/rke /usr/bin/rke
COPY --from=seanly/toolset:helm /usr/bin/helm /usr/bin/helm
COPY --from=seanly/toolset:kustomize /usr/bin/kustomize /usr/bin/kustomize
COPY --from=seanly/toolset:kubectl /usr/bin/kubectl /usr/bin/kubectl
COPY --from=seanly/toolset:velero /usr/bin/velero /usr/bin/velero
COPY --from=seanly/toolset:krew /root/.krew ~/.krew
ENV PATH="${PATH}:~/.krew/bin"

ENV FZF_VERSION=0.38.0

RUN \
    ( \
    set -x; cd "$(mktemp -d)" && \
    OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && \
    FZF_URL=https://github.com/junegunn/fzf/releases/download/${FZF_VERSION}/fzf-${FZF_VERSION}-linux_${ARCH}.tar.gz && \
    curl -sLf ${FZF_URL} | tar -xzf - -C /usr/bin && \
    chmod +x /usr/bin/fzf \
    )

# vimrc
COPY --from=seanly/toolset:vimrc /package/vim/init.vim ~/.vimrc
RUN curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    ;mkdir -p ~/.config/nvim; ln -s ~/.vimrc ~/.config/nvim/init.vim\
    ;echo "alias vim=nvim" >> ~/.bashrc \
    ;echo "alias k=kubectl" >> ~/.bashrc \
    ;echo "alias vi=nvim" >> ~/.bashrc 
