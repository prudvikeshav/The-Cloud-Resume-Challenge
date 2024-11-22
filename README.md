# Cloud Resume Challenge

Welcome to my **Cloud Resume Challenge** repository! This project is part of a learning challenge designed to demonstrate my knowledge and skills in cloud computing, web development, and infrastructure as code (IaC). The goal of this challenge is to create a personal resume website hosted on a cloud platform, incorporating modern cloud technologies and best practices.

## Table of Contents

1. [Overview](#overview)
2. [Technologies Used](#technologies-used)
3. [Architecture](#architecture)
4. [Setup and Installation](#setup-and-installation)
5. [Live Demo](#live-demo)

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
4. **Backend**:
    - **Lambda** will run a Python script that increments the visitor count each time it is triggered by an HTTP request from your web application.
    - **AWS API Gateway** will expose an API endpoint that your web app can call to trigger the Lambda function.
    - **AWS DynamoDB** will store the visitor count in a database, with the ability to retrieve and update it.
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
    git clone https://github.com/prudvikeshav/The-Cloud-Resume-Challenge.git
    cd The-Cloud-Resume-Challenge
    ```

2. **Set up GitHub Secrets**:
    To deploy using GitHub Actions, you'll need to configure your **AWS credentials** in GitHub Secrets:
    - Navigate to your GitHub repository.
    - Go to **Settings** → **Secrets** → **New repository secret**.
    - Add the following secrets:
        - **AWS_ACCESS_KEY_ID**: Your AWS access key ID.
        - **AWS_SECRET_ACCESS_KEY**: Your AWS secret access key.
        - **AWS_REGION**: The AWS region where your resources will be deployed (e.g., `us-east-1`).
        - **AWS_S3_BUCKET_NAME**: The S3 Bucket Name.

3. **GitHub Actions Workflow**

    The **GitHub Actions** workflow is defined in `.github/workflows/Infracreation.yml`.

    This workflow will automatically run when you push changes to the `main` branch.

    - The workflow does the following:
      1. Checkout code from the repository.
      2. Set up Terraform.
      3. Run `terraform init` to initialize Terraform.
      4. Run `terraform apply -auto-approve` to apply the configuration.
      5. GitHub Action syncs local files (e.g., frontend files) to an S3 bucket
      6. GitHub Action invalidates the CloudFront cache, ensuring that the latest changes are reflected to users immediately after deployment.

4. **Running the Workflow**

    - Push changes to the `main` branch of your repository.

      Example:

      ```bash
      git add .
      git commit -m "Initial commit"
      git push origin main
      ```

    - The GitHub Actions workflow will automatically start and provision the infrastructure.

5. **Verify the Infrastructure**

    - Once the workflow completes, verify that the infrastructure has been provisioned (e.g., check AWS S3 or other resources defined in the Terraform configuration).
    - Update the Output url genreated after terraform in vistorcount.js file.

6. **Troubleshooting**

    - If the workflow fails, check the GitHub Actions logs for any errors.
    - Ensure your AWS credentials and region are set correctly in GitHub Secrets.

7. **Conclusion**

    This setup automates infrastructure provisioning using Terraform and GitHub Actions for your Cloud Resume project. You can modify the Terraform configuration to customize the cloud resources for your project needs.

## Live Demo

The project is live at:
[Live resume](https://www.prudhvikeshav-cloudresume.info)
Thank you for checking out my Cloud Resume Challenge project! 🚀
