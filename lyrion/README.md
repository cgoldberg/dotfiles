## Running Lyrion Music Server on QNAP QTS Container Station (Docker)

----

### Installation

- Open "Container Station" app
- Open the "Applications" tab
- Click "Create"
- Set an "Application name" (i.e. "lyrion")
- Paste the Docker Compose configuration YAML (lyrion.yml)
- Click "Validate" to ensure the syntax is correct
- Click "Create" (once created, you should see the new application in the list)
- Set restart policy and configure bridge mode networking
  - By default, Container Station exposes only one port per application in a NAT
    configuration. Lyrion uses multiple ports, so we use "bridge mode":
  - Go to "Containers"
  - You'll see one container running (usually something like "lyrion-lms-1")
  - Click the action cog wheel at the right of the container, and select "Edit"
  - Click the "General" tab
  - Choose "Always" for "Restart policy"
  - Click the "Network" tab
  - Click the bin icon to delete the default network
  - Click "Add" to create a new network
  - Choose "Bridge" and select the wanted interface
  - Set a static IP address, by clicking "Use a static IP address"
    and providing the IP. (i.e. 10.0.0.100)
  - Click "Connect" to add the network
  - Click "Apply" to update the container

### Updating the Docker image

- Go to "Images" and click on the cog wheel icon next to
  "lmscommunity/lyrionmusicserver"
- In the drop-down menu, select "Pull" (it will download the latest version)
- Go to "Applications"
- Click the cog wheel icon next to the application
- In the drop-down menu, select "Recreate"
- Verify the `.yml` file and click "Update"
- The application will be undeployed and recreated (all configurations are
  kept as it is mounted in a bind volume)
- Remove the old image after deploying
- Set the network configuration to bridge mode again
