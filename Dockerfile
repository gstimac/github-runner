FROM summerwind/actions-runner-dind:latest

WORKDIR /tmp
ENV HELPER_SCRIPTS=/tmp/virtual-environments/images/linux/scripts/helpers

RUN sudo apt update -y \
  && sudo apt install git -y \
  && sudo rm -rf /var/lib/apt/lists/* \
  && git clone https://github.com/actions/virtual-environments.git \
  && cd virtual-environments/images/linux/scripts/base && sudo -E bash repos.sh \
  && cd ../helpers && sed -i 's/.*imagegeneration\/installers\/toolset.json.*/    echo \"\/tmp\/virtual-environments\/images\/linux\/toolsets\/toolset-2004.json\"/' *.sh \
  && cd ../installers && sed -i '/invoke_tests/d' *.sh \
  && sudo -E bash basic.sh \
  && sudo -E bash azure-cli.sh \
  && sudo -E bash docker-compose.sh \
  && sudo -E bash kubernetes-tools.sh \
  && sudo -E bash packer.sh \
  && sudo -E bash java-tools.sh \ 
  && sudo -E bash sbt.sh \
  && sudo -E bash azcopy.sh \
  && sudo -E bash terraform.sh \
  && sudo apt autoremove -y && rm -rf /tmp/virtual-environments && sudo apt clean