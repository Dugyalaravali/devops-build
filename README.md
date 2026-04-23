1. Project Title & Overview

React Application: CI/CD & Automated Monitoring

This project demonstrates a production-grade DevOps lifecycle for a React application. It automates the process from code commit to deployment on AWS EC2, featuring container promotion and a self-healing monitoring stack.

2. Architecture Diagram
Source Control: GitHub

CI/CD Engine: Jenkins (hosted on EC2)

Containerization: Docker

Registry: Docker Hub (Public for Dev / Private for Prod)

Infrastructure: AWS EC2

deploy on : EC2

Monitoring: Prometheus and Grafana

3. Key Features

Automated Pipeline: Every push to GitHub triggers a Jenkins build.

Container Promotion: Images are first pushed to a Public repo (Dev), then promoted to a Private repo (Prod) upon successful verification.

docker hub url "https://hub.docker.com/repositories/dugyalaravali28"

Zero-Downtime Monitoring: Continuous health probes via Blackbox Exporter.

Alerting System: Automated email notifications via Grafana Alertmanager if the application goes down.

4. Setup & Installation

Prerequisites

AWS Account (EC2 Instance)

Docker & Docker Compose installed

Jenkins installed with Docker Pipeline plugins

5. deployment

appliction deployed on aws ec2 via cicd pipeline.

6. monitoring stacks.

cd monitoring

crete docker compose and promethus yml files.

then run docker compose up -d

7. Monitoring & Health Checks
The application health is monitored at http://13.214.212.171:9090.

Prometheus: Scrapes metrics from Blackbox Exporter.

Grafana Dashboard: Visualizes uptime and response latency.

Alerting Rule: Triggers if probe_success == 0 for more than 1 minute.


