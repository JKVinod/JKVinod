🚀 GitLab CI/CD Pipeline for Kubernetes Manifest Validation
📄 Overview
This repository implements a comprehensive GitLab CI/CD pipeline designed to validate various Kubernetes configurations, including:

ArgoCD Applications

Helm Charts

Kustomize-based Deployments

The pipeline ensures that all infrastructure code changes are validated before merge by running dry-runs, linting, and rendering tests using respective tools like argocd, helm, kube-linter, and kubectl kustomize.

All jobs are executed using a shared GitLab Runner tagged test-runner.

🧬 Pipeline Structure
The GitLab CI pipeline contains a single stage: verify, with three separate jobs:

validate_argocd.yaml – Validates changes to ArgoCD apps.

validate-helm-charts.yaml – Validates changes to Helm charts.

verify-kustomization.yaml – Validates changes to Kustomize deployments.

All jobs follow this sequence:

Detect Changes: Using git diff-tree to compare the current branch to the target branch.

Filter Relevant Files: Based on patterns such as apps-manifests, base, overlays.

Validate: Run the relevant tool to validate changed configurations.

🧪 Detailed Job Descriptions
1. ✅ validate-argocd.yaml
Purpose: Performs a dry run sync on ArgoCD applications that were changed in the merge request.

Steps:

Fetches the latest files from the main branch.

Compares changes using:

bash
Copy
Edit
git diff-tree --name-only -r origin/$CI_MERGE_REQUEST_TARGET_BRANCH_NAME -r $CI_COMMIT_SHA > files.txt
Filters for changes under the apps-manifests path.

Extracts the app name from the file path.

Executes an ArgoCD dry-run sync:

bash
Copy
Edit
argocd app sync <app_name> --dry-run
Uses an ArgoCD token ($ARGOCD_TOKEN) to authenticate against a configured ArgoCD server.

🛑 Note: Dry-run using values.override.yaml is currently not supported, and hence omitted.

2. ✅ validate-helm-charts.yaml
Purpose: Validates and renders Helm charts that have been modified, with additional linting using kube-linter.

Steps:

Identifies changed files in directories related to Helm charts (base, overlays).

For each such change:

Runs kube-linter against the directory containing the file.

Determines whether Chart.yaml or values.override.yaml was changed.

If Chart.yaml is found:

bash
Copy
Edit
helm template <directory>
If values.override.yaml is found:

Locates the associated Chart.yaml.

Renders the Helm chart with overrides:

bash
Copy
Edit
helm template <chart-path> -f values.override.yaml
⚠️ Logs clear errors if chart files are missing to help catch structural issues in the chart layout.

3. ✅ verify-kustomization.yaml
Purpose: Validates Kustomize configurations for any changes under base or overlays directories.

Steps:

Identifies changes under relevant directories.

Locates the nearest kustomization.yaml file.

Renders manifests using:

bash
Copy
Edit
kubectl kustomize <directory>
💡 This catches misconfigurations in overlays or base setups before changes are merged into main.


📌 Summary
This pipeline enforces configuration validation by catching rendering, linting, and logical errors before merge, it helps teams:

Prevent production misconfigurations

Improve PR quality and review confidence

Streamline ArgoCD application maintenance

