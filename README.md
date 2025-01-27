# Craftista - The Ultimate DevOps Learning App

Welcome to **Craftista**! This is a DevOps-focused project forked from the original [Craftista repository](https://github.com/craftista/craftista). The repository showcases microservices for an art showcase application, and the goal here is to provide a practical learning experience for various DevOps practices such as Docker, Docker Compose, Terraform, and Kubernetes.

## Project Overview

This project is designed to help you learn and experiment with the following DevOps technologies:

- **Docker**: Containerizing microservices for isolation and ease of deployment.
- **Docker Compose**: Managing multi-container Docker applications.
- **Terraform**: Writing Infrastructure as Code (IaC) to automate infrastructure provisioning.
- **Kubernetes**: Deploying the application on a Kubernetes cluster.

The original project contains multiple microservices for an art showcase app. In this fork, I have made the following changes for educational purposes:

1. **Dockerization**: Each microservice now has a corresponding `Dockerfile` to build its respective image.
2. **Docker Compose**: A `docker-compose.yaml` file is added to bring up all services with a single command, automatically configuring the necessary containers.
3. **Infrastructure as Code (IaC)**: I used **Terraform** to define the infrastructure, which deploys this app on Kubernetes.

## Repository Structure

Here’s a breakdown of the repository structure:

```
├── docker-compose.yaml       # Docker Compose file to start all services
├── terraform/                # Directory containing all Terraform infrastructure code
│   ├── catalog.tf            # Terraform script for the catalog service
│   ├── frontend.tf           # Terraform script for the frontend service
│   ├── recommendation.tf     # Terraform script for the recommendation service
│   ├── voting.tf             # Terraform script for the voting service
│   └── ...                   # Other Terraform configurations
├── catalogue/                # Directory containing catalogue service (Dockerfiles included)
├── frontend/                 # Directory containing frontend service (Dockerfiles included)
├── recommendation/           # Directory containing recommendation service (Dockerfiles included)
├── voting/                   # Directory containing voting service (Dockerfiles included)
├── README.md                 # This file
└── ...                       # Other app files
```

### Key Components

1. **Dockerfiles**: Each microservice in the app has a `Dockerfile` to containerize it. These are located within the respective microservice directories.

2. **docker-compose.yaml**: This file is placed in the root directory and allows you to spin up all services with a single command:
   ```bash
   docker-compose up
   ```
   It automatically configures and connects all the containers, making it easier to run the entire application locally.

3. **Terraform**: The `terraform` directory contains all the code needed to deploy the app to a Kubernetes cluster. It includes configurations for each service (e.g., `catalog.tf`, `frontend.tf`, etc.). 
   - For local testing, I’ve used **MicroK8s** and its local registry (`localhost:32000`) to host the built images. 
   - To run this on your own Kubernetes setup, you need to either push the images to your Kubernetes registry or update the image references in the Terraform files (like `catalog.tf`, `frontend.tf`, etc.).

### Kubernetes Setup

The Terraform configurations are designed to deploy the app to a Kubernetes cluster. However, you need to adjust the image registry settings to match your environment.

1. **Local Registry (MicroK8s)**: If you are using **MicroK8s**, the images are pushed to `localhost:32000`. The `catalog.tf`, `frontend.tf`, `recommendation.tf`, and `voting.tf` files are set to pull from this local registry.

2. **Custom Kubernetes Setup**: 
   - If you are using a different Kubernetes setup, you need to either:
     - Push the Docker images to your own registry, or
     - Modify the image references in the Terraform files to point to your own registry.

### Running Locally with Docker Compose

To get started with running the application locally using Docker Compose:

1. **Build the Docker images**:
   ```bash
   docker-compose build
   ```

2. **Start the services**:
   ```bash
   docker-compose up
   ```

This will launch all the services in their respective containers. The application will be accessible at the configured ports for each microservice.

### Deploying on Kubernetes

1. **Set up your Kubernetes cluster** (using Minikube, MicroK8s, or any other setup).
2. **Update the image registry** (if needed).
3. **Deploy the infrastructure using Terraform**:
   ```bash
   cd terraform
   terraform init
   terraform apply
   ```

This will provision the necessary Kubernetes resources and deploy the services to your cluster.

## Prerequisites

- Docker
- Docker Compose
- Kubernetes (Minikube, MicroK8s, or another Kubernetes setup)
- Terraform
- A Kubernetes registry (either a local or cloud-based one)

## Learn More

This repository is a great starting point for learning about containerization, Kubernetes, and Infrastructure as Code (IaC) with Terraform. You can experiment with:

- Customizing the microservices
- Modifying the Terraform scripts to deploy the app to a cloud provider
- Integrating CI/CD pipelines with Docker, Kubernetes, and Terraform

---

Feel free to fork this repository and experiment with the code! If you have any questions or suggestions, please open an issue or create a pull request.

Happy learning! 🚀