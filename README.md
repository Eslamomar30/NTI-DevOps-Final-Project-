# 🚀 DevOps Final Project

This project demonstrates a full end-to-end DevOps pipeline on AWS using Terraform, Kubernetes, Jenkins, Docker, Ansible, and monitoring tools. It showcases infrastructure automation, container orchestration, CI/CD, security practices, and observability.

---

## ✅ 1. Terraform (Infrastructure as Code)

Terraform is used to provision the entire cloud environment on AWS:

- Create an **EKS cluster** with two worker nodes using an Auto Scaling Group and an ELB.
- Deploy an **RDS database** and store credentials securely in **AWS Secrets Manager**.
- Launch an **EC2 instance** to host Jenkins.
- Configure **AWS Backup** to take daily snapshots of the Jenkins instance.
- Enable **access logs** for the ELB and store them in **S3**.
- Create a private **ECR** repository for container images.

---

## ✅ 2. Ansible (Configuration Management)

Ansible automates configuration across EC2 instances:

- Install and configure **Jenkins** and required plugins.
- Install the **CloudWatch agent** on all EC2 instances for metrics and log collection.

---

## ✅ 3. Docker (Containerization)

- Build **Docker images** for the application code.
- Create a **Docker Compose** file to run the full application stack locally for testing.

---

## ✅ 4. Kubernetes (Orchestration)

- Write Kubernetes **manifest files** and deploy them to the AWS EKS cluster.
- Implement **Network Policies** to restrict traffic and improve pod-to-pod security.

---

## ✅ 5. Jenkins (CI/CD Pipeline)

A **multi-branch pipeline** triggers on every push to GitHub:

### Pipeline Stages:
1. Run **SonarQube** quality analysis and fail if the quality gate is not passed.
2. Build the Docker image and scan it with **Trivy**.
3. Push the scanned image to **Amazon ECR**.
4. Deploy the updated image to the Kubernetes cluster using **Helm charts**.

---

## ✅ 6. Monitoring (Prometheus & Grafana)

- Deploy **Prometheus** to monitor pods, nodes, and cluster metrics.
- Configure **alerts** for CPU and memory usage above **80%**.
- Visualize metrics in **Grafana** dashboards showing application health and performance.

---

## 🧩 Tools & Technologies Used

- Terraform
- Docker & Docker Compose
- Kubernetes & Helm
- Jenkins & SonarQube
- Trivy
- Prometheus & Grafana
- AWS (EKS, EC2, RDS, ECR, S3, Secrets Manager, CloudWatch, Backup)

---

## 🎯 What This Project Demonstrates

- Infrastructure as Code automation
- Secure container deployment practices
- Continuous integration and delivery
- Vulnerability scanning and compliance checks
- Kubernetes security policies
- Cloud resource monitoring and alerting
- Real-time observability dashboards

---

## 📌 Conclusion

This project represents a complete DevOps workflow — from code commit to container deployment, security scanning, automated infrastructure provisioning, and continuous monitoring. It applies automation, cloud security best practices, and scalable design within a production-like environment.
