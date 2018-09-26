FROM greyfoxit/alpine-openjdk8

# maintainer: Greyfox Team | team@greyfox.it | @greyfoxit

# Setup
ARG user=jenkins
ARG group=jenkins
ARG uid=10000
ARG gid=10000

ENV HOME /home/${user}
RUN addgroup -g ${gid} ${group}
RUN adduser -h $HOME -u ${uid} -G ${group} -D ${user}

ENV VERSION_SDK_TOOLS=3952940 \
	  ANDROID_HOME=/usr/local/android-sdk-linux

ENV	PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

RUN mkdir -p $ANDROID_HOME && \
    chown -R ${user}.${user} $ANDROID_HOME && \
# Install dependencies

apk add --no-cache bash curl git openssl openssh-client ca-certificates 
# Install Android SDK
USER ${user}
RUN cd /home/${user} && wget -q -O sdk.zip http://dl.google.com/android/repository/sdk-tools-linux-$VERSION_SDK_TOOLS.zip && \
unzip sdk.zip -d $ANDROID_HOME && \
rm -f sdk.zip

# Install and update Android packages

ADD packages.txt $ANDROID_HOME

RUN mkdir -p /home/${user}/.android && \
    touch /home/${user}/.android/repositories.cfg && \

sdkmanager --update && yes | sdkmanager --licenses && \
sdkmanager --package_file=$ANDROID_HOME/packages.txt
