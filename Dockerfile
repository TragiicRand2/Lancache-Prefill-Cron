FROM tpill90/steam-lancache-prefill:latest

LABEL org.opencontainers.image.title "Steam Lancache Prefill cronjob"
LABEL org.opencontainers.image.authors TragiicRand2
LABEL org.opencontainers.image.description "Dockerized cronjob running the Steam Lancache prefilling tool, at container initial startup as well as at 4am and 12 Noon."
LABEL org.opencontainers.image.source https://github.com/TragiicRand2/Lancache-Prefill-Cron

ENV FILE=/etc/cron.d/prefill-cron

RUN set -x &&\
    apt update &&\
    apt install -qq -y cron

RUN touch ${FILE} &&\
    chmod 0644 ${FILE}

RUN echo "0 4,12 * * * /SteamPrefill prefill > /proc/1/fd/1 2>/proc/1/fd/2" >> ${FILE} &&\
    echo "@reboot /SteamPrefill prefill > /proc/1/fd/1 2>/proc/1/fd/2" >> ${FILE} &&\
    echo "# last line required for value cron file" >> ${FILE}

RUN crontab ${FILE}

ENTRYPOINT [ "cron", "-f", "-l", "1" ]
