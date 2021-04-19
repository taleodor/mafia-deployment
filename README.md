# Mafia Card Shuffle

This is a deployment project for Mafia Card Shuffle (simple card and player order shuffle for a classic Mafia game). You can find deployed project at [https://mafia.brolia.com](https://mafia.brolia.com).

Component projects:
- UI project: [mafia-vue](https://github.com/taleodor/mafia-vue).
- Back-end project: [mafia-express](https://github.com/taleodor/mafia-express).

Deployment is managed via [Reliza Hub](https://relizahub.com).

Writeup on CI/CD integration with Reliza Hub: https://itnext.io/building-kubernetes-cicd-pipeline-with-github-actions-argocd-and-reliza-hub-e7120b9be870


# Deployment via docker-compose
1. Clone this project
2. cd compose
3. docker-compose up -d

Your server will be listening on port 8081 (edit port mapping in docker-compose.yml to change).


# Deployment via kubernetes
1. Clone this project
2. kubectl create namespace mafia
3. kubectl apply -f k8s_production/


# Other
Any contributions are welcome!

