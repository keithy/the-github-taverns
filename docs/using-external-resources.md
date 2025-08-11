## Coast-watchman responsibilities:

- Monitor external repos referenced in *flagons* and *kegs*
- Trigger builds when external dependencies change
- Track multiple external repos across different architectures
- Respect frequency limits (poll intervals vs webhooks)

## Implementation strategy:

- New watchman type: `coast-linus.hm.yml`
- PID-based polling with configurable intervals
- Caching previous commits to detect changes
- Opt-in via reference syntax: `external_repo: "watch=github.com/org/repo"`

Doozer: 10-pre-build -> external-repo-loader -> 20-post-build

## Benefits of this approach:

- Reusable: Can use in any *flagon* or *keg* doozer
- Optional: Pipelines can opt-in via adding the hook
- Cache-friendly: Existing pre-build caching strategies apply
- Auth-secure: Hook can handle authentication outside build context

## Defining External Resources with Nickel

We will use Nickel to define external resources. Here's an example of a Nickel configuration file:

```nickel
let trusted_orgs = ["my-company", "kubernetes"];

let resources = {
  my_repo = {
    type = "github";
    org = "my-company";
    repo = "my-repo";
    ref = "v1.2.3";
  },
  my_web_file = {
    type = "web";
    url = "https://example.com/file.tar.gz";
    sha256 = "<sha256_hash>";
  },
  my_other_repo = {
    type = "github";
    org = "kubernetes";
    repo = "kubernetes";
    ref = "main";
  }
};

resources
```

### Resource Types

-   `github`: A GitHub repository.  Requires `org`, `repo`, and `ref` (branch, tag, or commit SHA).
-   `web`: A web-hosted file. Requires `url` and a checksum for verification (e.g., `sha256`).

### Trusted Organizations

The `trusted_orgs` list defines GitHub organizations that are considered safe to use.  This helps preventサプライチェーン攻撃 by limiting the source of external code.

### Checksums

Checksums (e.g., `sha256`) are crucial for verifying the integrity of downloaded files.  The pre-build hook will refuse to use a file if its checksum doesn't match the configured value.