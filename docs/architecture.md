
# LoreKeeper — AWS Architecture

**Project:** LoreKeeper — Your Legal Document Companion

**Cloud provider:** Amazon Web Services (AWS)

**Region:** eu-west-2 (London)

**Infrastructure as Code:** Terraform

**Project status:** Prototype development

## 1. Project Overview

LoreKeeper is a privacy-first, serverless AI document
assistant designed to help users understand and organise
legal documents.

The initial prototype focuses on fictional family court
documents from England and Wales.

The application will extract text, identify sensitive
information, allow users to review redactions and provide
AI-generated explanations grounded in approved documents.

LoreKeeper does not provide legal advice.

## 2. Architecture Overview

Planned document processing workflow:

User / Web Interface
    |
    v
Amazon API Gateway
    |
    v
AWS Lambda
    |
    v
Amazon S3 (encrypted with AWS KMS)
    |
    v
Amazon Textract (OCR)
    |
    v
Amazon Comprehend (PII detection)
    |
    v
Privacy Preview (human approval)
    |
    v
Amazon Bedrock (AI assistance)

Supporting services:

- IAM: Identity and access permissions
- DynamoDB: Document metadata and processing status
- CloudWatch: Monitoring and sanitised logs
- Terraform: Infrastructure provisioning
- GitHub Actions: Automated code validation and scanning

## 3. AWS Services

| Service | Purpose |
|---|---|
| Amazon S3 | Private document storage |
| AWS KMS | Encryption key management |
| AWS Lambda | Serverless application processing |
| API Gateway | HTTPS application endpoints |
| Amazon Textract | PDF text extraction and OCR |
| Amazon Comprehend | Personally identifiable information detection |
| Amazon Bedrock | Grounded AI document assistance |
| Amazon DynamoDB | Document metadata and status |
| AWS IAM | Least-privilege access control |
| Amazon CloudWatch | Monitoring and operational logs |

## 4. Security Architecture

LoreKeeper follows privacy-by-design principles.

Security controls include:

- Private S3 storage with Block Public Access enabled
- SSE-KMS encryption using a customer-managed KMS key
- Automatic KMS key rotation
- IAM least-privilege permissions
- Synthetic documents only during development
- Human approval before sending redacted text to Bedrock
- No credentials or Terraform state in public GitHub
- Local and automated secret scanning

Pseudonymisation does not guarantee anonymisation.
Automated PII detection may miss sensitive information.

## 5. Current Implementation

Completed:

- Terraform project initialised
- AWS provider configured for eu-west-2
- Private S3 bucket deployed
- S3 versioning enabled
- S3 Block Public Access configured
- S3 Bucket Owner Enforced configured
- SSE-KMS encryption deployed
- Customer-managed KMS key with automatic rotation
- Terraform code committed to GitHub
- GitHub Actions Terraform validation
- GitHub Actions Gitleaks scanning

## 6. Planned Components

Not yet implemented:

- Lambda upload API
- Amazon API Gateway
- S3 pre-signed upload URLs
- Amazon Textract processing
- Amazon Comprehend PII detection
- Human redaction review
- DynamoDB document tracking
- Bedrock grounded question answering
- Document and page citation verification
- User authentication and authorisation
- Sanitised logging and monitoring
- Retention, deletion and recovery procedures

## 7. Architecture Decisions

### Why serverless?

Serverless services reduce the need to manage servers,
support usage-based pricing and allow independent scaling.

### Why S3?

S3 provides durable object storage with encryption,
access controls and versioning support.

### Why KMS?

KMS provides additional controls over encryption keys,
including auditing, permissions and rotation.

### Why Terraform?

Terraform enables reproducible, version-controlled
infrastructure provisioning.

### Why mandatory redaction approval?

Automated PII detection can miss sensitive details.
Only user-approved redacted text should reach Bedrock.

## 8. Limitations

This is an educational prototype, not a production-ready
legal service.

Only wholly fictional documents are permitted.

Real deployments would require additional authentication,
privacy assessment, security testing, operational controls
and appropriate legal review.
