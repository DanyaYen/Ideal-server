# Automated Server Provisioning ("Ideal Server")

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-EE0000?style=for-the-badge&logo=ansible&logoColor=white)
![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=white)
![Google Cloud](https://img.shields.io/badge/Google_Cloud-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)

This project demonstrates a complete CI/CD pipeline for fully automating the provisioning and configuration of a cloud server from scratch. It showcases core DevOps principles like Infrastructure as Code (IaC), Configuration Management, and CI/CD automation.

---

### 🎥 Live Demo

**[>>> WATCH THE DEMO VIDEO HERE <<<](https://your-video-link.com)**

---

### 🏗️ Architecture

The diagram below illustrates the workflow of the CI/CD pipeline:

```
+----------------+      +-------------------+      +---------------------------+
|                |      |                   |      |                           |
|  Developer     |----->|   GitHub Repo     |----->|  Jenkins on macOS         |
| (pushes code)  |      | (Jenkinsfile)     |      |  (pulls code & runs pipe) |
|                |      |                   |      |                           |
+----------------+      +-------------------+      +---------------------------+
                                                               |
                                                               | (Executes)
                                                               v
       +-------------------------------------------------------+--------------------------------------------------------+
       |                                                                                                                |
       v                                                                                                                v
+--------------------------+                                                                                +------------------------------+
|                          |                                                                                |                              |
|   1. Terraform           |------------------------------------------------------------------------------->|   2. Ansible                 |
|   (Provisions Infra)     |   (Creates VM, gets IP, generates inventory)                                   |   (Configures Server)        |
|                          |                                                                                |                              |
+--------------------------+                                                                                +------------------------------+
       |                                                                                                                |
       v                                                                                                                v
+--------------------------+                                                                                +------------------------------+
|                          |                                                                                |                              |
|   GCP Compute Engine     |                                                                                |   Docker on VM               |
|   (VM is created)        |                                                                                |   (Nginx container is running)|
|                          |                                                                                |                              |
+--------------------------+                                                                                +------------------------------+

```

---

### ✨ Key Features

* **Infrastructure as Code (IaC):** The entire cloud infrastructure (GCP Compute Instance, Firewall Rules) is defined declaratively using **Terraform**.
* **Configuration Management:** The server is configured automatically using an **Ansible** playbook, which installs Docker and runs an Nginx container.
* **CI/CD Automation:** A **Jenkins** pipeline automatically executes the entire workflow, from provisioning to configuration, triggered with a single click.
* **Dynamic Inventory:** The Jenkins pipeline dynamically retrieves the public IP of the newly created server from Terraform's output and uses it to generate an inventory file for Ansible on the fly.

---

### 🛠️ Technologies Used

* **IaC:** Terraform
* **Configuration Management:** Ansible
* **CI/CD:** Jenkins
* **Cloud Provider:** Google Cloud Platform (GCP)
* **Containerization:** Docker

---

### 🚀 How to Run the Pipeline

1.  **Prerequisites:**
    * A Google Cloud Platform (GCP) account with billing enabled.
    * `gcloud` CLI installed and configured.
    * Terraform and Ansible installed locally.
    * Jenkins installed and running locally.

2.  **Clone the Repository:**
    ```bash
    git clone https://github.com/DanyaYen/Ideal-server.git
    cd Ideal-server
    ```

3.  **Configure Credentials:**
    * Authenticate with GCP for Terraform:
        ```bash
        gcloud auth application-default login
        ```
    * Add your GCP credentials (`~/.config/gcloud/application_default_credentials.json`) and your SSH private key (`~/.ssh/id_rsa`) to Jenkins Credentials as `gcp-credentials` and `ssh-key` respectively.

4.  **Run the Jenkins Pipeline:**
    * Create a new "Pipeline" job in Jenkins.
    * Configure it to use "Pipeline script from SCM".
    * Point it to this GitHub repository.
    * Click "Build Now".

---

### 🎓 Key Learnings & Challenges

* **Environment Differences:** A major challenge was adapting the `Jenkinsfile` to run on different environments (a Linux-based Docker container vs. a native macOS installation). This involved switching package managers (`apt-get` to `brew`) and handling `PATH` variable differences by using full binary paths.
* **State Management:** Debugging Ansible's "address already in use" error highlighted the importance of clean state management. The playbook was modified to only manage the Dockerized application, and the host was cleaned of conflicting services.
* **Pipeline Orchestration:** Writing a robust `Jenkinsfile` that seamlessly passes output from one stage (Terraform's IP address) as input to another (Ansible's inventory) was a key learning experience.