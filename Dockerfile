FROM alpine/git:2.40.1

LABEL "com.github.actions.name"="Create an incremental tag"
LABEL "com.github.actions.description"="Create an incremental tag under your conditions"
LABEL "com.github.actions.icon"="tag"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="https://github.com/B2BInternetSolutions/b2b--gh-action--increment-repo-version-tag"
LABEL "homepage"="https://github.com/B2BInternetSolutions/b2b--gh-action--increment-repo-version-tag"
LABEL "maintainer"="Mike Owen <mike.owen@b2binternetsolutions.co.uk>"

RUN apk add coreutils

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["sh", "/entrypoint.sh"]