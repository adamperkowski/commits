# commits
[commits]: #commits

hii these are the commit conventions (and tools) that i use in my projects

see [CONVENTIONS.md](./CONVENTIONS.md) for details

## check-commit-message
[check-commit-message]: #check-commit-message

this is a bash script to validate your commit messages before pushing

you can run the latest version directly with

```bash
curl -sSL https://commits.adamperkowski.dev |
  SCOPES="scope1 scope2" \
  bash -s -- \
  "<message>"
```

### usage
[usage]: #usage

```bash
# check last git commit
SCOPES="scope1 scope2" check-commit-message "$(git log -1 --pretty=%B)"
```

### environment variables
[environment variables]: #environment-variables

| name     | description                                         | required |
|----------|-----------------------------------------------------|----------|
| `SCOPES` | array of allowed scopes (empty = any scope allowed) | no       |

## github actions
[github actions]: #github-actions

you can use [check-commit-message] in your github actions workflows

```yml
- name: check commit message
  uses: adamperkowski/commits@main
  with:
    scopes: 'scope1,scope2'
```

## woodpecker
[woodpecker]: #woodpecker

you can use the [docker image][docker] in your woodpecker ci pipelines

```yml
- name: check commit message
  image: ghcr.io/adamperkowski/commits:latest
  environment:
    SCOPES: "scope1 scope2"
  commands:
    - check-commit-message "$(git log -1 --pretty=%B)"
```

## docker
[docker]: #docker

you can run the docker image directly

```bash
docker run --rm -e 'SCOPES="scope1 scope2"' \
  ghcr.io/adamperkowski/commits:latest \
  check-commit-message "<message>"
```
