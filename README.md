# Customer360 Solution

## Overview

TBD

## Deploying using Docker-Compose

1. Deploy the Customer360 solution stack:

   > For your initial deployment of the stack, we recommend you make no changes to the `docker-compose.yaml` file to ensure you have a successful first-time deployment.

   a. To start the stack, go to your local `ping-celero/customer360/` directory and enter:

   ```shell
   docker-compose up -d
   ```

   The full set of our DevOps images is automatically pulled from our repository, if you haven't already pulled the images from [Docker Hub](https://hub.docker.com/u/pingidentity/).

   b. Use this command to display the logs as the stack starts:

   ```shell
   docker-compose logs -f
   ```

   Enter `Ctrl+C` to exit the display.

   c. Use either of these commands to display the status of the Docker containers in the stack:

   * `docker ps` (enter this at intervals)
   * `watch "docker container ls --format 'table {{.Names}}\t{{.Status}}'"`

   Refer to the [Docker Compose documentation](https://docs.docker.com/compose/) for more information.

2. Log in to the management consoles for the products:

   * Ping Data Console for PingDirectory
     * Console URL: `https://localhost:8443/console`
     * Server: pingdirectory
     * User: Administrator
     * Password: 2FederateM0re

   * PingFederate
     * Console URL: `https://localhost:9999/pingfederate/app`
     * User: Administrator
     * Password: 2FederateM0re

   * Ping Data Console for DataSync
     * Console URL: `https://localhost:8443/console`
     * Server: pingdatasync
     * User: Administrator
     * Password: 2FederateM0re

   * PingCentral
     * Console URL: `https://localhost:9022`
     * User: Administrator
     * Password: 2Federate

3. When you no longer want to run the solution, you can either stop or remove the stack.

   To stop the running stack (doesn't remove any of the containers or associated Docker networks), enter:

   ```bash
   docker-compose stop
   ```

   To stop the stack and remove all of the containers and associated Docker networks, enter:

   ```bash
   docker-compose down
   ```

   To remove the persisted volumes (removing any configuration changes you may have done)

   ```bash
   docker volume prune
   ```
