FROM kasmweb/core-ubuntu-noble:1.16.0
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########


RUN apt-get update

RUN mkdir -p /opt/orcaSlicer \
    && cd /opt/orcaSlicer \
    && add-apt-repository universe \
    && apt install -y \
        libfuse2 \
        libwebkit2gtk-4.1-0 \
        gstreamer1.0-libav \
        gstreamer1.0-plugins-bad \
        libtiff6 \
        unzip \
        jq \
    && APPIMAGE_URL=$(curl -fsSL https://api.github.com/repos/SoftFever/OrcaSlicer/releases/latest | \
        jq -r '.assets[] | select(.name | test("Ubuntu2404.*\\.AppImage$")) | .browser_download_url') \
    && wget "$APPIMAGE_URL" \
    && chmod +x *.AppImage \
    && ./*.AppImage --appimage-extract \
    && rm *.AppImage \
    && mv squashfs-root/* . \
    && rm -rf squashfs-root/ \
    && chown 1000:1000 -R /opt/orcaSlicer

# Set this so that Orca Slicer doesn't complain about
# the CA cert path on every startup
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

COPY custom_startup.sh $STARTUPDIR/custom_startup.sh
RUN chmod +x $STARTUPDIR/custom_startup.sh
RUN chmod 755 $STARTUPDIR/custom_startup.sh


# Update the desktop environment to be optimized for a single application
RUN cp $HOME/.config/xfce4/xfconf/single-application-xfce-perchannel-xml/* $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/
RUN apt-get remove -y xfce4-panel

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000