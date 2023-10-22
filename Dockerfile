FROM summerwind/actions-runner-dind:latest

WORKDIR /tmp
ENV HELPER_SCRIPTS=/tmp/virtual-environments/images/linux/scripts/helpers

RUN sudo apt update -y \
  && sudo apt install git -y \
  && git clone https://github.com/actions/virtual-environments.git \
  && cd virtual-environments/images/linux/scripts/base && sudo -E bash repos.sh && bash apt.sh \
  && cd ../helpers && sed -i 's/.*imagegeneration\/installers\/toolset.json.*/    echo \"\/tmp\/virtual-environments\/images\/linux\/toolsets\/toolset-2004.json\"/' *.sh \
  && cd ../installers && sed -i '/invoke_tests/d' *.sh 

WORKDIR /tmp/virtual-environments/images/linux/scripts/installers

RUN sudo -E bash basic.sh \
  && bash azure-cli.sh \
  && sudo wget -q https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -O /tmp/awscliv2.zip \
  && sudo unzip -qq /tmp/awscliv2.zip -d /tmp \
  && sudo /tmp/aws/install -i /usr/local/aws-cli -b /usr/local/bin \
  && sudo -E bash docker-compose.sh  \
  && sudo -E bash kubernetes-tools.sh \
  && sudo -E bash packer.sh \
  && sudo -E bash java-tools.sh \
  && sudo -E bash sbt.sh \
  && sudo -E bash azcopy.sh \
  && sudo -E bash terraform.sh \ 
#  && sudo rm -rf /tmp/* && sudo apt autoremove && sudo apt clean && sudo rm -rf /var/lib/apt/lists/*
