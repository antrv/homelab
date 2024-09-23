FROM opensuse/leap:15.6

ARG username=opensuse
ARG password=opensuse
ARG kasmvncserver_version=1.3.1

WORKDIR /root

RUN zypper refresh \
    && zypper update -y \
    && zypper install -y mc nano sudo wget git python3 bash \
                      openssh iputils iproute2 \
                      zsh btop bat bat-zsh-completion fzf fzf-zsh-completion \
                      patterns-xfce-xfce_basis xfce4-terminal openSUSE-xfce-icon-theme firefox xorg-x11-fonts \
                      scout scout-command-not-found \
                      openssl libgomp1 libxkbcommon-x11-0 x11-tools dbus-1-x11 xauth hostname \
                      perl-DateTime perl-DateTime-TimeZone perl-Hash-Merge-Simple perl-List-MoreUtils perl-Scalar-List-Utils perl-Switch perl-Try-Tiny perl-YAML-Tiny \
    && wget https://github.com/kasmtech/KasmVNC/releases/download/v${kasmvncserver_version}/kasmvncserver_opensuse_15_${kasmvncserver_version}_x86_64.rpm \
    && rpm -ivh ./kasmvncserver_opensuse_15_${kasmvncserver_version}_x86_64.rpm \
    && rm ./kasmvncserver_opensuse_15_${kasmvncserver_version}_x86_64.rpm \
    && useradd -m -d /home/${username} -s /bin/bash -g users -G kasmvnc-cert ${username} && echo -e "${username}\n${password}" | passwd ${username} \
    && echo '${username} ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && echo -e "Port 6081" >> /etc/ssh/sshd_config \
    && ssh-keygen -A \
    && /usr/sbin/sshd \
    && echo -e '#!/bin/bash' > /entry.sh \
    && echo -e 'ls .X99-lock >> /dev/null 2>&1 && rm -rf /tmp/.X99-lock' >> /entry.sh \
    && echo $"echo -e '1\n' | /usr/bin/vncserver :99 -SecurityTypes=None" >> /entry.sh \
    && echo cat >> /entry.sh

USER ${username}

RUN mkdir -p /home/${username}/.vnc \
    && echo -e "${username}\n${password}\n" | vncpasswd -u ${username} -rwo \
    && echo 'SecurityTypes=None' | tee -a /home/${username}/.vnc/config

# Install oh-my-zsh
#RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#RUN sed 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' -i /home/alpine/.zshrc \
#    && sed 's/plugins=(git)/plugins=(git colorize colored-man-pages fzf zoxide zsh-interactive-cd)/' -i /home/alpine/.zshrc \
#    && echo -e "export LANG=ru_RU.UTF-8\nalias ls='eza --icons'\nalias ll='eza --long --icons --header --git'" >> /home/alpine/.zshrc

EXPOSE 6800-6801/tcp

ENTRYPOINT ["/bin/bash", "/entry.sh"]
