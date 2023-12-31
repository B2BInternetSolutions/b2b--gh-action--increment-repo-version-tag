# b2b--gh-action--increment-repo-version-tag
Automatically increments the repositories version TAG.

For example, in our case for each module our versions correspond to [framework version number]. [Major version]. [Minor Version]: '8.0.15.45' or '11.0.56.23'or '13.0.1.4'.

This action incrementally updates the minor version so that '8.0.15.45' becomes '8.0.15.46'.

## Input parameters

These are the parameters you can use with the action:

- `flag_branch`: [optional] Flag indicating that the script should look for the lastest tag depending on the branch to which the merge is made. That is, if we are in the branch '8.0' and a merge of a PR is made, it will take the last tag '8.0.15.45' and not '11.0.56.23'.
- `message`: [optional] Message for the tag
- `prev_tag`: [optional] String to be added before the final tag, for example this parameter takes the value 'v' the final tag will be 'v8.0.15.45'.

## Output parameters

These are the parameters you can use from the action:

- `new_tag`: Value of the new tag applied to the repo.
- `previous_tag`: Value of the tag prior to the new_tag being applied to the repo.

## Usage

You can use a workflow like this:

```yaml
name: Tagging

on:
  push:
    branches: 'main'

jobs:
  build:
    name: Bump tag
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2

    - name: Create an incremental release
      uses: B2BInternetSolutions/b2b--gh-action--increment-repo-version-tag@master
      with:
        flag_branch: true
        message: Bump version
        prev_tag: 'v'
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
