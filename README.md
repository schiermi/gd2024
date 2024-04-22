# Prepare env

    wget https://releases.hashicorp.com/terraform/1.8.1/terraform_1.8.1_linux_amd64.zip
    unzip terraform_1.8.1_linux_amd64.zip
    rm terraform_1.8.1_linux_amd64.zip
    alias terraform="$PWD/terraform"
    alias aws='podman run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/aws public.ecr.aws/aws-cli/aws-cli'
    export TF_VAR_dnszone="…"

# URLs

    # Read counter
    curl https://www.girlsday.${TF_VAR_dnszone}/counter.php
    # Increment counter
    curl https://www.girlsday.${TF_VAR_dnszone}/counter.php?action=increment
    # Decrement counter
    curl https://www.girlsday.${TF_VAR_dnszone}/counter.php?action=decrement
    # SSE
    curl https://www.girlsday.${TF_VAR_dnszone}/counter.php?action=events
    # Browser
    https://www.girlsday.${TF_VAR_dnszone}/
