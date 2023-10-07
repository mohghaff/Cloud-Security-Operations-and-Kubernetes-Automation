The materials used in this project were provided in the course Kubernetes: Your First Project by Carlos Nunez on LinkedIn Learning.

AssumedRolePolicy for IAM User
To create a policy named AssumedRolePolicy for an IAM user, follow these steps:

Log in to the AWS Management Console using your IAM user credentials.

Navigate to the IAM dashboard.

In the left-hand navigation pane, click on "Policies."

Click the "Create policy" button.

Choose the "JSON" tab to create a custom policy.

Enter the following JSON policy document:

json
Copy code
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sts:AssumeRole"
      ],
      "Resource": "*"
    }
  ]
}
Review the policy and give it a name, such as AssumedRolePolicy.

Click the "Create policy" button to create the policy.

Creating a New Role with Admin Access
To create a new role with admin access, use the AWS Management Console or the AWS CLI. Here are the steps using the AWS CLI:

Open your terminal.

Run the following AWS CLI command to create a new IAM role with admin access. Replace <role-name> with your desired role name.

bash
Copy code
aws iam create-role --role-name <role-name> --assume-role-policy-document file://AssumedRolePolicy.json
Verify that the role has been created successfully.
Dockerfile for Nginx
To create a Dockerfile for Nginx, follow these steps:

Create a new file named Dockerfile (without any file extension) in your project directory.

Add the following content to the Dockerfile:

Dockerfile
Copy code
# Use an official Nginx runtime as a parent image
FROM nginx

# Copy your application's code to the container
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80
Save the Dockerfile.
Building a Docker Image
To build a Docker image from the Dockerfile, follow these steps:

Open your terminal.

Navigate to the directory where your Dockerfile is located.

Run the following Docker command to build the image. Replace <image-name> with your desired image name and tag.

bash
Copy code
docker build -t <image-name>:<tag> .
Wait for the build process to complete.
Creating a Docker Container
To create a Docker container from the image, follow these steps:

Run the following Docker command to create and start a container from the image. Replace <container-name> with your desired container name and <image-name>:<tag> with the image name and tag you used during the build.
bash
Copy code
docker run -d --name <container-name> -p <host-port>:<container-port> <image-name>:<tag>
<host-port> is the port on your host machine that will be mapped to the container's port.
<container-port> is the port on which your application runs inside the container.
Your Docker container is now running.
Creating a Makefile
Here is a Makefile with various targets for managing your Docker and Kubernetes tasks:

Makefile
Copy code
.PHONY: run_website stop_website install_kind create_kind_cluster create_docker_registry \
connect_registry_to_kind_network connect_registry_to_kind delete_kind_cluster delete_docker_registry

run_website:
    docker build -t explorecalifornia.com . && \
    docker run --rm --name explorecalifornia.com -p 5000:80 -d explorecalifornia.com

stop_website:
    docker stop explorecalifornia.com

install_kind:
    Invoke-WebRequest -Uri 'https://github.com/kubernetes-sigs/kind/releases/download/v0.20.0/kind-windows-amd64' -OutFile './kind.exe'

create_kind_cluster: install_kind create_docker_registry
    kind create cluster --name explorecalifornia.com --config ./kind_config.yaml || true && \
    kubectl get nodes

create_docker_registry:
    @if docker ps | grep -q 'local-registry'; then \
        echo "local-registry already created"; \
    else \
        docker run --name local-registry -d --restart=always -p 5001:5001 registry:2; \
    fi

connect_registry_to_kind_network:
    docker network connect kind local-registry || true

connect_registry_to_kind: connect_registry_to_kind_network
    kubectl apply -f ./kind_configmap.yaml

delete_kind_cluster:
    kind delete cluster --name explorecalifornia.com

delete_docker_registry:
    docker stop local-registry ; docker rm local-registry
This Makefile includes targets for running and stopping a website in a Docker container, installing kind (Kubernetes in Docker), creating a Kubernetes cluster, managing a Docker registry, and connecting it to a Kubernetes cluster. Make sure to adjust the file paths and settings according to your project structure and requirements.

Creating a Kubectl Deployment
To create a Kubernetes deployment using kubectl, follow these steps:

Run the following kubectl command to create a deployment. This command generates a YAML file for the deployment configuration:
bash
Copy code
kubectl create deployment --dry-run=client --image localhost:5000/explorecalifornia explorcalifornia.com --output=yaml > deployment.yaml
The deployment.yaml file now contains the deployment configuration, including the image to use.

You can apply this deployment configuration to your Kubernetes cluster using the kubectl apply command:

bash
Copy code
kubectl apply -f deployment.yaml
Ensure that the image URL (localhost:5000/explorecalifornia) is correctly configured in the deployment.yaml file to match your Docker image repository. Adjust other deployment settings as needed.

This documentation provides step-by-step instructions for various tasks related to IAM policies, Docker, Kubernetes, and Makefile management. Make sure to adapt these instructions to your specific project requirements and configurations.