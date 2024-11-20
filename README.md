# Cloud Resume Challenge

Welcome to my **Cloud Resume Challenge** repository! This project is part of a learning challenge designed to demonstrate my knowledge and skills in cloud computing, web development, and infrastructure as code (IaC). The goal of this challenge is to create a personal resume website hosted on a cloud platform, incorporating modern cloud technologies and best practices.

## Table of Contents

1. [Overview](#overview)
2. [Technologies Used](#technologies-used)
3. [Architecture](#architecture)
4. [Setup and Installation](#setup-and-installation)
5. [Live Demo](#live-demo)
6. [Challenge Details](#challenge-details)


## Overview

This project showcases my ability to design, deploy, and manage cloud-based infrastructure for hosting a static personal resume website using **Amazon Web Services (AWS)**. The website is built with **HTML, CSS**, and **JavaScript**, and deployed to AWS using a combination of key cloud services. This project also demonstrates my skills in **Infrastructure as Code (IaC)**, **serverless architecture**, and **continuous deployment**.

Key services used in this project:

- **AWS S3** (for static website hosting)
- **AWS CloudFront** (for content delivery)
- **AWS Lambda** ( for dynamic content)
- **AWS API Gateway** ( for serverless API)
- **AWS Route 53** (for DNS management)
- **AWS IAM** (for security and access management)
- **AWS ACM (Certificate Manager)** (for securing the site with HTTPS)

## Technologies Used

### Frontend

- **HTML**: Structure and content of the website.
- **CSS**: Styling and layout of the resume site.
- **JavaScript**:  visitor counter

### Cloud Infrastructure

- **AWS S3**: Used for hosting static files (HTML, CSS, JavaScript).
- **AWS CloudFront**: Content Delivery Network (CDN) to distribute static content globally.
- **AWS Lambda**  Serverless computing for dynamic content like visitor count.
- **AWS API Gateway** Manages API requests for Lambda functions.
- **AWS DynamoDB** Stores the visitor count in a database.
- **AWS Route 53**: DNS management for custom domain setup.
- **AWS IAM**: Identity and Access Management for secure access control.
- **AWS ACM**: Secure the website with HTTPS certificates.

### Infrastructure as Code (IaC)

- **Terraform** : Automates and manages the provisioning of AWS resources.

### CI/CD

- **GitHub Actions**: For automating the deployment and ensuring continuous integration and delivery.

## Architecture

1. **Frontend Hosting**: Static files (HTML, CSS, and JavaScript) are hosted on **AWS S3** as a static website.
2. **Content Delivery**: **AWS CloudFront** is used to deliver the content globally with low latency.
3. **DNS Management**: **Route 53** is used for domain name management and custom domain mapping.
4. **Backend**:   **Lambda** will run a Python script that increments the visitor count each time it is triggered by an HTTP request from your web application.
 **AWS API Gateway** will expose an API endpoint that your web app can call to trigger the Lambda function.
**AWS DynamoDB** will store the visitor count in a database, with the ability to retrieve and update it.
5. **Security**: The site is secured using **AWS ACM** with HTTPS, **AWS IAM** for access control.


## Setup and Installation

### Prerequisites

- An **AWS** account.
- **Terraform** installed for Infrastructure as Code (IaC).
- A **GitHub repository** to store and manage your code.
- **GitHub Actions** enabled for CI/CD automation.
- An IAM user with sufficient permissions for Terraform and AWS resources (e.g., S3, CloudFront, Lambda, Route 53).

### Steps

1. **Clone this repository**:

    ```bash
    git clone https://github.com/yourusername/cloud-resume-challenge.git
    cd cloud-resume-challenge
    ```

2. **Set up GitHub Secrets**:
    To deploy using GitHub Actions, you'll need to configure your **AWS credentials** in GitHub Secrets:
    - Navigate to your GitHub repository.
    - Go to **Settings** → **Secrets** → **New repository secret**.
    - Add the following secrets:
        - **AWS_ACCESS_KEY_ID**: Your AWS access key ID.
        - **AWS_SECRET_ACCESS_KEY**: Your AWS secret access key.
        - **AWS_REGION**: The AWS region where your resources will be deployed (e.g., `us-east-1`).

3. **Configure GitHub Actions Workflow**:
    In your repository, there is a `.github/workflows/terraform.yml` file that defines the CI/CD pipeline using GitHub Actions. It will automatically trigger the deployment when changes are pushed to the repository.

    Here’s an example of the `terraform.yml` file for GitHub Actions:

    ```yaml
    name: Terraform Deployment

    on:
      push:
        branches:
          - main  # Trigger the workflow when changes are pushed to the main branch
      pull_request:
        branches:
          - main  # Trigger the workflow for pull requests to the main branch

    jobs:
      terraform:
        runs-on: ubuntu-latest

        steps:
        - name: Checkout code
          uses: actions/checkout@v2

        - name: Set up Terraform
          uses: hashicorp/setup-terraform@v1
          with:
            terraform_version: 1.3.0  # Specify your Terraform version

        - name: Terraform init
          run: terraform init

        - name: Terraform plan
          run: terraform plan

        - name: Terraform apply
          run: terraform apply -auto-approve
          env:
            AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
            AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
            AWS_REGION: ${{ secrets.AWS_REGION }}
    ```

    This GitHub Actions workflow will:
    - Check out the code from the repository.
    - Set up Terraform.
    - Run `terraform init`, `terraform plan`, and `terraform apply` commands to deploy your infrastructure.



---

### Notes

- The **Terraform** configuration files (e.g., `main.tf`) should be set up in your repository to define all necessary AWS resources.
- Ensure that your **IAM user** has the correct permissions to create and manage AWS resources like S3, CloudFront, Lambda, API Gateway, and Route 53.

By following these steps, your deployment will be fully automated using **GitHub Actions**. Every time you push changes to the repository (e.g., a new update to your resume), the GitHub Actions pipeline will automatically deploy the new version of your site to AWS.

---

This updated section reflects the use of **GitHub Actions** for automating the Terraform deployment process, providing a seamless **CI/CD** experience.
## Live Demo

The project is live at:
[Your live resume URL](https://www.prudhvikeshav-cloudresume.info)

## Challenge Details

This project is part of the **Cloud Resume Challenge**, a learning exercise designed to explore and practice key cloud computing and DevOps principles, including:

- Hosting static websites on cloud platforms (AWS)
- Using serverless architecture for backend logic (AWS Lambda)
- Automating deployments and infrastructure management via IaC (Terraform, CloudFormation)
- Implementing CI/CD pipelines for continuous deployment
- Securing web applications with HTTPS
- Configuring DNS with Route 53 and managing custom domains



---

Thank you for checking out my Cloud Resume Challenge project! 🚀
