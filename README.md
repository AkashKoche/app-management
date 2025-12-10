🌟 Project Overview

The App Management System is a full-stack web application built on the Node.js/Express framework, designed to manage user applications and track associated events. The application utilizes MongoDB for persistent data storage, handling user authentication (via Passport) and complex event scheduling.

This repository demonstrates a complete, production-ready DevOps implementation, moving the application from a local development environment to a scalable, automated deployment on Google Cloud Platform (GCP).
🏛️ Architecture Design

The system is designed following a Cloud-Native, Microservices-lite approach, leveraging containerization and managed cloud services to ensure scalability, reliability, and automated delivery.
Target Production Architecture

The production environment is hosted on GCP and relies on four primary components:

    Containerization: The application is packaged as a Docker Image.

    Orchestration: Google Kubernetes Engine (GKE) manages container deployment, scaling, and networking.

    CI/CD: GitHub Actions automates the entire delivery process.

    Data Tier: A Managed Database Service handles MongoDB data persistence securely.

💻 Technology Stack
Application Stack
Component	Technology	Description
Backend	Node.js, Express	Core application runtime and web framework.
Database	MongoDB (Mongoose)	NoSQL database for flexible, scalable data storage.
Frontend	EJS, HTML/CSS/JS	Templating engine and static assets (including FullCalendar).
Authentication	Passport.js	Handles session management and local strategy authentication.
DevOps Stack
Component	Technology	Purpose
Containerization	Docker	Packages the application and its dependencies.
Local Environment	Docker Compose	Orchestrates local application and database for development.
CI/CD	GitHub Actions	Automates the build, test, and deployment workflow.
Infrastructure	Terraform	Infrastructure as Code (IaC) for provisioning GKE, networking, and database.
Deployment Target	GCP (GKE, Artifact Registry)	Managed Kubernetes cluster and secure container image storage.
🚀 DevOps Implementation & Pipeline

The project follows a full CI/CD pipeline implemented across four phases:
Phase 1: Containerization (Docker)

The application is containerized to create an immutable artifact.

    Dockerfile: Defines the build process, starting from a node:16-slim base image, installing dependencies, and exposing the application on port 3000.

    Database Config: The app.js file was updated to use the environment variable MONGO_URI, enabling dynamic connection strings for different environments (local vs. cloud).

    Local Testing: docker-compose.yml defines two services (app and mongodb) in a local network, allowing developers to run the entire stack with a single command (docker compose up -d).

Phase 2: Continuous Integration (CI)

The CI process ensures code quality and creates the deployable artifact.

    Tool: GitHub Actions.

    Process: On every push, the pipeline checks out the code, builds the Docker Image, and pushes the uniquely tagged image (using the commit SHA) to GCP Artifact Registry.

Phase 3: Infrastructure as Code (IaC)

The cloud infrastructure is provisioned and managed entirely through code, ensuring repeatability and easy scaling.

    Tool: Terraform.

    Provisioning: Terraform scripts are used to provision:

        A Google Kubernetes Engine (GKE) Cluster.

        A Managed Database Instance (e.g., Cloud SQL or a third-party MongoDB service).

        A Kubernetes Secret to inject the secure database connection string into the application container.

Phase 4: Continuous Deployment (CD)

The CD process automatically deploys the new image version to the live environment.

    Tools: GitHub Actions (Orchestration) and Kubernetes.

    Process: The CI/CD workflow:

        Authenticates with GCP using Workload Identity Federation (WIF).

        Fetches GKE Cluster credentials.

        Updates the IaC/manifests/k8s-deployment.yaml file with the latest image tag.

        Applies the Deployment and Service manifests using kubectl, initiating a Rolling Update on the GKE cluster.

🧪 Local Testing Commands (Docker Compose)

These commands are used to quickly build, run, and manage your application stack (Node.js app + MongoDB) on your local machine using Docker Compose (Project 2).
Command	Purpose
1. Build & Run	Builds the Docker image and starts both the app and mongodb services in the background. Use this first.

        docker compose up --build -d
   
2. Check Status	Shows the current state of your running containers.

        docker compose ps	

3. View Logs	View the streaming output from your application container (useful for debugging startup issues).

        docker compose logs -f app	

4. Stop Services	Stops the containers but preserves the data volume.

        docker compose stop	

5. Clean Up	Stops and removes all containers, networks, and persistent volumes (including MongoDB data). Use with caution.

        docker compose down -v	


🚀 Production Deployment Commands (CI/CD)

The production deployment is primarily automated via GitHub Actions (Project 3 & 4), but you may need to execute the Terraform commands manually to set up the infrastructure initially.
A. Infrastructure Setup (Terraform IaC)

These commands provision your GKE Cluster and other cloud resources on GCP. These are run once (or whenever infrastructure changes).
Command	Purpose
1. Initialize	Downloads provider plugins and initializes the Terraform state. Run this first.

        terraform init IaC/terraform	

2. Plan Changes	Generates an execution plan, showing exactly what resources will be created/modified in GCP.

        terraform plan -var="gcp_project_id=YOUR_PROJECT_ID" IaC/terraform	

3. Apply Changes	Executes the plan, creating the GKE cluster, database, and necessary credentials.

        terraform apply -var="gcp_project_id=YOUR_PROJECT_ID" IaC/terraform	

4. Clean Up Infra	DELETES ALL PROVISIONED RESOURCES (GKE, DB, etc.). Use with extreme caution.

        terraform destroy -var="gcp_project_id=YOUR_PROJECT_ID" IaC/terraform	

B. Automated Deployment (GitHub Actions)

Once the infrastructure is set up, the application deployment is automated.
Command	Purpose
1. Trigger CI/CD	The primary deployment command. Pushing code triggers the entire automated pipeline (Build, Push to Artifact Registry, Deploy to GKE).

        git push origin main	

2. Manual Trigger	If your pipeline includes the workflow_dispatch trigger, this command can start the deployment without a code change.

        gh workflow run gcp-ci-cd.yml -f branch=main	

3. Verify Deployment	Command to check the status of your rolling update deployment on the GKE cluster (run from a machine with kubectl configured).

        kubectl rollout status deployment/app-management-deployment	

4. Get Load Balancer IP	Command to retrieve the public IP address of your application once the service is running.

        kubectl get service app-management-service
