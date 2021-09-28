KUBERNETES INSTALLATION AND APPLICATION DEPLOYMENT

                       The goal is to install kubernetes in the local environment and configure the master and worker nodes on this kubernetes cluster. Post the successful installation of the cluster deploy a simple application with replicas and expose the node.

 PLAYBOOKS DESCRIPTION:

                        There are two main playbooks as part of this repository. First playbook is the kube_install.yaml file. This playbook will invoke 2 roles that is the k8s_master and k8s_worker. The k8s_master role will install docker, kubernetes, configure the network and make necessary changes to the required files and bring up the master node. Also it will be generate the token which is required to join the master and worker nodes. During execution, a prompt will be provided to take note of the token and provide it as input before executing the worker node.

                        Command:
                                     ansible-playbook kube_insyall.yaml -vvv

                        
                        The application_deploy.yaml is the manifest file to deploy the application in the worker node. This playbook will pull the vad1mo/hello-world-rest and create a deployment in the cluster with 3 replicas. The node will have the simple application hello-world-test running in port 31000.

                        Command:
                                      kubectl apply -f application_deploy.yaml

