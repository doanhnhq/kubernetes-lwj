FROM node:10.16.1-alpine

RUN echo "http://mirrors.tuna.tsinghua.edu.cn/alpine/v3.9/main" > /etc/apk/repositories \
    && echo "http://mirrors.tuna.tsinghua.edu.cn/alpine/v3.9/community" >> /etc/apk/repositories \
    && apk --update --no-cache add tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && echo apk del tzdatda \