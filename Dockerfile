FROM node

ENV APP=/usr/src/app
ADD . $APP

WORKDIR $APP

RUN (cd backend; npm i) \
&&  (cd frontend; npm i; npm run build)

EXPOSE 3000

CMD cd backend && npm start
