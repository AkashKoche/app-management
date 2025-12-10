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
