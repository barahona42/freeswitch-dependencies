FROM public.ecr.aws/docker/library/rockylinux:8.9
RUN dnf update -y
RUN dnf install -y bash diffutils patch wget ncurses