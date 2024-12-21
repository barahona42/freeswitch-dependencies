FROM alpine:latest AS gopkg
ARG TARGETPLATFORM
RUN apk update && apk add tar
WORKDIR /tmp
ADD https://go.dev/dl/go1.23.4.linux-amd64.tar.gz ${TARGETPLATFORM}/go.tar.gz
ADD https://go.dev/dl/go1.23.4.linux-arm64.tar.gz ${TARGETPLATFORM}/go.tar.gz
RUN tar -xzf ${TARGETPLATFORM}/go.tar.gz

FROM public.ecr.aws/docker/library/rockylinux:8.9
COPY --from=gopkg /tmp/go /usr/local
RUN dnf update -y
RUN dnf install -y bash diffutils patch wget ncurses

# RUN dnf install -y gcc rpm-build rpm-devel rpmlint make bash diffutils patch rpmdevtools git-all man wget
# RUN cp /usr/share/git-core/contrib/completion/git-prompt.sh /etc/profile.d/
# ADD ./customizations.sh /etc/profile.d/customizations.sh