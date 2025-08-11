# Enterprise ready container/project building workflow

This *watchman-workflow* `watchman-linus` oversees pipelines running on linux runners.

## watchman/doozer/inspector workflow pattern

The code repository defines build instructions for multiple project pipelines.
Build instructions themselves may be varied, such as `configure/make`, `mvn deploy`,
`DockerFile`, or a simple script `build.sh`.

When code is updated via `push` or `pull-request` this *watchman-workflow* selects the
*build-pipeline* folders, that have changed and generates a matrix of jobs building
each one individually.

When each *build-pipeline* job has completed, the *doozer-workflow* hands off to an *inspector-workflow*.
The *inspector-workflow* is selected according to the type of item generated. The inspector
workflows are also provided by the *harbour-master*.

- `.github/workflows/insepct-keg.hm.yml`
- `.github/workflows/inspect-flagon.hm.yml`
- `.github/workflows/inspect-sack.hm.yml`

## Build-Pipeline Folder Structure

**Three layers of folder structure is open to interpretation:**

- `<type>/<team-name>/<owner>/<project>/...`
- `<type>/<portfolio>/<project>/<component>/...`
- `<type>/<supplier>/<base-image>/<version>/...`

## Build-Pipeline Configuration Details

### Pipeline Values: BRANCH_CONFIG

Some settings are provided globally for all pipelines, but may be overridden;
for example a default RUNNER and default target PUSH_REGISTRY_HOST.

The branch that is updated IS significant, there are default `config/*.branch.env` files
for each branch prefix. The value of BRANCH_CONFIG is automatically set to one of these.
e.g. `config/main.branch.env`, `config/experimental.branch.env`, or `config/release.branch.env`.

While this cannot be overriden, each pipeline, can provide their own `*.branch.env` files.

```
branch_config="$(find_var BRANCH_CONFIG default: "${branch%%/*}.branch.env")"
```

### Pipeline Values: CONFIG

Each pipeline can modify global config values by providing their own `*.env` files. The first
item looked up in the config files is `CONFIG` which indicates the file to use as the
pipeline environment to use for all branches. The default value is `CONFIG=default.env`.

The search for the value of `CONFIG`, assuming `BRANCH_CONFIG == main.branch.env` follows:

1. pipelines/my-team/me/my-project/.env
2. pipelines/my-team/me/my-project/config/.env
3. pipelines/my-team/me/my-project/main.branch.env
4. pipelines/my-team/me/my-project/config/main.branch.env
5. config/main.branch.env
6. = default.env

```
config="$(find_var CONFIG default: 'default.env' \
                          search: $PIPELINE/.env           $PIPELINE/config/.env \
                                  $PIPELINE/$branch_config $PIPELINE/config/$branch_config \
                                  config/$branch_config)"
```

### Pipeline Values: RUNNER

The second value required is RUNNER, which selects the pipeline job runner to use for the build.
The search for the value of RUNNER, assuming `BRANCH_CONFIG == main.branch.env`, and 
`CONFIG=default.env` follows, in priority order:

1. pipelines/my-team/me/my-project/.env
2. pipelines/my-team/me/my-project/config/.env
3. **pipelines/my-team/me/my-project/default.env**
4. **pipelines/my-team/me/my-project/config/default.env**
5. pipelines/my-team/me/my-project/main.branch.env
6. pipelines/my-team/me/my-project/config/main.branch.env
7. config/main.branch.env

```
runner="$(find_var RUNNER default: 'none' \
                          search:  $PIPELINE/.env           $PIPELINE/config/.env \
                                   $PIPELINE/$config        $PIPELINE/config/$config \
                                   $PIPELINE/$branch_config $PIPELINE/config/$branch_config \
                                   config/$branch_config)"
```

