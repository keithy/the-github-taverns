
## Steps

- the-github-taverns/the-admiralty-inn/harbour-master.hm.yml
  - `Import env_json`
  - `Verify hooks (${{ inputs.tech }})`
  - `Pre-publish hooks (${{ inputs.tech }})`
  - `Publish hooks (${{ inputs.tech }})`
  - `Post-publish hooks (${{ inputs.tech }})`
  - `Report hooks (${{ inputs.tech }})`

- the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml
  - `Set env name tech`
  - `Pre-build hooks`
  - `buildah bud`
  - `Post-build hooks`
  - `Prepare payload`
  - `Harbour Master Dispatch`

- the-github-taverns/the-coopers-inn/linux/doozer-compose.hm.yml
  - `Set env name tech` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Pre-build hooks` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `docker compose build`
  - `Post-build hooks` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Prepare payload` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Harbour Master Dispatch` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*

- the-github-taverns/the-coopers-inn/linux/doozer-configure-make.hm.yml
  - `Set env name tech` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Pre-build hooks` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `configure && make`
  - `Post-build hooks` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Prepare payload` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Harbour Master Dispatch` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*

- the-github-taverns/the-coopers-inn/linux/doozer-docker.hm.yml
  - `Set env name tech` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Pre-build hooks` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Build image`
  - `Post-build hooks` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Prepare payload` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Harbour Master Dispatch` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*

- the-github-taverns/the-coopers-inn/linux/doozer-dotnet.hm.yml
  - `Set env name tech` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Pre-build hooks` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `dotnet restore`
  - `dotnet build`
  - `dotnet test`
  - `Post-build hooks` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Prepare payload` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Harbour Master Dispatch` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*

- the-github-taverns/the-coopers-inn/linux/doozer-go.hm.yml
  - `Set env name tech` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Setup Go`
  - `Pre-build hooks` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `go build`
  - `go test`
  - `Post-build hooks` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Prepare payload` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Harbour Master Dispatch` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*

- the-github-taverns/the-coopers-inn/linux/doozer-gradle.hm.yml
  - `Set env name tech` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Pre-build hooks` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Gradle assemble`
  - `Gradle test`
  - `Post-build hooks` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Prepare payload` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Harbour Master Dispatch` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*

- the-github-taverns/the-coopers-inn/linux/doozer-maven.hm.yml
  - `Set env name tech` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Pre-build hooks` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `mvn validate`
  - `mvn package`
  - `mvn test`
  - `Post-build hooks` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Prepare payload` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Harbour Master Dispatch` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*

- the-github-taverns/the-coopers-inn/linux/doozer-mise.hm.yml
  - `Set env name tech` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Pre-build hooks` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `mise run`
  - `Post-build hooks` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Prepare payload` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Harbour Master Dispatch` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*

- the-github-taverns/the-coopers-inn/linux/doozer-node.hm.yml
  - `Set env name tech` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `npm ci`
  - `Pre-build hooks` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `npm build`
  - `npm test`
  - `Post-build hooks` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Prepare payload` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Harbour Master Dispatch` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*

- the-github-taverns/the-lighthouse-inn/watchman-linus.hm.yml
  - `Folders changed 4 levels deep`
  - `checkout`
  - `initialize`
  - `Prepare payload` shared: *the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml*
  - `Metadata-driven dispatch`

## Workflows Summary
- the-github-taverns/the-admiralty-inn/harbour-master.hm.yml: steps=6 unique=6 shared=0
- the-github-taverns/the-coopers-inn/linux/doozer-buildah.hm.yml: steps=6 unique=1 shared=0
- the-github-taverns/the-coopers-inn/linux/doozer-compose.hm.yml: steps=6 unique=1 shared=5
- the-github-taverns/the-coopers-inn/linux/doozer-configure-make.hm.yml: steps=6 unique=1 shared=5
- the-github-taverns/the-coopers-inn/linux/doozer-docker.hm.yml: steps=6 unique=1 shared=5
- the-github-taverns/the-coopers-inn/linux/doozer-dotnet.hm.yml: steps=8 unique=3 shared=5
- the-github-taverns/the-coopers-inn/linux/doozer-go.hm.yml: steps=8 unique=3 shared=5
- the-github-taverns/the-coopers-inn/linux/doozer-gradle.hm.yml: steps=7 unique=2 shared=5
- the-github-taverns/the-coopers-inn/linux/doozer-maven.hm.yml: steps=8 unique=3 shared=5
- the-github-taverns/the-coopers-inn/linux/doozer-mise.hm.yml: steps=6 unique=1 shared=5
- the-github-taverns/the-coopers-inn/linux/doozer-node.hm.yml: steps=8 unique=3 shared=5
- the-github-taverns/the-lighthouse-inn/watchman-linus.hm.yml: steps=5 unique=4 shared=1
