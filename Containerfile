FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV QT_QPA_PLATFORM=offscreen

ENV UID=1000
ENV GID=1000

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
           apt-transport-https \
           ca-certificates \
           dirmngr \
           ghostscript \
           gnupg \
           gosu \
           make \
           perl \
           pandoc \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D6BC243565B2087BC3F897C9277A7293F59E4889 \
    && gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D6BC243565B2087BC3F897C9277A7293F59E4889 \
    && gpg --batch -o /usr/share/keyrings/miktex.gpg --export D6BC243565B2087BC3F897C9277A7293F59E4889 \
    && gpg --batch --delete-keys D6BC243565B2087BC3F897C9277A7293F59E4889 \
    && echo "deb [signed-by=/usr/share/keyrings/miktex.gpg] http://miktex.org/download/debian bullseye universe" | tee /etc/apt/sources.list.d/miktex.list \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends miktex \
    && miktexsetup --shared=yes finish \
    && initexmf --admin --set-config-value=[MPM]AutoInstall=1 \
    && miktex --admin --enable-installer packages update-package-database \
    && miktex --admin --enable-installer packages update \
    && miktex --admin --enable-installer packages install \
           amsfonts \
           mathtools \
           latex-tools \
           physics \
           braket \
           graphics \
           jsclasses \
           dvipdfmx \
           uplatex \
           uptex-base \
           uptex-fonts \
           ptex-fontmaps \
           haranoaji \
           cluttex \
           plautopatch \
           l3backend \
    && kanji-config-updmap-sys haranoaji \
    && miktex --admin --enable-installer fontmaps configure \
    && miktex --admin --enable-installer formats build uplatex \
    && miktex --admin --enable-installer fndb refresh \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -g $GID user \
    && useradd -s /bin/bash -u $UID -g $GID -md /home/user user

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
WORKDIR /workdir
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]