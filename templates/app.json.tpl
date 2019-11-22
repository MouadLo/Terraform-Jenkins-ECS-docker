[
  {
    "essential": true,
    "memory": 256,
    "name": "shop-app",
    "cpu": 256,
    "image": "${REPOSITORY_URL}:${APP_VERSION}",
    "workingDirectory": "/usr/src/app",
    "command": ["yarn", "run", "start"],
    "portMappings": [
        {
            "containerPort": 3000,
            "hostPort": 3000
        }
    ]
  }
]

