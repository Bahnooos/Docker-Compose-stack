FROM docker:cli

RUN apk add --no-cache bash

WORKDIR /scripts

COPY log-summary.sh .

RUN chmod +x log-summary.sh

CMD [ "bash" , "log-summary.sh" ]