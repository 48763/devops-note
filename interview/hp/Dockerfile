FROM node:8.11.1-alpine

WORKDIR /usr/app/file

COPY src .

RUN set -x \
	& apk update \
	&& apk add curl \
	&& npm config set registry http://registry.npmjs.org/ \
	&& npm install 

CMD [ "npm", "run", "server" ]
