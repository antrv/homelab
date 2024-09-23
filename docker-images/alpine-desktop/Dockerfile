FROM alpine:3.20

RUN apk add --no-cache mc nano sudo wget git xfce4 xfce4-terminal faenza-icon-theme bash python3 tigervnc \
            zsh zoxide zellij btop bat wget eza fzf fzf-zsh-plugin zsh-autosuggestions zsh-completions \
            zsh-history-substring-search zsh-syntax-highlighting zsh-vcs font-meslo-nerd \
            firefox openssh openrc \
    && adduser -h /home/alpine -s /bin/zsh -S -D alpine && echo -e "alpine\nalpine" | passwd alpine \
    && echo 'alpine ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && git clone --depth=1 https://github.com/novnc/noVNC /opt/noVNC \
    && git clone --depth=1 https://github.com/novnc/websockify /opt/noVNC/utils/websockify

RUN echo -e "Port 6081" >> /etc/ssh/sshd_config \
    && ssh-keygen -A \
    && rc-update add sshd \
    && rc-status \
    && touch /run/openrc/softlevel

RUN echo $'\0#!/bin/bash\n\
ls .X99-lock >> /dev/null 2>&1 && rm -rf /tmp/.X99-lock\n\
sudo service sshd restart\n\
/usr/bin/vncserver :99 2>&1 | sed  "s/^/[Xtigervnc ] /" &\n\
/opt/noVNC/utils/novnc_proxy --vnc localhost:5999 2>&1 | sed "s/^/[noVNC     ] /"'\
    > /entry.sh

USER alpine

RUN mkdir -p /home/alpine/.vnc \
    && echo "SecurityTypes=None" | tee -a /home/alpine/.vnc/config \
    && echo -e "#!/bin/bash\nstartxfce4 &" | tee -a /home/alpine/.vnc/xstartup
    
# Install oh-my-zsh
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN sed 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' -i /home/alpine/.zshrc \
    && sed 's/plugins=(git)/plugins=(git colorize colored-man-pages fzf zoxide zsh-interactive-cd)/' -i /home/alpine/.zshrc \
    && echo -e "export LANG=ru_RU.UTF-8\nalias ls='eza --icons'\nalias ll='eza --long --icons --header --git'" >> /home/alpine/.zshrc

EXPOSE 6800-6801/tcp

ENTRYPOINT ["/bin/bash", "/entry.sh"]
